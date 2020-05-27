[#ftl/]
[#-- @ftlvariable name="lambdas" type="java.util.List<io.fusionauth.domain.Lambda>" --]

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
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true breadcrumbs={"": "settings", "/admin/lambda/": "lambdas"}/]
    [@layout.main]
      [@panel.full]
        <table class="hover">
          <thead>
          <tr>
            <th class="hide-on-mobile"><a href="#">[@message.print key="id"/]</a></th>
            <th><a href="#">[@message.print key="name"/]</a></th>
            <th><a href="#">[@message.print key="type"/]</a></th>
            <th class="hide-on-mobile"><a href="#">[@message.print key="debug"/]</a></th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
            [#list lambdas![] as lambda]
              <tr>
                <td class="hide-on-mobile">${lambda.id}</td>
                <td>${properties.display(lambda, "name")}</td>
                <td>[@message.print key=lambda.type.name()/]</td>
                <td class="hide-on-mobile">${properties.display(lambda, "debug")}</td>
                <td class="action">
                  [@button.action href="edit/${lambda.id}" icon="edit" key="edit" color="blue"/]
                  [@button.action href="/ajax/lambda/view/${lambda.id}" icon="search" key="view" ajaxView=true ajaxWideDialog=true color="green" resizeDialog=true/]
                  [@button.action href="/ajax/lambda/delete/${lambda.id}" icon="trash" key="delete" ajaxForm=true color="red"/]
                </td>
              </tr>
            [#else]
              <tr>
                <td colspan="3">[@message.print key="no-lambdas"/]</td>
              </tr>
            [/#list]
          </tbody>
        </table>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
