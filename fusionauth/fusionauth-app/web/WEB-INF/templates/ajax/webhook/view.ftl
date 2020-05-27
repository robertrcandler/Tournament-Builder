[#ftl/]
[#-- @ftlvariable name="applications" type="java.util.List<io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="webhook" type="io.fusionauth.domain.Webhook" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="url" object=webhook propertyName="url"/]
    [@properties.rowEval nameKey="description" object=webhook propertyName="description"/]
    [@properties.rowEval nameKey="global" object=webhook propertyName="global" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="connect-timeout" object=webhook propertyName="connectTimeout"/]
    [@properties.rowEval nameKey="read-timeout" object=webhook propertyName="readTimeout"/]
    [@properties.rowEval nameKey="http-authentication-username" object=webhook propertyName="httpAuthenticationUsername"/]
    [@properties.rowEval nameKey="http-authentication-password" object=webhook propertyName="httpAuthenticationPassword"/]
    [@properties.rowEval nameKey="ssl-certificate" object=webhook propertyName="sslCertificate"/]
  [/@properties.table]

  [#-- Application --]
  <h3>[@message.print key="applications"/]</h3>
  <ul>
    [#list applications![] as application]
      <li>${properties.display(application, "name")}</li>
    [#else]
      <li>[@message.print key="all-applications"/]</li>
    [/#list]
  </ul>

  [#-- HTTP Headers --]
  <h3>[@message.print key="http-headers"/]</h3>
  [@properties.table]
    [#list (webhook.headers?keys)![] as name]
      [@properties.rowRaw name=name value=properties.displayMapValue(webhook.headers, name)/]
    [#else]
      <tr>
        <td colspan="2" style="font-weight: inherit;">[@message.print key="no-headers"/]</td>
      </tr>
    [/#list]
  [/@properties.table]

  [#-- Events --]
  <h3>[@message.print key="events-enabled"/]</h3>
  <table>
    <thead>
      <tr>
        <th>[@message.print key="events"/]</th>
        <th>[@message.print key="enabled"/]</th>
      </tr>
    </thead>
    <tbody>
      [#list webhook.eventsEnabled as eventType, enabled]
        <tr>
          <td>${eventType.eventName()}</td>
          <td>[@properties.displayCheck enabled/]</td>
        </tr>
      [/#list]
    </tbody>
  </table>
[/@dialog.view]
