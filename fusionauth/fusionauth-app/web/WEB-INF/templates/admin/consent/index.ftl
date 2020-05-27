[#ftl/]
[#-- @ftlvariable name="consents" type="java.util.List<io.fusionauth.domain.Consent>" --]

[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "_macros.ftl" as consentMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.UI.Listing(Prime.Document.queryFirst('table'))
          .initialize();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader includeAdd=true titleKey="page-title" breadcrumbs={"": "settings", "/admin/consent/": "page-title"}/]
    [@layout.main]
      [@panel.full]
        [@consentMacros.consentsTable/]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]