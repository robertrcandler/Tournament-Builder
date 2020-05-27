[#ftl/]
[#-- @ftlvariable name="breachMatchModes" type="io.fusionauth.domain.PasswordBreachDetection.BreachMatchMode[]" --]
[#-- @ftlvariable name="breachActions" type="io.fusionauth.domain.PasswordBreachDetection.BreachAction[]" --]
[#-- @ftlvariable name="defaultTenantId" type="java.util.UUID" --]
[#-- @ftlvariable name="editPasswordOption" type="io.fusionauth.app.action.admin.tenant.BaseFormAction.EditPasswordOption" --]
[#-- @ftlvariable name="emailSecurityTypes" type="io.fusionauth.domain.EmailConfiguration.EmailSecurityType[]" --]
[#-- @ftlvariable name="emailTemplates" type="java.util.List<io.fusionauth.domain.email.EmailTemplate>" --]
[#-- @ftlvariable name="eventTypes" type="java.util.List<io.fusionauth.domain.event.EventType>" --]
[#-- @ftlvariable name="expiryUnits" type="io.fusionauth.domain.ExpiryUnit[]" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="transactionTypes" type="io.fusionauth.domain.TransactionType[]" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro tenantsTable]
  <table class="hover">
    <thead>
      <th><a href="#">[@message.print "name"/]</a></th>
      <th class="hide-on-mobile"><a href="#">[@message.print "id"/]</a></th>
      <th data-sortable="false" class="action">[@message.print "action"/]</th>
    </thead>
    <tbody>
      [#list tenants as key, tenant]
        <tr>
          <td>${properties.display(tenant, "name")}</td>
          <td class="hide-on-mobile">${properties.display(tenant, "id")}</td>
          <td class="action">
            [@button.action href="/admin/tenant/edit?tenantId=${tenant.id}" icon="edit" key="edit" color="blue"/]
            [@button.action href="add?tenantId=${tenant.id}" icon="copy" key="duplicate" color="purple"/]
            [@button.action href="/ajax/tenant/view/${tenant.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true resizeDialog=true/]
            [#if tenant.id != defaultTenantId]
              [@button.action href="/admin/tenant/delete?tenantId=${tenant.id}" icon="trash" key="delete" color="red"/]
            [/#if]
          </td>
        </tr>
      [#else]
        <tr>
          <td colspan="3">[@message.print "no-tenants"/]</td>
        </tr>
      [/#list]
    </tbody>
  </table>
[/#macro]

[#macro tenantFields action]
  <fieldset>
    [#if action=="edit"]
      [@control.hidden name="tenantId"/]
      [@control.text disabled=true name="tenantId" tooltip=message.inline('{tooltip}readOnly')/]
    [#else]
      [@control.text name="tenantId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=message.inline('{tooltip}tenantId')/]
    [/#if]
    [@control.text required=true name="tenant.name" autofocus="autofocus" tooltip=message.inline('{tooltip}tenant.name')/]
  </fieldset>

  <fieldset class="mt-4">
    <ul class="tabs">
      <li><a href="#general-configuration">[@message.print key="general"/]</a></li>
      <li><a href="#email-configuration">[@message.print key="email"/]</a></li>
      <li><a href="#family-configuration">[@message.print key="family"/]</a></li>
      <li><a href="#oauth-configuration">[@message.print key="oauth"/]</a></li>
      <li><a href="#jwt-configuration">[@message.print key="jwt"/]</a></li>
      <li><a href="#password-configuration">[@message.print key="password"/]</a></li>
      <li><a href="#webhook-configuration">[@message.print key="webhooks"/]</a></li>
      <li><a href="#advanced-configuration">[@message.print key="advanced"/]</a></li>
    </ul>

    <div id="general-configuration" class="hidden">
      [@generalConfiguration/]
    </div>
    <div id="email-configuration" class="hidden">
      [@emailConfiguration action/]
    </div>
    <div id="family-configuration" class="hidden">
      [@familyConfiguration/]
    </div>
    <div id="oauth-configuration" class="hidden">
      <fieldset>
        <legend>[@message.print key="oauth-settings"/]</legend>
        <p><em> [@message.print key="{description}oauth-settings"/]</em></p>
        [@control.text name="tenant.httpSessionMaxInactiveInterval" rightAddonText="${function.message('SECONDS')}" autocapitalize="none" autocorrect="off" placeholder="e.g. 3600" tooltip=function.message('{tooltip}tenant.httpSessionMaxInactiveInterval')/]
        [@control.text name="tenant.logoutURL" autocapitalize="none" autocorrect="off" placeholder="e.g. http://www.example.com" tooltip=function.message('{tooltip}tenant.logoutURL')/]
      </fieldset>
    </div>
    <div id="jwt-configuration" class="hidden">
      [@jwtConfiguration/]
    </div>
    <div id="password-configuration" class="hidden">
      [@passwordConfiguration/]
    </div>
    <div id="webhook-configuration" class="hidden">
      [@webhookConfiguration/]
    </div>
    <div id="advanced-configuration" class="hidden">
      [@advancedConfiguration/]
    </div>
  </fieldset>
[/#macro]

[#macro webhookConfiguration]
<fieldset>
  <legend>[@message.print key="webhook-transactions"/]</legend>
  <p><em>[@message.print key="{description}webhook-transactions"/]</em></p>
  <table>
    <thead>
    <tr>
      <th>[@message.print key="event"/]</th>
      <th>[@message.print key="enabled"/]</th>
      <th>[@message.print key="transaction"/]</th>
    </tr>
    </thead>
    <tbody>
    [#list eventTypes as type]
      <tr>
        <td>${type.eventName()}</td>
        <td>[@control.checkbox name="tenant.eventConfiguration.events['${type}'].enabled" labelKey="empty" value="true" uncheckedValue="false" includeFormRow=false/]</td>
        <td>[@control.select items=transactionTypes name="tenant.eventConfiguration.events['${type}'].transactionType" labelKey="empty" includeFormRow=false/]</td>
      </tr>
    [/#list]
    </tbody>
  </table>
</fieldset>
[/#macro]

[#macro advancedConfiguration]
  <fieldset>
    <legend>[@message.print key="external-identifiers-duration"/]</legend>
    <em>[@message.print key="{description}external-identifiers-1"/]</em>
    <p><em>[@message.print key="{description}external-identifiers-2"/]</em></p>
    [@control.text name="tenant.externalIdentifierConfiguration.authorizationGrantIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.authorizationGrantIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.authorizationGrantIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.changePasswordIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.changePasswordIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.changePasswordIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.emailVerificationIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.emailVerificationIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.emailVerificationIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.externalAuthenticationIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.externalAuthenticationIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.externalAuthenticationIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.oneTimePasswordTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.oneTimePasswordTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.oneTimePasswordTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.passwordlessLoginTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.passwordlessLoginTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.passwordlessLoginTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.registrationVerificationIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.registrationVerificationIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.registrationVerificationIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.setupPasswordIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.setupPasswordIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.setupPasswordIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.twoFactorIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.twoFactorIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.twoFactorIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.twoFactorTrustIdTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.twoFactorTrustIdTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.twoFactorTrustIdTimeToLiveInSeconds')/]
    [@control.text name="tenant.externalIdentifierConfiguration.deviceCodeTimeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.externalIdentifierConfiguration.deviceCodeTimeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}tenant.externalIdentifierConfiguration.deviceCodeTimeToLiveInSeconds')/]
  </fieldset>

  <fieldset>
    <legend>[@message.print key="external-identifiers-generator"/]</legend>
    <p class="mb-1"><em>[@message.print key="{description}external-identifiers-generator"/]</em></p>

    <div id="long-description" class="slide-open">
      <em>[@message.print key="{description}external-identifiers-generator-long"/]</em>
    </div>

    <a href="#" class="slide-open-toggle" style="margin-bottom: 1.5rem !important; margin-top: 1rem;" data-expand-open="long-description">
      <span>[@message.print key="tell-me-more"/] <i class="fa fa-angle-down"></i></span>
    </a>

    [#assign flexStyle = "flex: 0 1 30%;"/]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.changePasswordIdGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.changePasswordIdGenerator.length" labelKey="tenant.externalIdentifierConfiguration.changePasswordIdTimeToLiveInSeconds" required=true  rightAddonRaw=rightAddonRaw style=flexStyle/]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.emailVerificationIdGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.emailVerificationIdGenerator.length" labelKey="tenant.externalIdentifierConfiguration.emailVerificationIdTimeToLiveInSeconds" required=true  rightAddonRaw=rightAddonRaw style=flexStyle /]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.passwordlessLoginGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.passwordlessLoginGenerator.length" labelKey="tenant.externalIdentifierConfiguration.passwordlessLoginTimeToLiveInSeconds" required=true rightAddonRaw=rightAddonRaw style=flexStyle/]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.registrationVerificationIdGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.registrationVerificationIdGenerator.length" labelKey="tenant.externalIdentifierConfiguration.registrationVerificationIdTimeToLiveInSeconds" required=true rightAddonRaw=rightAddonRaw style=flexStyle/]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.setupPasswordIdGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.setupPasswordIdGenerator.length" labelKey="tenant.externalIdentifierConfiguration.setupPasswordIdTimeToLiveInSeconds" required=true rightAddonRaw=rightAddonRaw style=flexStyle/]

    [#assign rightAddonRaw]
      [@control.select name="tenant.externalIdentifierConfiguration.deviceUserCodeIdGenerator.type" items=secureGeneratorTypes labelKey="empty" includeFormRow=false/]
    [/#assign]
    [@control.text name="tenant.externalIdentifierConfiguration.deviceUserCodeIdGenerator.length" labelKey="tenant.externalIdentifierConfiguration.deviceUserCode" required=true rightAddonRaw=rightAddonRaw style=flexStyle/]
  </fieldset>

  <fieldset>
    <legend>[@message.print key="smtp-settings"/]</legend>
    <p>[@message.print key="{description}smtp-settings-advanced"/]</p>
    [@control.textarea name="tenant.emailConfiguration.properties"/]
  </fieldset>
[/#macro]

[#macro generalConfiguration]
  <fieldset>
    [@control.text name="tenant.issuer" required=true placeholder=message.inline("{placeholder}tenant.issuer") tooltip=message.inline("{tooltip}tenant.issuer")/]
    [@control.select name="tenant.themeId" items=themes valueExpr="id" textExpr="name" tooltip=message.inline("{tooltip}tenant.themeId")/]
  </fieldset>
[/#macro]

[#macro emailConfiguration action]
  <fieldset>
    <legend>[@message.print key="smtp-settings"/]</legend>
    <div style="display: flex;">
      <div class="top" style="flex-grow: 1">
        <p class="mt-0" style="margin-bottom: 20px;"><em>[@message.print key="{description}smtp-settings"/]</em></p>
      </div>
      <div style="flex-shrink: 1">
        [@button.iconLinkWithText href="/ajax/tenant/smtp/test?tenantId=${(tenant.id)!''}" id="send-test-email" color="blue" icon="send-o" textKey="send-test-email" class="push-left" ajaxForm=true /]
      </div>
    </div>
      [@control.text name="tenant.emailConfiguration.host" required=true/]
      [@control.text name="tenant.emailConfiguration.port" required=true/]
      [@control.text name="tenant.emailConfiguration.username" autocomplete="username"/]
      [#if action == "edit"]
        [@control.checkbox name="editPasswordOption" value="update" uncheckedValue="useExisting" data_slide_open="password-fields" tooltip=message.inline("{tooltip}editPasswordOption")/]
        <div id="password-fields" class="slide-open [#if editPasswordOption == "update"]open[/#if]">
          [@control.password name="tenant.emailConfiguration.password" value="" required=true autocomplete="new-password" /]
        </div>
      [#else]
        [#-- Add - just show the password field, it is optional --]
        [@control.password name="tenant.emailConfiguration.password" value="" required=false autocomplete="new-password" /]
      [/#if]

      [@control.select items=emailSecurityTypes name="tenant.emailConfiguration.security" tooltip=function.message("{tooltip}tenant.emailConfiguration.security")/]
      [@control.text name="tenant.emailConfiguration.defaultFromEmail" tooltip=message.inline("{tooltip}tenant.emailConfiguration.defaultFromEmail")/]
      [@control.text name="tenant.emailConfiguration.defaultFromName" tooltip=message.inline("{tooltip}tenant.emailConfiguration.defaultFromName")/]
  </fieldset>

  <fieldset>
    <legend>[@message.print key="email-verification-settings"/]</legend>
      [#if emailTemplates?? && emailTemplates?size gt 0]
        [@control.checkbox name="tenant.emailConfiguration.verifyEmail" value="true" uncheckedValue="false" data_slide_open="email-verification-settings" tooltip=function.message("{tooltip}tenant.emailConfiguration.verifyEmail")/]
        <div id="email-verification-settings"  class="slide-open [#if tenant.emailConfiguration.verifyEmail]open[/#if]">
          [@control.checkbox name="tenant.emailConfiguration.verifyEmailWhenChanged" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}tenant.emailConfiguration.verifyEmailWhenChanged")/]
          [@control.select items=emailTemplates name="tenant.emailConfiguration.verificationEmailTemplateId" selected=tenant.emailConfiguration.verificationEmailTemplateId valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-required" required=true/]
          [@control.checkbox name="tenant.userDeletePolicy.unverified.enabled" value="true" uncheckedValue="false" data_slide_open="delete-unverified-settings" tooltip=function.message("{tooltip}tenant.userDeletePolicy.unverified.enabled")/]
          <div id="delete-unverified-settings" class="slide-open [#if tenant.userDeletePolicy.unverified.enabled]open[/#if]">
            [@control.text name="tenant.userDeletePolicy.unverified.numberOfDaysToRetain" rightAddonText="${function.message('DAYS')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message("{tooltip}tenant.userDeletePolicy.unverified.numberOfDaysToRetain")/]
          </div>
        </div>
      [#else]
        [@control.hidden name="tenant.emailConfiguration.verifyEmail"/]
        [@control.hidden name="tenant.emailConfiguration.verifyEmailWhenChanged"/]
        [@message.print key="no-email-templates"/]
      [/#if]
  </fieldset>

  <fieldset>
    <legend>[@message.print key="template-settings"/]</legend>
    <p><em>[@message.print key="{description}template-settings"/]</em></p>
      [#if emailTemplates?? && emailTemplates?size gt 0]
        [@control.select items=emailTemplates name="tenant.emailConfiguration.setPasswordEmailTemplateId" selected=tenant.emailConfiguration.setPasswordEmailTemplateId valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-disabled" tooltip=function.message('{tooltip}tenant.emailConfiguration.setPasswordEmailTemplateId')/]
        [@control.select items=emailTemplates name="tenant.emailConfiguration.forgotPasswordEmailTemplateId" selected=tenant.emailConfiguration.forgotPasswordEmailTemplateId valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-disabled" tooltip=function.message('{tooltip}tenant.emailConfiguration.forgotPasswordEmailTemplateId')/]
        [@control.select items=emailTemplates name="tenant.emailConfiguration.passwordlessEmailTemplateId" selected=tenant.emailConfiguration.passwordlessEmailTemplateId valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-disabled" tooltip=function.message('{tooltip}tenant.emailConfiguration.passwordlessEmailTemplateId')/]
      [#else]
        [@control.hidden name="tenant.emailConfiguration.forgotPasswordEmailTemplateId"/]
        [@control.hidden name="tenant.emailConfiguration.setPasswordEmailTemplateId"/]
        [@control.hidden name="tenant.emailConfiguration.verificationEmailTemplateId"/]
        [@message.print key="no-email-templates"/]
      [/#if]
  </fieldset>
[/#macro]

[#macro familyConfiguration]
  <legend>[@message.print key="family-settings"/]</legend>
    <p><em>[@message.print key="{description}family-settings"/]</em></p>
  <fieldset>
    [@control.checkbox name="tenant.familyConfiguration.enabled" value="true" uncheckedValue="false" data_slide_open="family-configuration-options"/]
    <div id="family-configuration-options" class="slide-open [#if tenant.familyConfiguration.enabled]open[/#if]">
      [@control.text name="tenant.familyConfiguration.maximumChildAge" required=true tooltip=function.message('{tooltip}tenant.familyConfiguration.maximumChildAge')/]
      [@control.text name="tenant.familyConfiguration.minimumOwnerAge" required=true tooltip=function.message('{tooltip}tenant.familyConfiguration.minimumOwnerAge')/]
      [@control.checkbox name="tenant.familyConfiguration.allowChildRegistrations" value="true" uncheckedValue="false" required=true tooltip=function.message('{tooltip}tenant.familyConfiguration.allowChildRegistrations') data_slide_open="child-regsitration" data_slide_closed="no-child-registration"/]
      <div id="no-child-registration" class="slide-open [#if !tenant.familyConfiguration.allowChildRegistrations]open[/#if]">
        [@control.select name="tenant.familyConfiguration.familyRequestEmailTemplateId" items=emailTemplates valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-disabled" tooltip=function.message('{tooltip}tenant.familyConfiguration.familyRequestEmailTemplateId')/]
      </div>
      <div id="child-registration" class="slide-open [#if tenant.familyConfiguration.allowChildRegistrations]open[/#if]">
        [@control.select name="tenant.familyConfiguration.confirmChildEmailTemplateId" items=emailTemplates valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-disabled" tooltip=function.message('{tooltip}tenant.familyConfiguration.confirmChildEmailTemplateId')/]
        [@control.select name="tenant.familyConfiguration.parentRegistrationEmailTemplateId" items=emailTemplates valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-disabled" tooltip=function.message('{tooltip}tenant.familyConfiguration.parentRegistrationEmailTemplateId')/]
        [@control.checkbox name="tenant.familyConfiguration.parentEmailRequired" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.familyConfiguration.parentEmailRequired')/]
      </div>
      [@control.checkbox name="tenant.familyConfiguration.deleteOrphanedAccounts" value="true" uncheckedValue="false" data_slide_open="delete-orphaned-settings" tooltip=function.message("{tooltip}tenant.familyConfiguration.deleteOrphanedAccounts")/]
      <div id="delete-orphaned-settings" class="slide-open [#if tenant.familyConfiguration.deleteOrphanedAccounts]open[/#if]">
        [@control.text name="tenant.familyConfiguration.deleteOrphanedAccountsDays" rightAddonText="${function.message('DAYS')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message("{tooltip}tenant.familyConfiguration.deleteOrphanedAccountsDays")/]
      </div>
    </div>
  </fieldset>
[/#macro]

[#macro passwordConfiguration]
  <fieldset>
    <legend>[@message.print key="failed-login-settings"/]</legend>
    <p><em>[@message.print key="{description}failed-login-settings"/]</em></p>
    [@control.select items=failedAuthenticationUserActions name="tenant.failedAuthenticationConfiguration.userActionId" selected=tenant.failedAuthenticationConfiguration.userActionId valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-user-action" tooltip=function.message('{tooltip}tenant.failedAuthenticationConfiguration.userActionId')/]
    <div id="failed-authentication-options" class="slide-open [#if (tenant.failedAuthenticationConfiguration.userActionId??)!false]open[/#if]">
      [@control.text name="tenant.failedAuthenticationConfiguration.tooManyAttempts" tooltip=function.message("{tooltip}tenant.failedAuthenticationConfiguration.tooManyAttempts") autocapitalize="none" autocorrect="off" required=true/]
      [@control.text name="tenant.failedAuthenticationConfiguration.resetCountInSeconds" tooltip=function.message("{tooltip}tenant.failedAuthenticationConfiguration.resetCountInSeconds") autocapitalize="none" autocorrect="off" required=true/]
      [@control.text name="tenant.failedAuthenticationConfiguration.actionDuration" tooltip=function.message("{tooltip}tenant.failedAuthenticationConfiguration.actionDuration") autocapitalize="none" autocorrect="off" required=true/]
      [@control.select items=expiryUnits name="tenant.failedAuthenticationConfiguration.actionDurationUnit"/]
    </div>
  </fieldset>
  <fieldset>
    <legend>[@message.print key="breached-password-detection-settings"/]</legend>
    <div style="display: flex;" class="mb-3">
      <div style="margin-right: 10px;">
        <img src="/images/icon-reactor-gray.svg" alt="FusionAuth Reactor Logo" width="42">
      </div>
      <div style="flex: 1;"><em>[@message.print key="{description}breached-password-detection-settings"/]</em></div>
     </div>
    [@control.checkbox name="tenant.passwordValidationRules.breachDetection.enabled" value="true" uncheckedValue="false"  data_slide_open="tenant_passwordBreach"/]
    <div id="tenant_passwordBreach" class="slide-open [#if tenant.passwordValidationRules.breachDetection.enabled]open[/#if]">
      [@control.select items=breachMatchModes name="tenant.passwordValidationRules.breachDetection.matchMode" wideTooltip=function.message("{tooltip}tenant.passwordValidationRules.breachDetection.matchMode") /]
      [@control.select items=breachActions name="tenant.passwordValidationRules.breachDetection.onLogin" data_slide_open="breach_action_notifyUser" data_slide_open_value="NotifyUser" tooltip=function.message("{tooltip}tenant.passwordValidationRules.breachDetection.onLogin")/]
      <div id="breach_action_notifyUser" class="slide-open [#if (tenant.passwordValidationRules.breachDetection.onLogin == "NotifyUser")!false]open[/#if]">
        [@control.select items=emailTemplates name="tenant.passwordValidationRules.breachDetection.notifyUserEmailTemplateId" valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-required" required=true tooltip=function.message("{tooltip}tenant.passwordValidationRules.breachDetection.notifyUserEmailTemplateId") /]
      </div>
    </div>
  </fieldset>
  <fieldset>
    <legend>[@message.print key="password-settings"/]</legend>
    <p><em>[@message.print key="{description}password-settings"/]</em></p>
    [@control.text name="tenant.passwordValidationRules.minLength" autocapitalize="none" autocorrect="off" required=true/]
    [@control.text name="tenant.passwordValidationRules.maxLength" autocapitalize="none" autocorrect="off" required=true/]
    [@control.checkbox name="tenant.passwordValidationRules.requireMixedCase" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.passwordValidationRules.requireMixedCase')/]
    [@control.checkbox name="tenant.passwordValidationRules.requireNonAlpha" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.passwordValidationRules.requireNonAlpha')/]
    [@control.checkbox name="tenant.passwordValidationRules.requireNumber" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.passwordValidationRules.requireNumber')/]
    [@control.checkbox name="tenant.minimumPasswordAge.enabled" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.minimumPasswordAge.enabled') data_slide_open="tenant_minimumPasswordAge"/]
    <div id="tenant_minimumPasswordAge" class="slide-open [#if tenant.minimumPasswordAge.enabled]open[/#if]">
      [@control.text name="tenant.minimumPasswordAge.seconds" rightAddonText="${function.message('SECONDS')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message("{tooltip}tenant.minimumPasswordAge.seconds")/]
    </div>
    [@control.checkbox name="tenant.maximumPasswordAge.enabled" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.maximumPasswordAge.enabled') data_slide_open="tenant_maximumPasswordAge"/]
    <div id="tenant_maximumPasswordAge" class="slide-open [#if tenant.maximumPasswordAge.enabled]open[/#if]">
      [@control.text name="tenant.maximumPasswordAge.days" rightAddonText="${function.message('DAYS')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message('{tooltip}tenant.maximumPasswordAge.days')/]
    </div>
    [@control.checkbox name="tenant.passwordValidationRules.rememberPreviousPasswords.enabled" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}tenant.passwordValidationRules.rememberPreviousPasswords.enabled') data_slide_open="tenant_passwordValidationRules_previousPasswords"/]
    <div id="tenant_passwordValidationRules_previousPasswords" class="slide-open [#if tenant.passwordValidationRules.rememberPreviousPasswords.enabled]open[/#if]">
      [@control.text name="tenant.passwordValidationRules.rememberPreviousPasswords.count" autocapitalize="none" autocorrect="off" required=true/]
    </div>
    [@control.checkbox name="tenant.passwordValidationRules.validateOnLogin" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}tenant.passwordValidationRules.validateOnLogin")/]
  </fieldset>
  <fieldset>
    <legend>[@message.print key="password-encryption-settings"/]</legend>
    <p><em>[@message.print key="{description}password-encryption-settings"/]</em></p>
    [@control.select items=passwordEncryptors name="tenant.passwordEncryptionConfiguration.encryptionScheme" tooltip=function.message("{tooltip}tenant.passwordEncryptionConfiguration.encryptionScheme")/]
    [@control.text name="tenant.passwordEncryptionConfiguration.encryptionSchemeFactor" autocapitalize="none" autocorrect="off" required=true tooltip=function.message("{tooltip}tenant.passwordEncryptionConfiguration.encryptionSchemeFactor")/]
    [@control.checkbox name="tenant.passwordEncryptionConfiguration.modifyEncryptionSchemeOnLogin" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}tenant.passwordEncryptionConfiguration.modifyEncryptionSchemeOnLogin")/]
  </fieldset>
[/#macro]

[#macro jwtConfiguration]
  <fieldset>
    <legend>[@message.print key="jwt-settings"/]</legend>
    <p><em>[@message.print key="{description}jwt-settings"/]</em></p>
    [@control.text name="tenant.jwtConfiguration.refreshTokenTimeToLiveInMinutes" title="${helpers.approximateFromMinutes(tenant.jwtConfiguration.refreshTokenTimeToLiveInMinutes)}" rightAddonText="${function.message('MINUTES')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message('{tooltip}jwtConfiguration.refreshTokenTimeToLiveInMinutes')/]
    [@control.text name="tenant.jwtConfiguration.timeToLiveInSeconds" title="${helpers.approximateFromSeconds(tenant.jwtConfiguration.timeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message('{tooltip}jwtConfiguration.timeToLiveInSeconds')/]
    [@control.select name="tenant.jwtConfiguration.accessTokenKeyId" items=accessTokenKeys![] required=false valueExpr="id" textExpr="displayName" tooltip=function.message('{tooltip}jwtConfiguration.accessTokenKeyId')/]
    [@control.select name="tenant.jwtConfiguration.idTokenKeyId" items=keys![] required=false valueExpr="id" textExpr="displayName" tooltip=function.message('{tooltip}jwtConfiguration.idTokenKeyId')/]
  </fieldset>
[/#macro]