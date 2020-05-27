[#ftl/]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "_macros.ftl" as identityProviderMacros/]

[@layout.html]
  [@layout.head]
    <script src="${request.contextPath}/js/admin/identityProvider/Index.js?version=${version}"></script>
    <script>
      Prime.Document.onReady(function() {
        new FusionAuth.Admin.IdentityProvider.Index();
      });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true addURI="/ajax/identity-provider/types" breadcrumbs={"": "settings", "/admin/identity-provider/": "identity-providers"}/]
    [@layout.main]
      [@panel.full]
        [@identityProviderMacros.identityProvidersGrid/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]