[#ftl/]
[#-- @ftlvariable name="accessTokenKeys" type="java.util.List<io.fusionauth.domain.Key>" --]
[#-- @ftlvariable name="availableGrants" type="java.util.List<io.fusionauth.domain.oauth2.GrantType>" --]
[#-- @ftlvariable name="emailTemplates" type="java.util.List<io.fusionauth.domain.email.EmailTemplate>" --]
[#-- @ftlvariable name="applications" type="java.util.List<io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="applicationId" type="java.util.UUID" --]
[#-- @ftlvariable name="cleanSpeakApplications" type="java.util.List<io.fusionauth.api.service.moderation.cleanspeak.Application>" --]
[#-- @ftlvariable name="idTokenAlgorithms" type="java.util.List<io.fusionauth.domain.Key.KeyAlgorithm>" --]
[#-- @ftlvariable name="logoutBehaviors" type="io.fusionauth.domain.oauth2.LogoutBehavior[]" --]
[#-- @ftlvariable name="keys" type="java.util.List<io.fusionauth.domain.Key>" --]
[#-- @ftlvariable name="samlv2Keys" type="java.util.List<io.fusionauth.domain.Key>" --]
[#-- @ftlvariable name="fusionAuthId" type="java.util.UUID" --]
[#-- @ftlvariable name="integrations" type="io.fusionauth.domain.Integrations" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/panel.ftl" as panel/]

[#macro configurations action]
  <ul class="tabs">
    [#if action == 'add']
      <li><a href="#role-configuration">[@message.print key="roles"/]</a></li>
    [/#if]
    [#if action == 'add' || applicationId != fusionAuthId]
      <li><a href="#oauth-configuration">[@message.print key="oauth"/]</a></li>
    [/#if]
    [#if action == 'add' || applicationId != fusionAuthId]
      <li><a href="#webhooks">[@message.print "webhooks"/]</a></li>
      <li><a href="#cleanspeak-configuration">[@message.print key="clean-speak-integration"/]</a></li>
    [/#if]
    <li><a href="#jwt-settings">[@message.print key="jwt"/]</a></li>
    [#if action == 'add' || applicationId != fusionAuthId]
    <li><a href="#samlv2-settings">[@message.print key="saml"/]</a></li>
    [/#if]
    [#if !applicationId?has_content || applicationId != fusionAuthId]
      <li><a href="#registration-settings">[@message.print key="registration"/]</a></li>
    [/#if]
    [#if action = 'add' || applicationId != fusionAuthId]
      <li><a href="#security-settings">[@message.print key="security"/]</a></li>
    [/#if]
  </ul>
  [#if action == 'add']
    <div id="role-configuration" class="hidden">
      [@roleConfiguration/]
    </div>
  [/#if]
  [#if action == 'add' || applicationId != fusionAuthId]
    <div id="oauth-configuration" class="hidden">
      [@oauthConfiguration/]
    </div>
  [/#if]
  [#if action == 'add' || applicationId != fusionAuthId]
    <div id="cleanspeak-configuration" class="hidden">
      [@cleanSpeakConfiguration/]
    </div>
    <div id="webhooks" class="hidden">
      [@webhooksList/]
    </div>
  [/#if]
  [#if !applicationId?has_content || applicationId != fusionAuthId]
    <div id="registration-settings" class="hidden">
      [@registrationConfiguration/]
    </div>
  [/#if]
  <div id="jwt-settings" class="hidden">
    [@jwtConfiguration action/]
  </div>
  [#if action == 'add' || applicationId != fusionAuthId]
  <div id="samlv2-settings" class="hidden">
    [@samlv2Configuration/]
  </div>
  [/#if]
  <div id="security-settings" class="hidden">
    [@securityConfiguration action/]
  </div>
[/#macro]

[#macro securityConfiguration action]
[#if action == 'add' || applicationId != fusionAuthId]
<fieldset>
  <legend>[@message.print key="login-settings"/]</legend>
  <p><em>[@message.print key="{description}login-settings"/]</em></p>
  [@control.checkbox name="application.loginConfiguration.requireAuthentication" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.loginConfiguration.requireAuthentication")/]
  [@control.checkbox name="application.loginConfiguration.generateRefreshTokens" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.loginConfiguration.generateRefreshTokens")/]
  [@control.checkbox name="application.loginConfiguration.allowTokenRefresh" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.loginConfiguration.allowTokenRefresh")/]
</fieldset>
[/#if]
<fieldset>
  <legend>[@message.print key="passwordless-settings"/]</legend>
  <p><em>[@message.print key="{description}passwordless-settings"/]</em></p>
  [@control.checkbox name="application.passwordlessConfiguration.enabled" value="true" uncheckedValue="false" /]
</fieldset>
[#if action == 'add' || applicationId != fusionAuthId]
<fieldset>
  <legend>[@message.print key="authentication-token-settings"/]</legend>
  <p><em>[@message.print key="{description}authentication-token-settings"/]</em></p>
  [@control.checkbox name="application.authenticationTokenConfiguration.enabled" value="true" uncheckedValue="false" /]
</fieldset>
[/#if]
[/#macro]

[#macro registrationConfiguration]
  <fieldset>
    [#if emailTemplates?has_content]
      [@control.checkbox name="application.verifyRegistration" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.verifyRegistration") data_slide_open="verify-registration-configuration"/]
      <div id="verify-registration-configuration" class="slide-open [#if (application.verifyRegistration)!false]open[/#if]">
        [@control.select name="application.verificationEmailTemplateId" items=emailTemplates selected=application.verificationEmailTemplateId valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-email-template-required" required=true tooltip=function.message('{tooltip}application.verificationEmailTemplateId')/]
        [@control.checkbox name="application.registrationDeletePolicy.unverified.enabled" value="true" uncheckedValue="false" data_slide_open="delete-unverified-settings" tooltip=function.message("{tooltip}application.registrationDeletePolicy.unverified.enabled")/]
        <div id="delete-unverified-settings" class="slide-open [#if application.registrationDeletePolicy.unverified.enabled]open[/#if]">
          [@control.text name="application.registrationDeletePolicy.unverified.numberOfDaysToRetain" rightAddonText="${function.message('DAYS')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message("{tooltip}application.registrationDeletePolicy.unverified.numberOfDaysToRetain")/]
        </div>
      </div>
    [#else]
      [@control.hidden name="application.verifyRegistration" value="false"/]
      [@message.print key="no-email-templates-available-registration-validation"/]
    [/#if]
  </fieldset>
  <fieldset class="mt-5">
    <legend>[@message.print key="registration-settings"/]</legend>
    <p><em>[@message.print key="{description}registration-settings"/]</em></p>
    [@control.checkbox name="application.registrationConfiguration.enabled"  value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.registrationConfiguration.enabled") data_slide_open="registration-configuration"/]
  </fieldset>
  <div id="registration-configuration" class="slide-open [#if (application.registrationConfiguration.enabled)!false]open[/#if]">
    [@control.checkbox name="application.registrationConfiguration.confirmPassword" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.registrationConfiguration.confirmPassword")/]
    [@control.radio_list name="application.registrationConfiguration.loginIdType" items=loginIdTypes tooltip=function.message("{tooltip}application.registrationConfiguration.loginIdType")/]
    <div class="form-row">
      <label>[@message.print key="registration-fields"/]</label>
      <table>
        <thead>
        <tr>
          <th>[@message.print key="field"/]</th>
          <th class="tight" data-select-col="enabled">[@message.print key="enabled"/]</th>
          <th class="tight" data-select-col="required">[@message.print key="required"/]</th>
        </tr>
        </thead>
        <tbody>
        <tr>
          <td data-select-row="true">[@message.print key="application.registrationConfiguration.birthDate"/]</td>
          <td class="tight">[@control.checkbox name="application.registrationConfiguration.birthDate.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          <td class="tight">[@control.checkbox name="application.registrationConfiguration.birthDate.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
        </tr>
        <tr>
          <td data-select-row="true">[@message.print key="application.registrationConfiguration.firstName"/]</td>
          <td class="tight">[@control.checkbox name="application.registrationConfiguration.firstName.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          <td class="tight">[@control.checkbox name="application.registrationConfiguration.firstName.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
        </tr>
        <tr>
          <td data-select-row="true">[@message.print key="application.registrationConfiguration.fullName"/]</td>
          <td class="tight">[@control.checkbox name="application.registrationConfiguration.fullName.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          <td class="tight">[@control.checkbox name="application.registrationConfiguration.fullName.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
        </tr>
        <tr>
          <td data-select-row="true">[@message.print key="application.registrationConfiguration.lastName"/]</td>
          <td class="tight">[@control.checkbox name="application.registrationConfiguration.lastName.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          <td class="tight">[@control.checkbox name="application.registrationConfiguration.lastName.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
        </tr>
        <tr>
          <td data-select-row="true">[@message.print key="application.registrationConfiguration.middleName"/]</td>
          <td class="tight">[@control.checkbox name="application.registrationConfiguration.middleName.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          <td class="tight">[@control.checkbox name="application.registrationConfiguration.middleName.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
        </tr>
        <tr>
          <td data-select-row="true">[@message.print key="application.registrationConfiguration.mobilePhone"/]</td>
          <td class="tight">[@control.checkbox name="application.registrationConfiguration.mobilePhone.enabled" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
          <td class="tight">[@control.checkbox name="application.registrationConfiguration.mobilePhone.required" value="true" uncheckedValue="false" labelKey="empty" includeFormRow=false/]</td>
        </tr>
        </tbody>
      </table>
    </div>
  </div>
[/#macro]

[#macro jwtConfiguration action]
<p class="mt-0">
  <em>[@message.print key="jwt-settings-description"/]</em>
</p>
<fieldset>
  [@control.checkbox name="application.jwtConfiguration.enabled" value="true" uncheckedValue="false" data_slide_open="jwt-settings-body"/]
</fieldset>

<div id="jwt-settings-body" data-jwt-settings-body="true" class="slide-open ${application.jwtConfiguration.enabled?then('open', '')}">
  <fieldset>
  [#if action == "edit"]
    [@helpers.fauxInput type="text" name="application.jwtConfiguration.issuer" labelKey="application.jwtConfiguration.issuer" value="${helpers.tenantById(tenantId).issuer!''}" autocapitalize="none" autocorrect="off" disabled=true tooltip=function.message('{tooltip}jwtConfiguration.issuer')/]
  [/#if]
  [@control.text name="application.jwtConfiguration.refreshTokenTimeToLiveInMinutes" title="${helpers.approximateFromMinutes(application.jwtConfiguration.refreshTokenTimeToLiveInMinutes)}" rightAddonText="${function.message('MINUTES')}" autocapitalize="none" autocorrect="off" required=true tooltip=function.message('{tooltip}jwtConfiguration.refreshTokenTimeToLiveInMinutes')/]
  [@control.text name="application.jwtConfiguration.timeToLiveInSeconds" title="${helpers.approximateFromSeconds(application.jwtConfiguration.timeToLiveInSeconds)}" rightAddonText="${function.message('SECONDS')}" required=true tooltip=function.message("{tooltip}jwtConfiguration.timeToLiveInSeconds")/]
  </fieldset>
  <fieldset>
    [@control.select name="application.jwtConfiguration.accessTokenKeyId" items=accessTokenKeys![] required=false valueExpr="id" textExpr="displayName" headerValue="" headerL10n="generate-signing-key"  tooltip=function.message('{tooltip}jwtConfiguration.accessTokenKeyId')/]
    [@control.select name="application.jwtConfiguration.idTokenKeyId" items=keys![] required=false valueExpr="id" textExpr="displayName" headerValue="" headerL10n="generate-signing-key"  tooltip=function.message('{tooltip}jwtConfiguration.idTokenKeyId')/]
  </fieldset>
</div>

<fieldset>
  <p><em>[@message.print key="{description}custom-claim-configuration"/]</em></p>
  [@control.select name="application.lambdaConfiguration.accessTokenPopulateId" items=jwtLambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled"/]
  [@control.select name="application.lambdaConfiguration.idTokenPopulateId" items=jwtLambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled"/]
</fieldset>
[/#macro]

[#macro samlv2Configuration]
<p class="mt-0 mb-4">
  <em>[@message.print key="samlv2-settings-description"/]</em>
</p>
<fieldset>
  [@control.checkbox name="application.samlv2Configuration.enabled" value="true" uncheckedValue="false" data_slide_open="samlv2-settings-body"/]
</fieldset>

<div id="samlv2-settings-body" class="slide-open ${application.samlv2Configuration.enabled?then('open', '')}">
  <fieldset>
    [@control.text name="application.samlv2Configuration.issuer" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="e.g. google.com" required=true tooltip=function.message('{tooltip}application.samlv2Configuration.issuer')/]
    [@control.text name="application.samlv2Configuration.audience" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder=function.message('{placeholder}application.samlv2Configuration.audience') tooltip=function.message('{tooltip}application.samlv2Configuration.audience')/]
    [@control.text name="application.samlv2Configuration.callbackURL" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="e.g. https://www.example.com/samlv2/callback" required=true tooltip=function.message('{tooltip}application.samlv2Configuration.callbackURL')/]
    [@control.text name="application.samlv2Configuration.logoutURL" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="e.g. https://www.example.com/logout" tooltip=function.message('{tooltip}application.samlv2Configuration.logoutURL')/]
    [@control.select name="application.samlv2Configuration.keyId" items=samlv2Keys![] required=false valueExpr="id" textExpr="name" headerValue="" headerL10n="generate-signing-key"  tooltip=function.message('{tooltip}application.samlv2Configuration.keyId')/]
  </fieldset>
  <fieldset>
    [@control.select name="application.samlv2Configuration.xmlSignatureC14nMethod" items=c14nMethods![] required=false tooltip=function.message('{tooltip}application.samlv2Configuration.xmlSignatureC14nMethod')/]
    [@control.select name="application.lambdaConfiguration.samlv2PopulateId" items=samlv2Lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled"/]
    [@control.checkbox name="application.samlv2Configuration.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}application.samlv2Configuration.debug')/]
  </fieldset>
</div>
[/#macro]

[#macro cleanSpeakConfiguration]
<fieldset>
  [#if integrations.cleanspeak.enabled]
    [#if cleanSpeakApplications?has_content]
      <p class="mt-0">
        <em>[@message.print key="clean-speak-settings.description"/]</em>
      </p>
      [@control.checkbox_list items=cleanSpeakApplications textExpr="name" valueExpr="id" name="application.cleanSpeakConfiguration.applicationIds" tooltip=function.message("clean-speak-mapping-info")/]
      [@control.checkbox name="application.cleanSpeakConfiguration.usernameModeration.enabled" value="true" uncheckedValue="false"/]
      <div id="clean-speak-settings">
        [@control.select name="application.cleanSpeakConfiguration.usernameModeration.applicationId" textExpr="name" valueExpr="id" items=cleanSpeakApplications headerValue="" headerL10n="selection-required"/]
      </div>
    [#else]
      [@message.print key="clean-speak-down-or-has-no-applications"/]
    [/#if]
  [#else]
    <p class="mt-0">
      <em>[@message.print key="clean-speak-not-enabled"/]</em>
    </p>
  [/#if]
</fieldset>
[/#macro]

[#macro webhooksList]
  <fieldset>
    [#if webhooks?? && webhooks?size > 0]
      [@control.checkbox_list name="webhookIds" labelKey="empty" items=webhooks textExpr="url" valueExpr="id"/]
    [#else]
      <p class="mt-0">
        <em>[@message.print key="no-webhooks"/]</em>
      </p>
    [/#if]
  </fieldset>
[/#macro]

[#macro oauthConfiguration]
  <p class="mt-0 mb-4">
    <em>[@message.print key="oauth-settings-description"/]</em>
  </p>
  <fieldset>
    [@control.text name="application.oauthConfiguration.clientId" value="${application.oauthConfiguration.clientId?has_content?then(application.oauthConfiguration.clientId, function.message('{placeholder}application.oauth.clientId'))}" disabled=true/]
    [@control.hidden name="application.oauthConfiguration.clientId"/]
    [@control.text id="client-secret-input" name="application.oauthConfiguration.clientSecret" disabled=true rightAddonButton="<i class=\"fa fa-arrow-circle-right\"></i> <span class=\"text\">${message.inline('regenerate')?markup_string}</span>"?no_esc/]
    [@control.hidden id="client-secret-hidden" name="application.oauthConfiguration.clientSecret"/]
    [@control.checkbox name="application.oauthConfiguration.requireClientAuthentication" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.oauthConfiguration.requireClientAuthentication")/]
    [@control.checkbox name="application.oauthConfiguration.generateRefreshTokens" value="true" uncheckedValue="false" tooltip=function.message("{tooltip}application.oauthConfiguration.generateRefreshTokens")/]
    [@control.select id="redirectURLs" items=application.oauthConfiguration.authorizedRedirectURLs multiple=true name="application.oauthConfiguration.authorizedRedirectURLs" class="select no-wrap" labelKey="oauth.redirectURLs" required=false tooltip=function.message('{tooltip}oauth.redirectURLs')/]
    [@control.select id="origins" items=application.oauthConfiguration.authorizedOriginURLs multiple=true name="application.oauthConfiguration.authorizedOriginURLs" class="select no-wrap" labelKey="oauth.origin" required=false tooltip=function.message('{tooltip}oauth.origin')/]
    [@control.text name="application.oauthConfiguration.logoutURL" autocapitalize="none" autocomplete="on" autocorrect="off" labelKey="oauth.logoutURL" placeholder="e.g. https://www.example.com" tooltip=function.message('{tooltip}oauth.logoutURL')/]
    [@control.select name="application.oauthConfiguration.logoutBehavior" items=logoutBehaviors![] labelKey="oauth.logoutBehavior" tooltip=function.message('{tooltip}oauth.logoutBehavior')/]
    [@control.checkbox_list id="enabled-grants" items=availableGrants name="application.oauthConfiguration.enabledGrants" data_slide_open="device-verification-url" data_slide_open_value="device_code" /]
    <div id="device-verification-url" class="slide-open [#if application.oauthConfiguration.enabledGrants?seq_contains(fusionAuth.statics['io.fusionauth.domain.oauth2.GrantType'].device_code)]open[/#if]">
      [@control.text name="application.oauthConfiguration.deviceVerificationURL" required=true autocapitalize="none" autocomplete="on" autocorrect="off" labelKey="oauth.deviceVerificationURL" placeholder="e.g. https://www.example.com/device" tooltip=function.message('{tooltip}oauth.deviceVerificationURL')/]
    </div>
  </fieldset>
[/#macro]

[#macro roleConfiguration]
  <fieldset>
    <table id="role-table" data-template="role-row-template" data-add-button="role-add-button">
      <thead>
      <tr>
        <th>[@message.print key="name"/]</th>
        <th>[@message.print key="default"/]</th>
        <th>[@message.print key="superRole"/]</th>
        <th>[@message.print key="description"/]</th>
        <th data-sortable="false" class="action">[@message.print key="action"/]</th>
      </tr>
      </thead>
      <tbody>
      <tr class="empty-row">
        <td colspan="5">[@message.print key="no-roles"/]</td>
      </tr>
        [#if application?? && application.roles?size > 0]
          [#list application.roles as role]
          <tr>
            <td><input type="text" class="tight" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="${function.message("name")}" name="application.roles[${role_index}].name" value="${((role.name)!'')}"/></td>
            <td><input type="checkbox" class="tight" name="application.roles[${role_index}].isDefault" value="true" [#if (role.isDefault)!false]checked[/#if]/></td>
            <td><input type="checkbox" class="tight" name="application.roles[${role_index}].isSuperRole" value="true" [#if (role.isSuperRole)!false]checked[/#if]/></td>
            <td><input type="text" class="tight" autocomplete="off" placeholder="${function.message("description")}" name="application.roles[${role_index}].description" value="${((role.description)!'')}"/></td>
            <td class="action">[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
          </tr>
          [/#list]
        [/#if]
      </tbody>
    </table>
    <script type="x-handlebars" id="role-row-template">
      <tr>
        <td><input type="text" autocapitalize="none" autocomplete="off" autocorrect="off" placeholder="${function.message("name")}" name="application.roles[{{index}}].name"/></td>
        <td><label class="checkbox"><input type="checkbox" name="application.roles[{{index}}].isDefault"/><span class="box"></span></label></td>
        <td><label class="checkbox"><input type="checkbox" name="application.roles[{{index}}].isSuperRole"/><span class="box"></span></label></td>
        <td><input type="text" autocomplete="off" placeholder="${function.message("description")}" name="application.roles[{{index}}].description"/></td>
        <td>[@button.action href="#" icon="trash" color="red" key="delete" additionalClass="delete-button"/]</td>
      </tr>
    </script>
    [@button.iconLinkWithText href="#" color="blue" id="role-add-button" icon="plus" textKey="add-role"/]
  </fieldset>
[/#macro]

[#macro applicationsTable deactivated]
<table class="hover">
  <thead>
  <tr>
    <th><a href="#">[@message.print key="name"/]</a></th>
    <th class="hide-on-mobile"><a href="#">[@message.print key="id"/]</a></th>
    [#if tenants?size > 1]
      <th class="hide-on-mobile"><a href="#">[@message.print key="tenant"/]</a></th>
    [/#if]
    <th data-sortable="false" class="action">[@message.print key="action"/]</th>
  </tr>
  </thead>
  <tbody>
    [#list applications![] as application]
    <tr>
      <td>${application.name}</td>
      <td class="hide-on-mobile">${properties.display(application, "id")}</td>
      [#if tenants?size > 1]
        <td class="hide-on-mobile"> ${helpers.tenantName(application.tenantId)}</td>
      [/#if]
      <td class="action">
        [#if deactivated]
          [@button.action href="/ajax/application/reactivate/${application.id}" icon="plus-circle" key="reactivate" color="green" ajaxForm=true/]
          [@button.action href="../delete/${application.id}?tenantId=${application.tenantId}" icon="remove" key="delete" color="red"/]
        [#else]
          [#if application.id != fusionAuthId]
            [@button.action href="edit?applicationId=${application.id}&tenantId=${application.tenantId}" icon="edit" key="edit" color="blue"/]
            [@button.action href="manage-roles?applicationId=${application.id}" icon="user" key="manage-roles" color="purple"/]
            [@button.action href="/ajax/application/view/${application.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true resizeDialog=true/]
            [@button.action href="/ajax/application/deactivate/${application.id}" icon="minus-circle" key="deactivate" color="gray" ajaxForm=true/]
            [@button.action href="delete/${application.id}?tenantId=${application.tenantId}" icon="trash" key="delete" color="red"/]
          [#else]
            [@button.action href="edit?applicationId=${application.id}&tenantId=${application.tenantId}" icon="edit" key="edit" color="blue"/]
            [@button.action href="/ajax/application/view/${application.id}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true resizeDialog=true/]
          [/#if]
        [/#if]
      </td>
    </tr>
    [#else]
    <tr>
      <td colspan="3">[@message.print key="no-applications"/]</td>
    </tr>
    [/#list]
  </tbody>
</table>
[/#macro]