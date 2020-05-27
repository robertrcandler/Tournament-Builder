[#ftl/]
[#setting url_escaping_charset='UTF-8'/]

[#-- @ftlvariable name="pendingConnection" type="boolean" --]
[#-- @ftlvariable name="regenerateKeyActionAvailable" type="boolean" --]
[#-- @ftlvariable name="status" type="io.fusionauth.api.domain.ReactorStatus" --]
[#-- @ftlvariable name="tenants" type="java.util.Map<java.util.UUID, io.fusionauth.domain.Tenant>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/message.ftl" as message/]

[#macro reportCard icon value titleKey]
  <header>
    <h3>[@message.print key=titleKey/]</h3>
  </header>
  <main>
    <i class="fa fa-${icon} background hover"></i>
    [#if (value!0) > 999999999]
      [#assign fontSize = "lg-text" /]
    [#elseif (value!0) > 999999]
      [#assign fontSize = "xl-text" /]
    [#else]
      [#assign fontSize = "xxl-text" /]
    [/#if]
    <p class="${fontSize} text-center">${value?string('#,###')}</p>
  </main>
[/#macro]

[@layout.html]
  [@layout.head]
    <script src="${request.contextPath}/js/admin/Reactor.js?version=${version}"></script>
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.Reactor();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false breadcrumbs={"/admin/reactor/": "reactor"}]
      [#if status.available]
        [#if !pendingConnection]
          [@button.ajaxLink href="/ajax/reactor/regenerate-key?primeCSRFToken=${request.session.getAttribute('prime-mvc-security-csrf-token')}"  id="regenerate-key" color="${status.connected?then('blue', 'orange')}" data_available=status.connected?c icon="refresh" tooltipKey="{tooltip}regenerate" additionalClass="square button" ajaxForm=true ajaxWideDialog=true /]
        [/#if]
        [@button.iconLink href="/admin/reactor/deactivate" icon="minus-circle" color="red" tooltipKey="deactivate"/]
      [/#if]
    [/@layout.pageHeader]

    [@layout.main]
      [#-- Unavailable, activate the Reactor --]
      [#if !status.available]
        [@panel.full titleKey="activate" panelClass="panel orange"]
          <p class="mt-2 mb-4">[@message.print key="{description}purchase"/]</p>
          <div class="col-lg-12 col-md-12 col-sm-12 tight-left mb-4">
            [@control.form action="/admin/reactor/activate" method="POST" class="full tight"]
              [@control.text id="activate-license" name="licenseId" autocapitalize="none" autocomplete="off" autocorrect="off" required=true autofocus="autofocus" includeFormRow=true rightAddonRaw="<button class=\"button blue\"><i class=\"fa fa-arrow-circle-right\"></i> <span class=\"text\">${message.inline('activate')?markup_string}</span></button>"?no_esc/]
            [/@control.form]
          </div>
        [/@panel.full]
      [/#if]

      [#-- Overview --]
      [@panel.full titleKey="overview" panelClass="panel with-panel-actions"]
        [#assign totalActionRequired = status.totalActionRequired()/]

        <div class="row mb-4">
          <div class="col-lg-4 col-md-6 col-xs-12 blue card">
            [@reportCard "lock", status.totalPasswordsChecked(), "total-checked" /]
          </div>
          <div class="col-lg-4 col-md-6 col-xs-12 red card">
            [@reportCard "user-secret", status.totalPasswordsBreached(), "total-breached" /]
          </div>
          <div class="col-lg-4 col-md-6 col-xs-12 orange card">
            [@reportCard "warning", totalActionRequired, "total-remaining-breaches" /]
          </div>
        </div>

        [#if totalActionRequired  > 0 ]
          <fieldset style="border-left: 3px solid orange; padding-left: 15px;">
            <h3>[@message.print key="action-required"/]</h3>
            <p>
             [#if totalActionRequired > 1]
               [@message.print key="reactor-action-required" values=[totalActionRequired?string('#,###')] /]
             [#else]
              [@message.print key="reactor-action-required-single"/]
             [/#if]
            </p>

             [#assign queryString = "_exists_:breachedPasswordStatus AND NOT (breachedPasswordStatus:None)"/]
             <a href="/admin/user/?queryString=${queryString?url}" class="blue button mt-2">
               <i class="fa fa-search"></i>
               [@message.print key="breached-users" /]
             </a>
         </fieldset>
        [/#if]

        <fieldset>
         [@properties.table classes="properties mt-4"]
            <tr>
              <td class="top">
                [@message.print key="status"/]
                [@message.print key="propertySeparator"/]
              </td>
              <td>
                [#if status.available]
                  [#if status.connected]
                   [@message.print key="reactor-available"/] &nbsp; <i class="fa fa-check green-text" data-tooltip="${message.inline("{tooltip}reactor-available")}"></i>
                  [#elseif pendingConnection]
                    [@message.print key="reactor-pending-connection"/] &nbsp; <i class="fa fa-exclamation orange-text" data-tooltip="${message.inline("{tooltip}reactor-pending-connection")}"></i>
                  [#else]
                    [@message.print key="reactor-not-connected"/] &nbsp; <i class="fa fa-exclamation orange-text" data-tooltip="${message.inline("{tooltip}reactor-not-connected")}"></i>
                  [/#if]
                [#else]
                 [@message.print key="reactor-unavailable"/] &nbsp; <i class="fa fa-times red-text" data-tooltip="${message.inline("{tooltip}reactor-unavailable")}"></i>
                [/#if]
              </td>
            </tr>

            [#--  Instance Id --]
            [@properties.rowEval nameKey="instanceId" object=instance propertyName="id" /]

          [/@properties.table]
        </fieldset>

       <fieldset class="mt-4">
        <legend>[@message.print key="tenants"/]</legend>
        <p><em>[@message.print key="{description}tenants"/]</em></p>
        <table class="hover">
          <thead>
          <tr>
            <th>[@message.print key="name"/]</th>
            <th>[@message.print key="enabled"/]</th>
            <th>[@message.print key="total-checked"/]</th>
            <th>[@message.print key="total-breached"/]</th>
            <th>[@message.print key="total-remaining-breaches"/]</th>
          </tr>
          </thead>
          <tbody>
            [#list tenants?values as tenant]
            <tr>
              <td>${properties.display(tenant, "name")}</td>
              <td>${properties.display(tenant.passwordValidationRules.breachDetection, "enabled")}</td>
              <td>${properties.display(status.breachedPasswordMetrics(tenant.id)!{}, "passwordsCheckedCount")}</td>
              <td>${properties.display(status.breachedPasswordMetrics(tenant.id)!{}, "totalBreached()")}</td>
              <td>${properties.display(status.breachedPasswordMetrics(tenant.id)!{}, "actionRequired")}</td>
            </tr>
            [/#list]
          </tbody>
        </table>
      </fieldset>
      [/@panel.full]

    [/@layout.main]
  [/@layout.body]
[/@layout.html]