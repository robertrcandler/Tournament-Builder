[#ftl/]
[#-- @ftlvariable name="themeId" type="java.util.UUID" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as themeMacros/]

[@layout.html]
  [@layout.head]
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.ThemeForm();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="edit/${themeId}" method="POST" id="theme-form" panelTitleKey="" cancelURI="/admin/theme/" breadcrumbs={"": "settings", "/admin/theme/": "themes", "/admin/theme/edit/${themeId}": "edit"}]
      [@themeMacros.formFields action="edit"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
