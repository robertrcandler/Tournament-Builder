[#ftl/]
[#-- @ftlvariable name="firstResult" type="int" --]
[#-- @ftlvariable name="lastResult" type="int" --]
[#-- @ftlvariable name="totalCount" type="int" --]
[#-- @ftlvariable name="numberOfPages" type="int" --]
[#-- @ftlvariable name="results" type="java.util.List<io.fusionauth.domain.EventLog>" --]
[#-- @ftlvariable name="s" type="io.fusionauth.domain.search.EventLogSearchCriteria" --]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]
[#import "../../../_utils/panel.ftl" as panel/]
[#import "../../../_utils/search.ftl" as search/]

[#macro header property]
[#if (s.orderBy!"")?contains(property)]
[#local direction = (s.orderBy!"")?contains(" desc")?then('sort-down', 'sort-up') /]
[/#if]
<th class="sortable ${direction!''}">[#rt/]
  <a href="?s.orderBy=${property}[#if (s.orderBy!"")?contains(property + " desc")]+asc[#else]+desc[/#if]">[@message.print key=property/]</a>[#t/]
</th>[#rt/]
[/#macro]

[#macro typeIcon type]
[#if type == "Information"]
  <i class="fa fa-info-circle md-text blue-text"></i>
[#elseif type == "Debug"]
  <i class="fa fa-bug md-text orange-text"></i>
[#elseif type == "Error"]
  <i class="fa fa-exclamation-triangle md-text red-text"></i>
[#else]
  <i class="fa fa-exclamation-triangle md-text"></i>
[/#if]
[/#macro]

[@layout.html]
  [@layout.head]
    <script src="${request.contextPath}/js/admin/EventLogSearch.js?version=${version}"></script>
    <script>
    Prime.Document.onReady(function() {
      var form = Prime.Document.queryById('event-log-form');
      new FusionAuth.Admin.EventLogSearch(form);

      var auditLog = Prime.Document.queryById('event-log-content');
      new FusionAuth.UI.Listing(auditLog.queryFirst('table.listing'))
          .initialize();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" breadcrumbs={"": "system", "/admin/system/event-log/": "event-log"}/]
    [@layout.main]
      [@panel.full]
        [@control.form id="event-log-form" action="/admin/system/event-log/" method="GET" class="labels-above full push-bottom"]
          [@control.hidden name="s.numberOfResults"/]

            <div class="row">
              <div class="col-xs-12 col-md-12 tight-left">
                <div class="form-row">
                  [@control.text name="s.message" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" autofocus="autofocus"  placeholder="${function.message('search-placeholder')}"/]
                </div>
              </div>
            </div>

            [#-- Advanced Search Controls --]
            <div id="advanced-search-controls" class="slide-open">
              <div class="row">
                <div class="col-xs-12 col-md-4 tight-left">
                  [@control.select name="s.type" items=eventLogTypes headerValue="" headerL10n="any"/]
                </div>
                <div class="col-xs-12 col-md-4">
                  [@control.text name="s.start" class="date-time-picker" _dateTimeFormat="yyyy-MM-dd'T'HH:mm:ss.SSSX"/]
                </div>
                <div class="col-xs-12 col-md-4">
                  [@control.text name="s.end" class="date-time-picker" _dateTimeFormat="yyyy-MM-dd'T'HH:mm:ss.SSSX"/]
                </div>
              </div>
            </div>

            <a href="#" class="slide-open-toggle" data-expand-open="advanced-search-controls">
              <span>[@message.print key="advanced"/] <i class="fa fa-angle-down"></i></span>
            </a>

            <div class="row push-lesser-top push-bottom">
              <div class="col-xs tight-left">
                [@button.formIcon color="blue" icon="search" textKey="search"/]
                [@button.iconLinkWithText href="/admin/system/event-log/?clear=true" color="blue" icon="undo" textKey="reset" class="reset-button" name='reset'/]
              </div>
            </div>

        [/@control.form]

        <div id="event-log-content">
          [@search.pagination/]
          <div class="scrollable horizontal">
            <table class="listing hover" data-sortable="false">
              <thead>
              <tr>
                [@header "message"/]
                [@header "insertInstant"/]
                <th data-sortable="false" class="action">[@message.print key="action"/]</th>
              </tr>
              </thead>
              <tbody>
                [#if results?has_content]
                  [#list results as log]
                  <tr>
                    <td class="overflow-ellipsis pr-4">
                      <span data-tooltip="${log.type}" class="mr-1">
                        [@typeIcon log.type/]
                      </span>
                      ${log.message}
                    </td>
                    <td class="overflow-ellipsis-on-mobile tight pr-4">${function.format_zoned_date_time(log.insertInstant, function.message('date-time-seconds-format'), zoneId)}[#t/]</td>
                    <td class="action">
                      [@button.action icon="search" color="green" href="${request.contextPath}/ajax/system/event-log/view/${log.id}" key="view-event-log" ajaxView=true ajaxWideDialog=true/]
                    </td>
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