[#ftl/]
[#-- @ftlvariable name="firstResult" type="int" --]
[#-- @ftlvariable name="lastResult" type="int" --]
[#-- @ftlvariable name="totalCount" type="int" --]
[#-- @ftlvariable name="numberOfPages" type="int" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.AuditLog>" --]
[#-- @ftlvariable name="s" type="io.fusionauth.domain.search.AuditLogSearchCriteria" --]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/panel.ftl" as panel/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "../../../_utils/search.ftl" as search/]


[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      var form = Prime.Document.queryById('login-record-form');
      new FusionAuth.Admin.LoginRecordSearch(form);
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" breadcrumbs={"": "system", "/admin/system/login-record/": "login-records"}]
        [@button.iconLink href="/admin/system/login-record/download" color="purple" icon="download" tooltipKey="download"/]
    [/@layout.pageHeader]
    [@layout.main]
      [@panel.full]
        [@control.form id="login-record-form" action="/admin/system/login-record/" method="GET" class="labels-above full push-bottom"]
          [@control.hidden name="s.numberOfResults"/]

          <div class="row">
            <div class="col-xs-12 col-md-12 tight-left">
              <div class="form-row">
                [@control.text name="q" autocapitalize="none" autocomplete="off" autocorrect="off" spellcheck="false" placeholder=message.inline("{placeholder}q")/]
                [@control.hidden name="s.userId" /]
              </div>
            </div>
          </div>

         [#-- Advanced Search Controls --]
          <div id="advanced-search-controls" class="slide-open">
            <div class="row">
              <div class="col-xs-12 col-md-4 tight-left">
                  [@control.select items=applications name="s.applicationId" textExpr="name" valueExpr="id" headerL10n="any" headerValue=""/]
              </div>
              <div class="col-xs-12 col-md-4 tight-left">
                  [@control.text name="s.start" class="date-time-picker" _dateTimeFormat="yyyy-MM-dd'T'HH:mm:ss.SSSX"/]
              </div>
              <div class="col-xs-12 col-md-4 tight-left">
                  [@control.text name="s.end" class="date-time-picker" _dateTimeFormat="yyyy-MM-dd'T'HH:mm:ss.SSSX"/]
              </div>
            </div>
          </div>

          <a href="#" class="slide-open-toggle" data-expand-open="advanced-search-controls">
            <span>[@message.print key="advanced"/] <i class="fa fa-angle-down"></i></span>
          </a>

          <div class="row push-lesser-top push-bottom">
            <div class="col-xs tight-left">
              [@button.formIcon icon="search" color="blue" textKey="search"/]
              [@button.iconLinkWithText textKey="reset" icon="undo" href="/admin/system/login-record/?clear=true"/]
            </div>
          </div>

        [/@control.form]

        <div id="login-record-content">
          [@search.pagination/]
          <div class="scrollable horizontal">
            <table class="listing hover no-actions" data-sortable="false">
              <thead>
              <tr>
                <th>[@message.print key="loginId"/]</th>
                <th>[@message.print key="userId"/]</th>
                <th>[@message.print key="time"/]</th>
                <th>[@message.print key="application"/]</th>
                <th>[@message.print key="applicationId"/]</th>
                <th>[@message.print key="ip-address"/]</th>
              </tr>
              </thead>
              <tbody>
                [#if results?has_content]
                  [#list results as record]
                  <tr>
                    <td>${properties.display(record, 'loginId')}</td>
                    <td>${properties.display(record, 'userId')}</td>
                    <td>${properties.display(record, 'instant')}</td>
                    <td>${properties.display(record, 'applicationName')}</td>
                    <td>${properties.display(record, 'applicationId')}</td>
                    <td>${properties.display(record, 'ipAddress')}</td>
                  </tr>
                  [/#list]
                [#else]
                <tr>
                  <td colspan="4">
                    [@message.print key="no-results"/]
                  </td>
                </tr>
                [/#if]
              </tbody>
            </table>
          </div>
          [#if numberOfPages gt 1]
            [@search.pagination/]
          [/#if]
        </div>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]