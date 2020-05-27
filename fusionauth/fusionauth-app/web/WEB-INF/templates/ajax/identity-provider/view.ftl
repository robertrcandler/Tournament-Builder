[#ftl/]
[#-- @ftlvariable name="applications" type="java.util.List<io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="identityProvider" type="io.fusionauth.domain.provider.BaseIdentityProvider" --]
[#-- @ftlvariable name="fusionAuthHost" type="java.lang.String" --]
[#-- @ftlvariable name="key" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="lambda" type="io.fusionauth.domain.Lambda" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  [#-- Top Level Attributes --]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=identityProvider propertyName="name"/]
    [@properties.rowEval nameKey="id" object=identityProvider propertyName="id"/]
    [@properties.rowEval nameKey="enabled" object=identityProvider propertyName="enabled" booleanAsCheckmark=false/]
    [#if identityProvider.getType() == "Facebook"]
      [@properties.rowEval nameKey="appId" object=identityProvider propertyName="appId"/]
      [@properties.rowEval nameKey="appSecret" object=identityProvider propertyName="client_secret"/]
      [@properties.rowEval nameKey="buttonText" object=identityProvider propertyName="buttonText"/]
      [@properties.rowEval nameKey="fields" object=identityProvider propertyName="fields"/]
      [@properties.rowEval nameKey="permissions" object=identityProvider propertyName="permissions"/]
    [/#if]
    [#if identityProvider.getType() == "Google"]
      [@properties.rowEval nameKey="clientId" object=identityProvider propertyName="client_secret"/]
      [@properties.rowEval nameKey="clientSecret" object=identityProvider propertyName="client_secret"/]
      [@properties.rowEval nameKey="buttonText" object=identityProvider propertyName="buttonText"/]
      [@properties.rowEval nameKey="scope" object=identityProvider propertyName="scope"/]
    [/#if]
    [#if identityProvider.getType() == "HYPR"]
      [@properties.rowEval nameKey="relyingPartyApplicationId" object=identityProvider propertyName="relyingPartyApplicationId"/]
      [@properties.rowEval nameKey="relyingPartyURL" object=identityProvider propertyName="relyingPartyURL"/]
    [/#if]
    [#if identityProvider.getType() == "OpenIDConnect"]
      [@properties.rowEval nameKey="clientId" object=identityProvider propertyName="oauth2.client_id"/]
      [@properties.rowEval nameKey="clientSecret" object=identityProvider propertyName="oauth2.client_secret"/]
      [#if identityProvider.oauth2.issuer??]
        [@properties.rowEval nameKey="issuer" object=identityProvider propertyName="oauth2.issuer"/]
      [#else]
        [@properties.rowEval nameKey="authorizeEndpoint" object=identityProvider propertyName="oauth2.authorization_endpoint"/]
        [@properties.rowEval nameKey="tokenEndpoint" object=identityProvider propertyName="oauth2.token_endpoint"/]
        [@properties.rowEval nameKey="userinfoEndpoint" object=identityProvider propertyName="oauth2.userinfo_endpoint"/]
      [/#if]
      [#if identityProvider.lambdaConfiguration.reconcileId??]
        [@properties.rowEval nameKey="reconcileLambda" object=lambda propertyName="name"/]
      [#else]
        [@properties.rowEval nameKey="reconcileLambda" object=identityProvider propertyName="lambdaConfiguration.reconcileId"/]
      [/#if]
      [@properties.rowEval nameKey="buttonText" object=identityProvider propertyName="buttonText"/]
      [@properties.rowEval nameKey="buttonImage" object=identityProvider propertyName="buttonImage"/]
      [@properties.rowEval nameKey="scope" object=identityProvider propertyName="oauth2.scope"/]
      [@properties.rowEval nameKey="managedDomains" object=identityProvider propertyName="domains"/]
    [/#if]
    [#if identityProvider.getType() == "SAMLv2"]
      [@properties.rowEval nameKey="samlv2.idpEndpoint" object=identityProvider propertyName="idpEndpoint"/]
      [@properties.rowEval nameKey="samlv2.useNameIdForEmail" object=identityProvider propertyName="useNameIdForEmail" booleanAsCheckmark=false/]
      [#if !identityProvider.useNameIdForEmail]
        [@properties.rowEval nameKey="samlv2.emailClaim" object=identityProvider propertyName="emailClaim"/]
      [/#if]
      [#if key??]
        [@properties.rowEval nameKey="samlv2.keyId" object=key propertyName="name"/]
      [/#if]
      [@properties.rowEval nameKey="buttonText" object=identityProvider propertyName="buttonText"/]
      [@properties.rowEval nameKey="buttonImage" object=identityProvider propertyName="buttonImage"/]
      [#if identityProvider.lambdaConfiguration.reconcileId??]
        [@properties.rowEval nameKey="reconcileLambda" object=lambda propertyName="name"/]
      [#else]
        [@properties.rowEval nameKey="reconcileLambda" object=identityProvider propertyName="lambdaConfiguration.reconcileId"/]
      [/#if]
      [@properties.rowEval nameKey="managedDomains" object=identityProvider propertyName="domains"/]
    [/#if]
    [#if identityProvider.getType() == "Twitter"]
      [@properties.rowEval nameKey="consumerKey" object=identityProvider propertyName="consumerKey"/]
      [@properties.rowEval nameKey="consumerSecret" object=identityProvider propertyName="consumerSecret"/]
      [@properties.rowEval nameKey="buttonText" object=identityProvider propertyName="buttonText"/]
    [/#if]
    [@properties.rowEval nameKey="debug" object=identityProvider propertyName="debug" booleanAsCheckmark=false /]
  [/@properties.table]

  [#if identityProvider.getType() == "SAMLv2"]
  <h3>[@message.print key="samlv2.integration-details"/]</h3>
  <p><em>[@message.print key="{description}samlv2.integration-details"/]</em></p>
  [@properties.table]
    [@properties.row nameKey="samlv2.callback-url" value=(fusionAuthHost + "/samlv2/acs") /]
    [@properties.row nameKey="samlv2.issuer" value=(fusionAuthHost + "/samlv2/sp/" + identityProvider.id) /]
    [@properties.row nameKey="samlv2.metadata" value=(fusionAuthHost + "/samlv2/sp/metadata/" + identityProvider.id) /]
  [/@properties.table]
  [/#if]

  [#if identityProvider.getType() == "OpenIDConnect"]
  <h3>[@message.print key="oidc.integration-details"/]</h3>
  <p><em>[@message.print key="{description}oidc.integration-details"/]</em></p>
  [@properties.table]
    [@properties.row nameKey="oidc.redirect-url" value=(fusionAuthHost + "/oauth2/callback") /]
  [/@properties.table]
  [/#if]

  [#if identityProvider.getType() == "Twitter"]
  <h3>[@message.print key="twitter.integration-details"/]</h3>
  <p><em>[@message.print key="{description}twitter.integration-details"/]</em></p>
  [@properties.table]
    [@properties.row nameKey="twitter.callback-url" value=(fusionAuthHost + "/oauth2/callback") /]
  [/@properties.table]
  [/#if]

  [#-- Application configuration --]
  <h3>[@message.print key="applications"/]</h3>
  <table class="hover">
    <thead>
    <tr>
      <th>[@message.print key="name"/]</th>
      <th>[@message.print key="enabled"/]</th>
      <th>[@message.print key="create-registration"/]</th>
    </tr>
    </thead>
    <tbody>
    [#list applications![] as application]
     [#-- We are not yet displaying any overrides if they exist, I don't know of a good way to display that here. --]
      <tr>
        <td>${properties.display(application, "name")}</td>
        <td class="icon">
        [#if identityProvider.applicationConfiguration(application.id)??]${properties.display(identityProvider.applicationConfiguration(application.id), "enabled")}[#else]&ndash;[/#if]
        </td>
        <td class="icon">
        [#if identityProvider.applicationConfiguration(application.id)??]${properties.display(identityProvider.applicationConfiguration(application.id), "createRegistration")}[#else]&ndash;[/#if]
        </td>
      </tr>
    [/#list]
    </tbody>
  </table>
[/@dialog.view]
