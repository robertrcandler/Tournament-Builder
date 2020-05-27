[#ftl/]
[#-- @ftlvariable name="emailTemplates" type="java.util.List<io.fusionauth.domain.email.EmailTemplate>" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.EmailTemplateListing();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader includeAdd=true breadcrumbs={"": "settings", "/admin/email/template/": "email-templates"}/]
    [@layout.main]
      [@panel.full]
        <table class="hover">
          <thead>
          <tr>
            <th><a href="#">[@message.print key="name"/]</a></th>
            <th class="hide-on-mobile"><a href="#">[@message.print key="id"/]</a></th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
            [#list emailTemplates![] as emailTemplate]
              <tr>
                <td>${emailTemplate.name}</td>
                <td class="hide-on-mobile">${emailTemplate.id}</td>
                <td class="action">
                  [@button.action href="edit/${emailTemplate.id}" icon="edit" key="edit" color="blue"/]
                  [@button.action href="add?emailTemplateId=${emailTemplate.id}" icon="copy" key="duplicate" color="purple"/]
                  [@button.action href="/ajax/email/template/view/${emailTemplate.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true/]
                  [@button.action href="/ajax/email/template/delete/${emailTemplate.id}" icon="trash" key="delete" color="red" ajaxForm=true/]
                </td>
              </tr>
            [#else]
              <tr>
                <td colspan="3">[@message.print key="no-email-templates"/]</td>
              </tr>
            [/#list]
          </tbody>
        </table>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]