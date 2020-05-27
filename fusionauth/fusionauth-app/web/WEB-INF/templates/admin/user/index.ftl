[#ftl/]
[#-- @ftlvariable name="searchEngineType" type="java.lang.String" --]
[#-- @ftlvariable name="applications" type="java.util.List<io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="groups" type="java.util.List<io.fusionauth.domain.Group>" --]
[#-- @ftlvariable name="queryString" type="java.lang.String" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.User>" --]
[#-- @ftlvariable name="roles" type="java.util.List<java.lang.String>" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/search.ftl" as search/]

[@layout.html]
  [@layout.head]
  <script src="${request.contextPath}/js/admin/user/BaseUserSearch.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/user/AdvancedUserSearch.js?version=${version}"></script>
  <script src="${request.contextPath}/js/admin/user/UserSearch.js?version=${version}"></script>
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.UserSearch([#if queryString??]"${queryString?js_string?esc}"[#else]null[/#if]);
    });
  </script>
  [/@layout.head]
  [@layout.body]
    <div id="user-search-container">
      [@layout.pageHeader breadcrumbs={"/admin/user/": "users"}]
        <span data-number-selected class="push-right hidden text-larger"><em></em> selected</span>
        [@button.iconLink href="/admin/user/add" color="green" icon="plus" tooltipKey="add"/]
        <div class="bulk-actions inline-block">
          [#-- We need to get the CSRF token into the form so we can pick it up for AJAX posts --]
          [@button.ajaxLink href="/ajax/group/member/add?primeCSRFToken=${request.session.getAttribute('prime-mvc-security-csrf-token')}" color="blue" icon="plus-circle" tooltipKey="add-to-group" additionalClass="square button disabled" ajaxForm=true ajaxWideDialog=true/]
          [@button.ajaxLink href="/ajax/group/member/remove?primeCSRFToken=${request.session.getAttribute('prime-mvc-security-csrf-token')}" color="orange" icon="minus-circle" tooltipKey="remove-from-group" additionalClass="square button disabled" ajaxForm=true ajaxWideDialog=true/]
        </div>
      [/@layout.pageHeader]

      [@layout.main]
        [@panel.full]
            [@control.form action="/ajax/user/search" method="GET" class="full" id="user-search-form"]

              <div class="row">
                 <div class="col-xs-12 col-md-12 tight-left">
                   <div class="form-row">
                     <input type="text" name="queryString" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus placeholder="${function.message('queryString-placeholder')}"/>
                   </div>
                 </div>
               </div>

              [#-- Advanced Search Controls --]
              <div id="advanced-search-controls" class="slide-open">

                [#if tenants?size > 1]
                <div class="row">
                  <div class="col-xs-12 col-md-6 tight-left">
                    [@control.select name="tenantId" labelKey="tenant" items=tenants textExpr="name" valueExpr="id" headerL10n="any" headerValue="" /]
                  </div>
                  <div class="col-xs-12 col-md-6 tight-left">
                    [@control.select items=groups![] name="groupId" textExpr="name" valueExpr="id" headerL10n="any" headerValue=""/]
                  </div>
                </div>
                [#else]
                <div class="row">
                  <div class="col-xs-12 col-md-12 tight-left">
                    [@control.select items=groups![] name="groupId" textExpr="name" valueExpr="id" headerL10n="any" headerValue=""/]
                  </div>
                </div>
                [/#if]

                <div class="row">
                  <div class="col-xs-12 col-md-6 tight-left">
                    [@control.select items=applications name="applicationId" textExpr="name" valueExpr="id" headerL10n="any" headerValue=""/]
                  </div>

                  <div class="col-xs-12 col-md-6 tight-left">
                    [@control.select items=roles![] name="role" headerL10n="any" headerValue=""/]
                  </div>
                </div>

                <div class="row">
                  <div class="col-xs-12 col-md-12 tight-left">
                    <div class="form-row">
                      <label for="show-raw-query">[@message.print key="show-elastic-query"/]</label>
                      <label class="toggle">
                        <input type="checkbox" id="show-raw-query" data-slide-open="raw-query">
                        <span class="rail"></span>
                        <span class="pin"></span>
                      </label>
                      <div id="raw-query" class="slide-open">
                        <label data-label-json="${message.inline('raw-query-label')}" data-label-string="${message.inline('raw-queryString-label')}"></label>
                        <pre class="code pre-wrap">

                        </pre>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <a href="#" class="[#if searchEngineType == 'elasticsearch']slide-open-toggle[#else]hidden[/#if]" data-expand-open="advanced-search-controls">
                <span>[@message.print key="advanced"/] <i class="fa fa-angle-down"></i></span>
              </a>

              <div class="row push-lesser-top push-bottom">
                <div class="col-xs tight-left">
                  [@button.formIcon color="blue" icon="search" textKey="search"/]
                  [@button.iconLinkWithText href="#" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
                </div>
              </div>

          [/@control.form]

          <div id="advanced-search-results"></div>

          <div id="error-dialog" class="prime-dialog hidden">
            [@dialog.basic titleKey="error" includeFooter=true]
              <p>
                [@message.print key="ajax-error"/]
              </p>
            [/@dialog.basic]
          </div>
        [/@panel.full]
      [/@layout.main]
    </div>
  [/@layout.body]
[/@layout.html]