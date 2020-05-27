[#ftl/]
[#-- @ftlvariable name="authenticationKey" type="com.inversoft.authentication.api.domain.AuthenticationKey" --]
[#import "_macros.ftl" as apiMacros/]
[#import "../../_layouts/admin.ftl" as layout/]
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
    [@layout.pageForm action="add" method="POST" id="api-key-form" includeSave=true includeCancel=true cancelURI="/admin/api/"  breadcrumbs={"": "settings", "/admin/api/": "api-authentication-keys", "/admin/api/add": "add"}]
      <fieldset>
        [@control.text name="authenticationKey.id" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}authenticationKey.id')/]
        [@control.text name="authenticationKey.metaData.attributes['description']" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus" tooltip=function.message('{tooltip}authenticationKey.metaData.attributes[\'description\']')/]
        [#if tenants?size > 1]
          [@control.select name="tenantId" labelKey="tenant" items=tenants textExpr="name" valueExpr="id" required=false headerL10n="all-tenants" headerValue="" tooltip=function.message('{tooltip}tenant')/]
        [/#if]
      </fieldset>
      <fieldset>
        [@apiMacros.endpointTable/]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]
