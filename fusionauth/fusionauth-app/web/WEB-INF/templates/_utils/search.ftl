[#ftl/]
[#-- @ftlvariable name="currentPage" type="int" --]
[#-- @ftlvariable name="firstResult" type="int" --]
[#-- @ftlvariable name="lastResult" type="int" --]
[#-- @ftlvariable name="numberOfPages" type="int" --]
[#-- @ftlvariable name="s" type="io.fusionauth.domain.search.BaseSearchCriteria" --]
[#-- @ftlvariable name="total" type="int" --]
[#import "../_utils/message.ftl" as message/]

[#--
  Common Pagination Controls

  All text and rows per page may be overriden by user.
    @see WEB-INF/messages/package.properties
--]
[#macro pagination]
<div class="row pagination middle-xs">
  <div class="number-controls col-lg-4 col-xs-12">
    [@message.print key="results-per-page"/]&nbsp;
    <label class="select">
      <select data-name="s.numberOfResults">
        [#list [25, 50, 100, 250, 500] as value]
          [#if s.numberOfResults == value]
            <option selected value="${value}">${value}</option>
          [#else]
            <option value="${value}">${value}</option>
          [/#if]
        [/#list]
      </select>
    </label>
  </div>

  <div class="info col-lg-4 col-xs-12">
    [#--
       Not sure why, but the default grouping separator should be a comma - but it is showing up as a space unless I explictly extend the decimal formatter and specify the groupingSeparator.
       See the same usage in totals.ftl and it works fine without having to specify the groupingSeparator. WTF?
     --]
    [#if total gt 0]
      [@message.print key="displaying-results" values=[firstResult?string[",##0;; groupingSeparator=','"], lastResult?string[",##0;; groupingSeparator=','"], total?string[",##0;; groupingSeparator=','"]]/]
    [#elseif total == -1]
      [@message.print key="displaying-results-unknown" values=[firstResult?string[",##0;; groupingSeparator=','"], lastResult?string[",##0;; groupingSeparator=','"]]/]
    [/#if]
  </div>

  <div class="page-controls col-lg-4 col-xs-12">
    [#if numberOfPages gt 1]
      [#if currentPage gt 2]
        <a href="?s.startRow=0" data-tooltip="${function.message('first')}" title="${function.message('first')}"><i class="fa fa-angle-double-left"></i></a>
      [/#if]
      [#if currentPage gt 1]
        <a href="?s.startRow=${((currentPage - 2) * s.numberOfResults)?c}" data-tooltip="${function.message('previous')}" title="${function.message('previous')}"><i class="fa fa-angle-left"></i></a>
      [/#if]
      [#list currentPage-3..currentPage+3 as page]
        [#if numberOfPages gt 1 && page gt 0 && page lte numberOfPages]
          [#if page == currentPage]
            <a class="current" href="#">${page}</a>
          [#else]
            <a href="?s.startRow=${((page - 1) * s.numberOfResults)?c}">${page}</a>
          [/#if]
        [/#if]
      [/#list]
      [#if currentPage lt numberOfPages]
        <a href="?s.startRow=${(currentPage * s.numberOfResults)?c}" data-tooltip="${function.message('next')}" title="${function.message('next')}"><i class="fa fa-angle-right"></i></a>
      [/#if]
      [#if currentPage lt (numberOfPages - 1)]
        <a href="?s.startRow=${((numberOfPages - 1) * s.numberOfResults)?c}" data-tooltip="${function.message('last')}" title="${function.message('last')}"><i class="fa fa-angle-double-right"></i></a>
      [/#if]
    [#elseif total == -1]
      <a href="?s.startRow=0" data-tooltip="${function.message('first')}" title="${function.message('first')}" class=${(s.startRow > 0)?then("", "disabled")}><i class="fa fa-angle-double-left"></i></a>
      <a href="?s.startRow=${((currentPage - 2) * s.numberOfResults)?c}" data-tooltip="${function.message('previous')}" title="${function.message('previous')}" class=${(s.startRow > 0)?then("", "disabled")} ><i class="fa fa-angle-left"></i></a>
      <a href="#" class="disabled">&hellip;</a>
      <a href="?s.startRow=${(currentPage * s.numberOfResults)?c}" data-tooltip="${function.message('next')}" title="${function.message('next')}" class=${(firstResult > 0)?then("", "disabled")}><i class="fa fa-angle-right"></i></a>
    [/#if]
  </div>
</div>
[/#macro]