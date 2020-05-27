[#ftl/]
[#-- @ftlvariable name="authenticationKey" type="com.inversoft.authentication.api.domain.AuthenticationKey" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="id" object=authenticationKey propertyName="id"/]
    [@properties.row nameKey="description" value=properties.displayMapValue((authenticationKey.metaData.attributes)!'', "description")/]
    [#if authenticationKey.tenantId??]
      [@properties.row nameKey="tenant" value=helpers.tenantName(authenticationKey.tenantId)/]
    [#else]
      [@properties.row nameKey="tenant" value=message.inline("all-tenants")/]
    [/#if]
  [/@properties.table]

  <h3>[@message.print key="endpoints"/]</h3>
  [#if (authenticationKey.permissions.endpoints)?has_content]
    <table class="fields">
      <thead>
        <tr>
          <th>[@message.print key="endpoint"/]</th>
          <th class="text-center">[@message.print key="GET"/]</th>
          <th class="text-center">[@message.print key="POST"/]</th>
          <th class="text-center">[@message.print key="PUT"/]</th>
          <th class="text-center">[@message.print key="PATCH"/]</th>
          <th class="text-center">[@message.print key="DELETE"/]</th>
        </tr>
      </thead>
      <tbody>
      [#list authenticationKey.permissions.endpoints?keys as endpoint]
        <tr>
          <td>${endpoint}</td>
          <td class="text-center">[@properties.displayCheck authenticationKey.permissions.endpoints[endpoint].contains('GET')/]</td>
          <td class="text-center">[@properties.displayCheck authenticationKey.permissions.endpoints[endpoint].contains('POST')/]</td>
          <td class="text-center">[@properties.displayCheck authenticationKey.permissions.endpoints[endpoint].contains('PUT')/]</td>
          <td class="text-center">[@properties.displayCheck authenticationKey.permissions.endpoints[endpoint].contains('PATCH')/]</td>
          <td class="text-center">[@properties.displayCheck authenticationKey.permissions.endpoints[endpoint].contains('DELETE')/]</td>
        </tr>
      [/#list]
      </tbody>
    </table>
  [#else]
    <p>[@message.print "superuser"/]</p>
  [/#if]
[/@dialog.view]