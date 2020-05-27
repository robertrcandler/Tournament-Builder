[#ftl/]

[#import "../../_layouts/admin.ftl" as layout/]
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
    [@layout.pageForm action="add" method="POST" id="theme-form" cancelURI="/admin/theme/" breadcrumbs={"": "settings", "/admin/theme/": "themes", "/admin/theme/add": "add"}]
      [@themeMacros.formFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]