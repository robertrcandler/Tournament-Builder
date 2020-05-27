[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="accessTokenKey" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="accessTokenPopulateLambda" type="io.fusionauth.domain.Lambda" --]
[#-- @ftlvariable name="idTokenPopulateLambda" type="io.fusionauth.domain.Lambda" --]
[#-- @ftlvariable name="samlv2PopulateLambda" type="io.fusionauth.domain.Lambda" --]
[#-- @ftlvariable name="fusionAuthHost" type="java.lang.String" --]
[#-- @ftlvariable name="idTokenKey" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="samlKey" type="io.fusionauth.domain.Key" --]

[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
  [#-- Top Level Attributes --]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=application propertyName="name"/]
    [@properties.rowEval nameKey="id" object=application propertyName="id"/]
    [@properties.row nameKey="tenant" value=helpers.tenantName(application.tenantId)/]
    [@properties.rowEval nameKey="verifyRegistration" object=application propertyName="verifyRegistration" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="verificationEmailTemplateId" object=application propertyName="forgotPasswordEmailTemplateId" /]
  [/@properties.table]

  [#-- OAuth v2 / OpenID Connect Integration --]
  <h3>[@message.print key="oauth.integration-information"/]</h3>
  [@properties.table]
    [#setting url_escaping_charset='UTF-8']
    [#assign redirectValues]
      [#list application.oauthConfiguration.authorizedRedirectURLs as redirect ]
      <div ${redirect?is_last?then("", "class='mb-2'")}>
        ${fusionAuthHost}/oauth2/authorize?client_id=${application.oauthConfiguration.clientId}&response_type=code&redirect_uri=<span class='blue-text'><strong>${redirect.toString()?url}</strong></span>
      </div>
      [#else]
      <div>
        ${fusionAuthHost}/oauth2/authorize?client_id=${application.oauthConfiguration.clientId}&response_type=code&redirect_uri=<span class='red-text'><strong>{your redirect URI here}</strong></span>
      </div>
      [/#list]
    [/#assign]
    [@properties.row nameKey="${(application.oauthConfiguration.authorizedRedirectURLs?size > 1)?then('oauth.idpLoginURLs', 'oauth.idpLoginURL')}" value=redirectValues/]
    [@properties.row nameKey="oauth.idpLogoutURL" value=(fusionAuthHost + "/oauth2/logout?client_id=" + application.oauthConfiguration.clientId)/]
    [@properties.row nameKey="oauth.introspectURL" value=(fusionAuthHost + "/oauth2/introspect")/]
    [@properties.row nameKey="oauth.tokenURL" value=(fusionAuthHost + "/oauth2/token")/]
    [@properties.row nameKey="oauth.userinfoURL" value=(fusionAuthHost + "/oauth2/userinfo")/]
    [@properties.row nameKey="oauth.deviceURL" value=(fusionAuthHost + "/oauth2/device_authorize")/]
    [@properties.row nameKey="oauth.openIdConfiguration" value=(fusionAuthHost + "/.well-known/openid-configuration/" + application.tenantId) /]
    [@properties.row nameKey="oauth.jwks" value=(fusionAuthHost + "/.well-known/jwks.json") /]
  [/@properties.table]

  [#-- SAMLv2 Integration --]
  [#if application.samlv2Configuration.enabled]
  <h3>[@message.print key="samlv2.integration-information"/]</h3>
  [@properties.table]
    [@properties.row nameKey="samlv2.entityId" value=(fusionAuthHost + "/samlv2/" + application.tenantId)/]
    [@properties.row nameKey="samlv2.idpLoginURL" value=(fusionAuthHost + "/samlv2/login/" + application.tenantId)/]
    [@properties.row nameKey="samlv2.idpLogoutURL" value=(fusionAuthHost + "/samlv2/logout/" + application.id)/]
    [@properties.row nameKey="samlv2.metadataURL" value=(fusionAuthHost + "/samlv2/metadata/" + application.tenantId)/]
    [@properties.row nameKey="samlv2.nameIdFormat" value="urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"/]
  [/@properties.table]
  [/#if]

  [#-- Security Configuration --]
  <h3>[@message.print key="login-configuration"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="loginConfiguration.requireAuthentication" object=application propertyName="loginConfiguration.requireAuthentication" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="loginConfiguration.generateRefreshTokens" object=application propertyName="loginConfiguration.generateRefreshTokens" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="loginConfiguration.allowTokenRefresh" object=application propertyName="loginConfiguration.allowTokenRefresh" booleanAsCheckmark=false/]
  [/@properties.table]

  [#-- Passwordless Configuration --]
  <h3>[@message.print key="passwordlessConfiguration"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="passwordlessConfiguration.enabled" object=application propertyName="passwordlessConfiguration.enabled" booleanAsCheckmark=false/]
  [/@properties.table]

  [#-- Authentication Tokens --]
  <h3>[@message.print key="authenticationTokenConfiguration"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="authenticationTokenConfiguration.enabled" object=application propertyName="authenticationTokenConfiguration.enabled" booleanAsCheckmark=false/]
  [/@properties.table]

  [#-- CleanSpeak Configuration --]
  [#if (application.cleanSpeakConfiguration.enabled)!false]
    <h3>[@message.print key="cleanSpeak-configuration"/]</h3>
    [@properties.table]
      [@properties.rowEval nameKey="cleanspeak.applicationIds" object=application.cleanSpeakConfiguration propertyName="applicationIds"/]
      [@properties.rowEval nameKey="cleanspeak.username.moderation.enabled" object=application.cleanSpeakConfiguration.usernameModeration propertyName="enabled" booleanAsCheckmark=false/]
      [@properties.rowEval nameKey="cleanspeak.username.moderation.applicationId" object=application.cleanSpeakConfiguration.usernameModeration propertyName="applicationId"/]
    [/@properties.table]
  [/#if]

  [#-- JWT Configuration --]
  <h3>[@message.print key="jwt"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="jwtConfiguration.enabled" object=application.jwtConfiguration propertyName="enabled" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="jwtConfiguration.refreshTokenTimeToLiveInMinutes" object=application.jwtConfiguration propertyName="refreshTokenTimeToLiveInMinutes"/]
    [@properties.rowEval nameKey="jwtConfiguration.timeToLiveInSeconds" object=application.jwtConfiguration propertyName="timeToLiveInSeconds"/]
    [#if accessTokenKey?has_content]
      [@properties.row nameKey="jwtConfiguration.accessTokenKeyName" value=properties.display(accessTokenKey, "name") /]
      [@properties.row nameKey="jwtConfiguration.accessTokenKeyId" value=properties.display(accessTokenKey, "id") /]
    [#else]
      [@properties.row nameKey="jwtConfiguration.accessTokenKeyId" value="\x2013"/]
    [/#if]
    [#if idTokenKey?has_content]
      [@properties.row nameKey="jwtConfiguration.idTokenKeyName" value=properties.display(idTokenKey, "name") /]
      [@properties.row nameKey="jwtConfiguration.idTokenKeyId" value=properties.display(idTokenKey, "id") /]
    [#else]
      [@properties.row nameKey="jwtConfiguration.idTokenKeyId" value="\x2013"/]
    [/#if]
    [#if accessTokenPopulateLambda?has_content]
      [@properties.row nameKey="lambdaConfiguration.accessTokenPopulateName" value=properties.display(accessTokenPopulateLambda, "name") /]
      [@properties.row nameKey="lambdaConfiguration.accessTokenPopulateId" value=properties.display(accessTokenPopulateLambda, "id") /]
    [#else]
      [@properties.row nameKey="lambdaConfiguration.accessTokenPopulateId" value="\x2013"/]
    [/#if]
    [#if idTokenPopulateLambda?has_content]
      [@properties.row nameKey="lambdaConfiguration.idTokenPopulateName" value=properties.display(idTokenPopulateLambda, "name") /]
      [@properties.row nameKey="lambdaConfiguration.idTokenPopulateId" value=properties.display(idTokenPopulateLambda, "id") /]
    [#else]
      [@properties.row nameKey="lambdaConfiguration.idTokenPopulateId" value="\x2013"/]
    [/#if]
  [/@properties.table]

  [#-- Registration Configuration --]
  <h3>[@message.print key="registration-configuration"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="registrationConfiguration.enabled" object=application.registrationConfiguration propertyName="enabled" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="registrationConfiguration.confirmPassword" object=application.registrationConfiguration propertyName="confirmPassword" booleanAsCheckmark=false/]
    [@properties.row nameKey="registrationConfiguration.loginIdType" value=message.inline("${application.registrationConfiguration.loginIdType}")/]
    <tr>
      <td class="top" style="padding-left: 0"> 
        [@message.print key="registration-fields"/]
        [@message.print key="propertySeparator"/]
      </td>
      <td style="padding-left: 0">
        <table class="nested">
          <thead>
          <tr>
            <th>[@message.print key="name"/]</th>
            <th class="text-center">[@message.print key="field-enabled"/]</th>
            <th class="text-center">[@message.print key="field-required"/]</th>
          </tr>
          </thead>
          <tbody>

          [#list ["birthDate", "firstName", "fullName", "lastName", "middleName", "mobilePhone"] as field]
            <tr>
              <td>[@message.print key="registrationConfiguration." + field /]</td>
              <td class="text-center">${properties.display(application.registrationConfiguration, field + ".enabled")}</td>
              <td class="text-center">${properties.display(application.registrationConfiguration, field + ".required")}</td>
            </tr>
          [/#list]
          </tbody>
        </table>
      </td>
    </tr>
  [/@properties.table]

  [#-- OAuth Configuration --]
  <h3>[@message.print key="oauth"/]</h3>
  [@properties.table]
    [@properties.row nameKey="oauth.clientId" value=properties.display(application.oauthConfiguration, "clientId", application.id.toString())/]
    [@properties.rowEval nameKey="oauth.clientSecret" object=application.oauthConfiguration propertyName="clientSecret"/]
    [@properties.rowEval nameKey="oauth.requireClientAuthentication" object=application.oauthConfiguration propertyName="requireClientAuthentication" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="oauth.generateRefreshTokens" object=application.oauthConfiguration propertyName="generateRefreshTokens" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="oauth.logoutURL" object=application.oauthConfiguration propertyName="logoutURL"/]
    [@properties.row nameKey="oauth.logoutBehavior" value=message.inline(application.oauthConfiguration.logoutBehavior)/]
    [@properties.rowEval nameKey="oauth.authorizedOriginURLs" object=application.oauthConfiguration propertyName="authorizedOriginURLs"/]
    [@properties.rowEval nameKey="oauth.authorizedRedirects" object=application.oauthConfiguration propertyName="authorizedRedirectURLs"/]
    [@properties.row nameKey="oauth.enabledGrants" value=properties.join(application.oauthConfiguration.enabledGrants, true)/]
  [/@properties.table]

  [#-- SAML v2 Configuration --]
  <h3>[@message.print key="saml"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="samlv2.enabled" object=application.samlv2Configuration propertyName="enabled" booleanAsCheckmark=false/]
    [@properties.rowEval nameKey="samlv2.issuer" object=application.samlv2Configuration propertyName="issuer"/]
    [@properties.row nameKey="samlv2.audience" value=properties.display(application.samlv2Configuration, "audience", application.samlv2Configuration.issuer)/]
    [@properties.rowEval nameKey="samlv2.callbackURL" object=application.samlv2Configuration propertyName="callbackURL"/]

    [@properties.row nameKey="samlv2.xmlSignatureC14nMethod" value=message.inline(application.samlv2Configuration.xmlSignatureC14nMethod)/]
    [#if samlv2PopulateLambda?has_content]
      [@properties.row nameKey="lambdaConfiguration.samlv2PopulateName" value=properties.display(samlv2PopulateLambda, "name") /]
      [@properties.row nameKey="lambdaConfiguration.samlv2PopulateId" value=properties.display(samlv2PopulateLambda, "id") /]
    [#else]
      [@properties.row nameKey="lambdaConfiguration.samlv2PopulateId" value="\x2013"/]
    [/#if]
    [@properties.rowEval nameKey="samlv2.debug" object=application.samlv2Configuration propertyName="debug" booleanAsCheckmark=false/]
    [#if samlKey?has_content]
      [@properties.row nameKey="samlv2.keyId" value=properties.display(samlKey, "name")  /]
      [@properties.row nameKey="keyId" value=properties.display(samlKey, "id") /]
    [#else]
      [@properties.row nameKey="samlv2.keyId" value="\x2013"/]
    [/#if]
  [/@properties.table]

  [#-- Roles --]
  <h3>[@message.print key="roles"/]</h3>
  <table>
    <thead>
    <tr>
      <th>[@message.print key="name"/]</th>
      <th class="text-center">[@message.print key="default"/]</th>
      <th class="text-center">[@message.print key="superRole"/]</th>
      <th>[@message.print key="description"/]</th>
    </tr>
    </thead>
    <tbody>
      [#if (application.roles)?has_content]
        [#list application.roles as role]
        <tr>
          <td>${properties.display(role, 'name')}</td>
          <td class="text-center">${properties.display(role, 'isDefault')}</td>
          <td class="text-center">${properties.display(role, 'isSuperRole')}</td>
          <td>${properties.display(role, 'description')}</td>
        </tr>
        [/#list]
      [#else]
      <tr>
        <td colspan="3">[@message.print key="no-roles"/]</td>
      </tr>
      [/#if]
    </tbody>
  </table>

  [#if (application.data)?? && application.data?has_content]
  <h3>[@message.print key="data"/]</h3>
  <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(application.data)}</pre>
  [/#if]
[/@dialog.view]
