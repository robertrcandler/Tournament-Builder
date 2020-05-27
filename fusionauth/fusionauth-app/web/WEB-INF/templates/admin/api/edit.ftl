[#ftl/]
[#-- @ftlvariable name="authenticationKeyId" type="java.lang.String" --]
[#-- @ftlvariable name="authenticationKey" type="com.inversoft.authentication.api.domain.AuthenticationKey" --]
[#import "_macros.ftl" as apiMacros/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.EndpointTable(Prime.Document.queryById('endpoints'));
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="edit" method="POST" id="api-key-form" includeSave=true includeCancel=true cancelURI="/admin/api/"  breadcrumbs={"": "settings", "/admin/api/": "api-authentication-keys", "/admin/api/edit?authenticationKeyId=${authenticationKeyId}": "edit"}]
      <fieldset>
        [@control.hidden name="authenticationKeyId"/]
        [@control.text name="authenticationKey.id" disabled=true tooltip=message.inline('{tooltip}readOnly')/]
        [@control.text name="authenticationKey.metaData.attributes['description']" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus"/]
        [#if tenants?size > 1]
          [#if authenticationKey.tenantId?has_content]
            [@control.text name="authenticationKey.tenantId" value=helpers.tenantName(authenticationKey.tenantId) disabled=true tooltip=message.inline('{tooltip}readOnly')/]
          [#else]
            [@control.text name="authenticationKey.tenantId" value=message.inline("all-tenants") disabled=true tooltip=message.inline('{tooltip}readOnly')/]
          [/#if]
        [/#if]
      </fieldset>
      <fieldset class="scrollable horizontal">
        [@apiMacros.endpointTable/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]


