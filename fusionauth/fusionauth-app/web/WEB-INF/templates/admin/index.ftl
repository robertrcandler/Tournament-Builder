[#ftl/]
[#-- @ftlvariable name="apiKeySetup" type="boolean" --]
[#-- @ftlvariable name="applicationSetup" type="boolean" --]
[#-- @ftlvariable name="dailyActiveUserReport" type="io.fusionauth.app.action.admin.IndexAction.IndexReport" --]
[#-- @ftlvariable name="fusionAuthTenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="loginData" type="io.fusionauth.app.service.ReportUtil.ReportData" --]
[#-- @ftlvariable name="logins" type="io.fusionauth.domain.DisplayableRawLogin[]" --]
[#-- @ftlvariable name="loginReport" type="io.fusionauth.app.action.admin.IndexAction.IndexReport" --]
[#-- @ftlvariable name="proxyConfigReport" type="io.fusionauth.app.action.admin.ProxyConfigTestAction.ProxyConfigReport" --]
[#-- @ftlvariable name="registrationReport" type="io.fusionauth.app.action.admin.IndexAction.IndexReport" --]
[#-- @ftlvariable name="tenantSetup" type="boolean" --]
[#-- @ftlvariable name="totalsReport" type="io.fusionauth.app.action.admin.IndexAction.IndexReport" --]
[#-- @ftlvariable name="whatIsNewVersions" type="java.util.List<java.lang.String>" --]

[#import "../_utils/button.ftl" as button/]
[#import "../_layouts/admin.ftl" as layout/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/panel.ftl" as panel/]
[#import "../_utils/report.ftl" as report/]

[@layout.html]
[@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.Dashboard([[#list loginData.labels as label]"${label}"[#sep], [/#list]],
          [[#list loginData.counts as count]${count}[#sep], [/#list]]);
    });
  </script>
[/@layout.head]
[@layout.body]
  [@layout.pageHeader/]
  [@layout.main]

    [#-- Is the Proxy Config Screwed up? --]
    <div id="proxy-report-result">
    </div>
    <iframe id="proxy-report-iframe" width="0" height="0" src="${request.contextPath}/admin/proxy-config-test" class="hidden"></iframe>

     [#-- What is new in this release, display if we have a message --]
     [#if whatIsNewVersions?has_content]
       [@panel.whatIsNew versions=whatIsNewVersions]
         [#list whatIsNewVersions as version]
           [#assign whatIsNewMessage = message.inline("[whatIsNew]" + version) /]
             <fieldset class="mt-2 mb-4">
               <legend>${version}</legend>
               ${whatIsNewMessage?no_esc}
            </fieldset>
         [/#list]
       [/@panel.whatIsNew]
     [/#if]

    [#if !applicationSetup || !apiKeySetup || !tenantSetup]
      [#assign setupIndex = 1/]
      [@panel.full titleKey="complete-setup" rowClass="row push-more-bottom" panelClass="panel green" mainClass="row"]
        [#if !applicationSetup]
          [#-- Application setup step --]
          <div class="col-xs-12 col-sm-6 col-md-4 blue-gray card">
            <header>
              <span class="corner">#${setupIndex}</span>
              <h3>[@message.print key="missing-application"/]</h3>
            </header>
            <main>
              <i class="fa fa-cube background hover"></i>
              <div>
                <p>
                  [@message.print key="missing-application-info"/]
                </p>
              </div>
            </main>
            <footer class="text-right">
              [@button.iconLinkWithText href="/admin/application/add" textKey="setup"/]
            </footer>
          </div>
          [#assign setupIndex += 1/]
        [/#if]

        [#if !apiKeySetup]
          [#-- API Key setup step --]
          <div class="col-xs-12 col-sm-6 col-md-4 blue-gray card">
            <header>
              <span class="corner">#${setupIndex}</span>
              <h3>[@message.print key="missing-api-key"/]</h3>
            </header>
            <main>
              <i class="fa fa-key background hover"></i>
              <div>
                <p>
                  [@message.print key="missing-api-key-info"/]
                </p>
              </div>
            </main>
            <footer class="text-right">
              [@button.iconLinkWithText href="/admin/api/add" textKey="add"/]
            </footer>
          </div>
          [#assign setupIndex += 1/]
        [/#if]

        [#if !tenantSetup]
          [#-- Email setup step --]
          <div class="col-xs-12 col-sm-6 col-md-4 blue-gray card">
            <header>
              <span class="corner">#${setupIndex}</span>
              <h3>[@message.print key="email-settings"/]</h3>
            </header>
            <main>
              <i class="fa fa-envelope-o background hover"></i>
              <div>
                <p>
                  [@message.print key="email-settings-info"/]
                </p>
              </div>
            </main>
            <footer class="text-right">
              [@button.iconLinkWithText href="/admin/tenant/edit?tenantId=${fusionAuthTenantId}#email-configuration" textKey="setup"/]
            </footer>
          </div>
        [/#if]
      [/@panel.full]
    [/#if]

    [@panel.full titleKey="overview" mainClass="row"]
      <div class="col-lg-3 col-md-6 col-xs-12 blue card">
        [@reportCard "users", totalsReport, "total-users", false/]
      </div>
      <div class="col-lg-3 col-md-6 col-xs-12 green card">
        [@reportCard "sign-in", loginReport, "logins-today", true/]
      </div>
      <div class="col-lg-3 col-md-6 col-xs-12 red card">
        [@reportCard "user-plus", registrationReport, "registrations-today", true/]
      </div>
      <div class="col-lg-3 col-md-6 col-xs-12 orange card">
        [@reportCard "line-chart", dailyActiveUserReport, "daily-active-users", true/]
      </div>
    [/@panel.full]

    <div class="row push-bottom">
      <div class="col-xs-12 col-md-6 panel">
        <header>
          <h2>[@message.print key="recent-logins"/]</h2>
        </header>
        <main>
          <table class="hover">
            <thead>
            <tr>
              <th>[@message.print key="user"/]</th>
              <th class="hide-on-mobile">[@message.print key="application"/]</th>
              <th>[@message.print key="time"/]</th>
            </tr>
            </thead>
            <tbody>
              [#list logins as login]
              <tr>
                <td>${login.loginId}</td>
                <td class="hide-on-mobile">${login.applicationName}</td>
                <td>${function.format_zoned_date_time(login.instant, function.message('date-time-format'), zoneId)}</td>
              </tr>
              [/#list]
            </tbody>
          </table>
        </main>
      </div>
      <div class="col-xs-12 col-md-6 panel" id="hourly-logins">
        <header>
          <h2>
            [@message.print key="logins-by-hour"/]
            [@report.typeToggle /]
          </h2>
        </header>
        <main>
          <canvas id="login-chart" height="400" width="400"></canvas>
        </main>
      </div>
    </div>
  [/@layout.main]

[/@layout.body]
[/@layout.html]

[#macro reportCard icon object titleKey includeChange]
  <header>
    <h3>[@message.print key=titleKey/]</h3>
    [#if includeChange]
      [#if object.change?has_content]
        <span class="${object.increase?then('increase', 'decrease')}">${object.change}%</span>
      [#else]
        <span>[@message.print key="not-available"/]</span>
      [/#if]
    [/#if]
  </header>
  <main>
    <i class="fa fa-${icon} background hover"></i>
    <p class="large text-center">${object.count}</p>
  </main>
[/#macro]