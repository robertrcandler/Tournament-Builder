[#ftl/]
[#-- @ftlvariable name="eventTypes" type="java.util.List<io.fusionauth.domain.event.EventType>" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]


[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view]
[#-- TODO : Future :

 - Display User Action name instead of Id
 - Display Email template names instead of Id
 - Display Key names instead of Id

--]

  [#-- Top Level Attributes --]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=tenant propertyName="name"/]
    [@properties.rowEval nameKey="id" object=tenant propertyName="id"/]
    [@properties.rowEval nameKey="issuer" object=tenant propertyName="issuer"/]
  [/@properties.table]

  [#-- Login Theme --]
  <h3>[@message.print key="theme"/]</h3>
  [@properties.table]
    [@properties.row nameKey="themeId" value=properties.display(tenant, "themeId") /]
    [@properties.row nameKey="theme.name" value=properties.display(theme, "name") /]
  [/@properties.table]

  [#-- Email Configuration --]
  <h3>[@message.print key="smtp-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="emailConfiguration.host" value=properties.display(tenant, "emailConfiguration.host") /]
    [@properties.row nameKey="emailConfiguration.port" value=properties.display(tenant, "emailConfiguration.port") /]
    [@properties.row nameKey="emailConfiguration.username" value=properties.display(tenant, "emailConfiguration.username") /]
    [@properties.row nameKey="emailConfiguration.password" value=message.inline("smtp-password") /]
    [@properties.row nameKey="emailConfiguration.security" value=properties.display(tenant, "emailConfiguration.security") /]
    [@properties.row nameKey="emailConfiguration.defaultFromEmail" value=properties.display(tenant, "emailConfiguration.defaultFromEmail") /]
    [@properties.row nameKey="emailConfiguration.defaultFromName" value=properties.display(tenant, "emailConfiguration.defaultFromName") /]
  [/@properties.table]

  [#-- Email Configuration --]
  <h3>[@message.print key="email-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="emailConfiguration.forgotPasswordEmailTemplateId" value=properties.display(tenant, "emailConfiguration.forgotPasswordEmailTemplateId", message.inline("none-selected-email-template-disabled") false) /]
    [@properties.row nameKey="emailConfiguration.passwordlessEmailTemplateId" value=properties.display(tenant, "emailConfiguration.passwordlessEmailTemplateId", message.inline("none-selected-email-template-disabled") false) /]
    [@properties.row nameKey="emailConfiguration.setPasswordEmailTemplateId" value=properties.display(tenant, "emailConfiguration.setPasswordEmailTemplateId", message.inline("none-selected-email-template-disabled") false) /]

    [@properties.rowEval nameKey="emailConfiguration.verifyEmail" object=tenant propertyName="emailConfiguration.verifyEmail" booleanAsCheckmark=false/]
    [#if tenant.emailConfiguration.verifyEmail]
      [@properties.rowEval nameKey="emailConfiguration.verifyEmailWhenChanged" object=tenant propertyName="emailConfiguration.verifyEmailWhenChanged" booleanAsCheckmark=false/]
      [@properties.rowEval nameKey="emailConfiguration.verificationEmailTemplateId" object=tenant propertyName="emailConfiguration.verificationEmailTemplateId" /]
    [/#if]

    [@properties.rowNestedValue nameKey="emailConfiguration.properties"]
      [#if tenant.emailConfiguration.properties?has_content]
        <pre class="code not-pushed">${tenant.emailConfiguration.properties}</pre>
      [#else]
        &ndash;
      [/#if]
    [/@properties.rowNestedValue]
  [/@properties.table]

  [#-- Family configuration--]
  [#if tenant.familyConfiguration.enabled]
    <h3>[@message.print key="families"/]</h3>
    [@properties.table]
      [@properties.row nameKey="familyConfiguration.maximumChildAge" value=properties.display(tenant, "familyConfiguration.maximumChildAge") /]
      [@properties.row nameKey="familyConfiguration.minimumOwnerAge" value=properties.display(tenant, "familyConfiguration.minimumOwnerAge") /]
      [@properties.rowEval nameKey="familyConfiguration.parentEmailRequired" object=tenant propertyName="familyConfiguration.parentEmailRequired" booleanAsCheckmark=false /]
      [@properties.row nameKey="familyConfiguration.familyRequestEmailTemplateId" value=properties.display(tenant, "familyConfiguration.familyRequestEmailTemplateId", message.inline("none-selected-email-template-disabled") false) /]
      [@properties.row nameKey="familyConfiguration.confirmChildEmailTemplateId" value=properties.display(tenant, "familyConfiguration.confirmChildEmailTemplateId", message.inline("none-selected-email-template-disabled") false) /]
      [@properties.row nameKey="familyConfiguration.parentRegistrationEmailTemplateId" value=properties.display(tenant, "familyConfiguration.parentRegistrationEmailTemplateId", message.inline("none-selected-email-template-disabled") false) /]
    [/@properties.table]
  [/#if]

  [#--  OAuth Settings --]
  <h3>[@message.print key="oauth-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="httpSessionMaxInactiveInterval" value=properties.display(tenant, "httpSessionMaxInactiveInterval") /]
    [@properties.row nameKey="logoutURL" value=properties.display(tenant, "logoutURL") /]
  [/@properties.table]

  [#-- JWT --]
  <h3>[@message.print key="jwt-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="jwtConfiguration.idTokenKeyId" value=properties.display(tenant, "jwtConfiguration.idTokenKeyId") /]
    [@properties.row nameKey="jwtConfiguration.accessTokenKeyId" value=properties.display(tenant, "jwtConfiguration.accessTokenKeyId") /]
    [@properties.row nameKey="jwtConfiguration.refreshTokenTimeToLiveInMinutes" value=properties.display(tenant, "jwtConfiguration.refreshTokenTimeToLiveInMinutes") /]
    [@properties.row nameKey="jwtConfiguration.timeToLiveInSeconds" value=properties.display(tenant, "jwtConfiguration.timeToLiveInSeconds") /]
  [/@properties.table]

  [#-- Failed Authentication --]
  [#if tenant.failedAuthenticationConfiguration.userActionId??]
    <h3>[@message.print key="failed-login-settings"/]</h3>
    [@properties.table]
      [@properties.row nameKey="failedAuthenticationConfiguration.userActionId" value=properties.display(tenant, "failedAuthenticationConfiguration.userActionId") /]
      [@properties.row nameKey="failedAuthenticationConfiguration.tooManyAttempts" value=properties.display(tenant, "failedAuthenticationConfiguration.tooManyAttempts") /]
      [@properties.row nameKey="failedAuthenticationConfiguration.resetCountInSeconds" value=properties.display(tenant, "failedAuthenticationConfiguration.resetCountInSeconds") /]
      [@properties.row nameKey="failedAuthenticationConfiguration.actionDuration" value=properties.display(tenant, "failedAuthenticationConfiguration.actionDuration") /]
      [@properties.row nameKey="failedAuthenticationConfiguration.actionDurationUnit" value=properties.display(tenant, "failedAuthenticationConfiguration.actionDurationUnit") /]
    [/@properties.table]
  [/#if]

  [#-- Password --]
  <h3>[@message.print key="password-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="passwordValidationRules.minLength" value=properties.display(tenant, "passwordValidationRules.minLength") /]
    [@properties.row nameKey="passwordValidationRules.maxLength" value=properties.display(tenant, "passwordValidationRules.maxLength") /]
    [@properties.rowEval nameKey="passwordValidationRules.requireMixedCase" object=tenant propertyName="passwordValidationRules.requireMixedCase" booleanAsCheckmark=false /]
    [@properties.rowEval nameKey="passwordValidationRules.requireNonAlpha" object=tenant propertyName="passwordValidationRules.requireNonAlpha" booleanAsCheckmark=false /]
    [@properties.rowEval nameKey="passwordValidationRules.requireNumber" object=tenant propertyName="passwordValidationRules.requireNumber" booleanAsCheckmark=false /]
    [#if tenant.minimumPasswordAge.enabled]
      [@properties.row nameKey="minimumPasswordAge.seconds" value="${properties.display(tenant, 'minimumPasswordAge.seconds')} ${message.inline('SECONDS')}" /]
    [#else]
      [@properties.rowEval nameKey="minimumPasswordAge.seconds" object=tenant propertyName="minimumPasswordAge.enabled" booleanAsCheckmark=false /]
    [/#if]
    [#if tenant.maximumPasswordAge.enabled]
      [@properties.row nameKey="maximumPasswordAge.days" value="${properties.display(tenant, 'maximumPasswordAge.days')} ${message.inline('DAYS')}" /]
    [#else]
      [@properties.rowEval nameKey="maximumPasswordAge.days" object=tenant propertyName="maximumPasswordAge.enabled" booleanAsCheckmark=false /]
    [/#if]
    [#if tenant.passwordValidationRules.rememberPreviousPasswords.enabled]
      [@properties.row nameKey="passwordValidationRules.rememberPreviousPasswords.count" value=properties.display(tenant, "passwordValidationRules.rememberPreviousPasswords.count") /]
    [#else]
      [@properties.rowEval nameKey="passwordValidationRules.rememberPreviousPasswords.count" object=tenant propertyName="passwordValidationRules.rememberPreviousPasswords.enabled" booleanAsCheckmark=false /]
    [/#if]
  [/@properties.table]

  [#-- Password Encryption --]
  <h3>[@message.print key="password-encryption-settings"/]</h3>
  [@properties.table]
    [@properties.row nameKey="passwordEncryptionConfiguration.encryptionScheme" value=message.inline("${tenant.passwordEncryptionConfiguration.encryptionScheme}") /]
    [@properties.row nameKey="passwordEncryptionConfiguration.encryptionSchemeFactor" value=properties.display(tenant, "passwordEncryptionConfiguration.encryptionSchemeFactor") /]
    [@properties.row nameKey="passwordEncryptionConfiguration.modifyEncryptionSchemeOnLogin" value=properties.display(tenant, "passwordEncryptionConfiguration.modifyEncryptionSchemeOnLogin", "\x2013", false) /]
  [/@properties.table]

  [#-- External Identifier --]
  <h3>[@message.print key="external-identifiers"/]</h3>
  <table>
    <thead>
    <tr>
      <th>[@message.print key="identifier"/]</th>
      <th>[@message.print key="generation-type"/]</th>
      <th>[@message.print key="ttl"/]</th>
    </tr>
    </thead>
    <tbody>
    [#list ["authorizationGrantId", "changePasswordId", "deviceCode", "emailVerificationId", "emailVerificationId", "externalAuthenticationId", "oneTimePassword", "passwordlessLogin","registrationVerificationId", "setupPasswordId", "twoFactorId", "twoFactorTrustId"] as id]
      <tr>
        <td [#if id =="deviceCode"]class="top" rowspan="2"[/#if]>[@message.print key="externalIdentifierConfiguration.${id}"/]</td>
        <td>
        [#if ("(tenant.externalIdentifierConfiguration.${id}Generator.type)!''"?eval)?has_content]
          ${properties.display(tenant "externalIdentifierConfiguration.${id}Generator.length")}&nbsp;${message.inline("tenant.externalIdentifierConfiguration.${id}Generator.type"?eval)}
        [#elseif id == "deviceCode"]
           ${properties.display(tenant "externalIdentifierConfiguration.deviceUserCodeIdGenerator.length")}&nbsp;${message.inline(tenant.externalIdentifierConfiguration.deviceUserCodeIdGenerator.type)}  [@message.print key="userCode"/]
        [#else]
          32 [@message.print key="randomBytes"/]
        [/#if]
        </td>
        <td>${properties.display(tenant, "externalIdentifierConfiguration.${id}TimeToLiveInSeconds")} ${message.inline("SECONDS")} (${helpers.approximateFromSeconds("tenant.externalIdentifierConfiguration.${id}TimeToLiveInSeconds"?eval)})</td>
      </tr>

      [#if id == "deviceCode"]
      <tr>
        <td>32 [@message.print key="randomBytes"/] [@message.print key="deviceCode"/]</td>
        <td>${properties.display(tenant, "externalIdentifierConfiguration.${id}TimeToLiveInSeconds")} ${message.inline("SECONDS")} (${helpers.approximateFromSeconds("tenant.externalIdentifierConfiguration.${id}TimeToLiveInSeconds"?eval)})</td>
      </tr>
      [/#if]
      [/#list]
    </tbody>
  </table>

  [#-- Events --]
  <h3>[@message.print key="event-settings"/]</h3>
  <table>
    <thead>
    <tr>
      <th>[@message.print key="event"/]</th>
      <th>[@message.print key="enabled"/]</th>
      <th>[@message.print key="transaction"/]</th>
    </tr>
    </thead>
    <tbody>
      [#list eventTypes as eventType]
      <tr>
        <td>${eventType.eventName()}</td>
        [#-- When we add events and the object has not been saved from the UI the event config may be missing some events. --]
        [#if tenant.eventConfiguration.events(eventType)?? ]
          <td>${properties.display(tenant.eventConfiguration.events(eventType), "enabled")}</td>
          <td>[@message.print key="${properties.display(tenant.eventConfiguration.events(eventType), 'transactionType')}" /]</td>
        [#else]
          <td></td>
          <td>[@message.print key="None"/]</td>
        [/#if]
      </tr>
      [/#list]
    </tbody>
  </table>

  [#-- Data --]
  [#if (tenant.data)?? && tenant.data?has_content]
  <h3>[@message.print key="data"/]</h3>
  <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(tenant.data)}</pre>
  [/#if]
[/@dialog.view]
