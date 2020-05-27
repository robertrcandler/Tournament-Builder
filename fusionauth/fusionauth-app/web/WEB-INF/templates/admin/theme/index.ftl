[#ftl/]
[#-- @ftlvariable name="themes" type="java.util.List<io.fusionauth.domain.Theme>" --]

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
        [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=true breadcrumbs={"": "settings", "/admin/theme/": "themes"}/]
        [@layout.main]
            [@panel.full]
              <table class="hover">
                <thead>
                <tr>
                  <th class="hide-on-mobile"><a href="#">[@message.print key="id"/]</a></th>
                  <th><a href="#">[@message.print key="name"/]</a></th>
                  <th data-sortable="false" class="action">[@message.print key="action"/]</th>
                </tr>
                </thead>
                <tbody>
                [#list themes![] as theme]
                  <tr>
                    <td class="hide-on-mobile">${theme.id}
                    [#if theme.missingTemplate()]
                      <span class="small orange stamp push-left" data-tooltip="${message.inline('{tooltip}requires-upgrade')}"><i class="fa fa-exclamation-triangle"></i> [@message.print key="requires-upgrade"/]</span>
                    [/#if]
                    </td>
                    <td>${properties.display(theme, "name")}</td>
                    <td class="action">
                      [@button.action href="edit/${theme.id}" icon="edit" key="edit" color="blue"/]
                      [@button.action href="add?themeId=${theme.id}" icon="copy" key="duplicate" color="purple"/]
                      [@button.action href="/admin/theme/view/${theme.id}" icon="search" key="preview" color="green" target="_blank"/]
                      [#if theme.id != fusionAuth.statics['io.fusionauth.domain.Theme'].FUSIONAUTH_THEME_ID]
                        [@button.action href="/ajax/theme/delete/${theme.id}" icon="trash" key="delete" ajaxForm=true color="red"/]
                      [/#if]
                    </td>
                  </tr>
                [/#list]
                </tbody>
              </table>
            [/@panel.full]
        [/@layout.main]
    [/@layout.body]
[/@layout.html]