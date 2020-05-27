[#ftl/]
[#-- @ftlvariable name="webhooks" type="java.util.List<io.fusionauth.domain.Webhook>" --]
[#-- @ftlvariable name="fusionAuthId" type="java.util.UUID" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]

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
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true breadcrumbs={"": "settings", "/admin/webhook/": "webhooks"}/]
    [@layout.main]
      [@panel.full]
        <table class="hover">
          <thead>
          <tr>
            <th><a href="#">[@message.print key="url"/]</a></th>
            <th class="hide-on-mobile"><a href="#">[@message.print key="description"/]</a></th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
            [#list webhooks![] as webhook]
              <tr>
                <td>${webhook.url}</td>
                <td class="hide-on-mobile">[@properties.truncate webhook, "description", 80/]</td>
                <td class="action">
                  [@button.action href="edit/${webhook.id}" icon="edit" key="edit" color="blue"/]
                  [@button.action href="test/${webhook.id}" icon="exchange" key="test" color="purple"/]
                  [@button.action href="/ajax/webhook/view/${webhook.id}" icon="search" key="view" ajaxView=true ajaxWideDialog=true color="green"/]
                  [@button.action href="/ajax/webhook/delete/${webhook.id}" icon="trash" key="delete" ajaxForm=true color="red"/]
                </td>
              </tr>
            [#else]
              <tr>
                <td colspan="3">[@message.print key="no-webhooks"/]</td>
              </tr>
            [/#list]
          </tbody>
        </table>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
