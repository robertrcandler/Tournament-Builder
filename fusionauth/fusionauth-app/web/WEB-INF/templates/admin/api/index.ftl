[#ftl/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as apiMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      Prime.Document.query('table').each(function(item) {
        new FusionAuth.UI.Listing(item)
            .initialize();
      });
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true breadcrumbs={"": "settings", "/admin/api/": "api-authentication-keys"}/]
    [@layout.main]
      [@panel.full]
        [@apiMacros.apiKeysTable/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]