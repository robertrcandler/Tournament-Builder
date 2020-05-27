[#ftl/]
[#-- @ftlvariable name="authenticationKey" type="com.inversoft.authentication.api.domain.AuthenticationKey" --]
[#-- @ftlvariable name="authenticationKeys" type="java.util.List<com.inversoft.authentication.api.domain.AuthenticationKey>" --]
[#-- @ftlvariable name="endpoints" type="java.util.List<java.lang.String>" --]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/helpers.ftl" as helpers/]

[#macro apiKeysTable]
<table class="hover">
  <thead>
  <tr>
    <th><a href="#">[@message.print key="id"/]</a></th>
    <th class="hide-on-mobile"><a href="#">[@message.print key="description"/]</a></th>
    [#if tenants?size > 1]
      <th class="hide-on-mobile"><a href="#">[@message.print key="tenant"/]</a></th>
    [/#if]
    <th data-sortable="false" class="action">[@message.print key="action"/]</th>
  </tr>
  </thead>
  <tbody>
    [#if authenticationKeys?? && authenticationKeys?size > 0]
      [#list authenticationKeys as authenticationKey]
      <tr>
        <td style="word-break: break-all;">${authenticationKey.id}</td>
        <td class="hide-on-mobile">[@helpers.truncate (authenticationKey.metaData.attributes['description'])!'', 80/]</td>
        [#if tenants?size > 1]
          <td class="hide-on-mobile">${authenticationKey.tenantId?has_content?then(helpers.tenantName(authenticationKey.tenantId), message.inline("all-tenants"))}</td>
        [/#if]
        <td class="action">
          [#assign encodedId = authenticationKey.id?url('UTF-8')/]
          [@button.action href="edit?authenticationKeyId=${encodedId}" icon="edit" key="edit" color="blue"/]
          [@button.action href="/ajax/api/view?id=${encodedId}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true/]
          [@button.action href="/ajax/api/delete?id=${encodedId}" icon="trash" key="delete" color="red" ajaxForm=true/]
        </td>
      </tr>
      [/#list]
    [#else]
    <tr>
      <td colspan="3">[@message.print key="no-api-authentication-keys"/]</td>
    </tr>
    [/#if]
  </tbody>
</table>
[/#macro]

[#macro endpointTable]
<legend>[@message.print key="endpoints"/]</legend>
[@message.alertColumn message=function.message('warning') type="warning" icon="exclamation-triangle" includeDismissButton=false/]
<p class="no-top-margin"><em>[@message.print key="instructions"/]</em></p>
<table id="endpoints">
  <thead>
  <tr>
    <th>[@message.print key="endpoint"/]</th>
    <th class="tight" data-select-col="GET"><a href="#">[@message.print key="GET"/]</a></th>
    <th class="tight" data-select-col="POST"><a href="#">[@message.print key="POST"/]</a></th>
    <th class="tight" data-select-col="PUT"><a href="#">[@message.print key="PUT"/]</a></th>
    <th class="tight" data-select-col="PATCH"><a href="#">[@message.print key="PATCH"/]</a></th>
    <th class="tight" data-select-col="DELETE"><a href="#">[@message.print key="DELETE"/]</a></th>
  </tr>
  </thead>
  <tbody>
    [#list endpoints as endpoint]
    <tr>
      <td data-select-row="true">${endpoint}</td>
      <td class="tight">[@control.checkbox name="authenticationKey.permissions.endpoints['" + endpoint + "']" value="GET" labelKey="empty" includeFormRow=false/]</td>
      <td class="tight">[@control.checkbox name="authenticationKey.permissions.endpoints['" + endpoint + "']" value="POST" labelKey="empty" includeFormRow=false/]</td>
      <td class="tight">[@control.checkbox name="authenticationKey.permissions.endpoints['" + endpoint + "']" value="PUT" labelKey="empty" includeFormRow=false/]</td>
      <td class="tight">[@control.checkbox name="authenticationKey.permissions.endpoints['" + endpoint + "']" value="PATCH" labelKey="empty" includeFormRow=false/]</td>
      <td class="tight">[@control.checkbox name="authenticationKey.permissions.endpoints['" + endpoint + "']" value="DELETE" labelKey="empty" includeFormRow=false/]</td>
    </tr>
    [/#list]
  </tbody>
</table>
[/#macro]