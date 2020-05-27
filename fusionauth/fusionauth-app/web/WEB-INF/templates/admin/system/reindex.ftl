[#ftl/]
[#-- @ftlvariable name="running" type="boolean" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]

[@layout.html]
  [@layout.head]
  [#if running]
  <script>
    Prime.Document.onReady(function() {
      setTimeout(function() {
        location.reload();
      }, 5000);
    });
  </script>
  [/#if]
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="reindex" method="POST" class="full" id="reindex" includeSave=!running includeCancel=true cancelURI="/admin" saveColor="red" saveKey="confirm" breadcrumbs={"": "system", "/admin/system/reindex": "reindex"}]
      <div class="row push-bottom">
        <div class="col-xs">
          <p>[@message.print key="description.part1"/]</p>
          <p>[@message.print key="description.part2"/]</p>
          <p>[@message.print key="description.part3"/]</p>
        </div>
      </div>

      <div class="row">
        <div class="col-xs">
          <p>[@message.print key="confirmMessage"/]</p>
          [@control.text autofocus="autofocus" name="confirm" autocapitalize="none" autocomplete="off" autocorrect="off" required=true/]
        </div>
      </div>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]