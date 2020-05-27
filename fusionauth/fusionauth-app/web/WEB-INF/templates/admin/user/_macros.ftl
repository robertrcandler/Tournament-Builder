[#ftl/]
[#-- @ftlvariable name="actionsAvailable" type="boolean" --]
[#-- @ftlvariable name="applications" type="java.util.Map<UUID, io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="consentsAvailable" type="boolean" --]
[#-- @ftlvariable name="deliveryTypes" type="java.util.List<io.fusionauth.domain.TwoFactorDelivery>" --]
[#-- @ftlvariable name="edit2FASecretOptions" type="io.fusionauth.app.action.admin.user.BaseFormAction.EditTwoFactorSecretOption" --]
[#-- @ftlvariable name="editPasswordOption" type="io.fusionauth.app.action.admin.user.BaseFormAction.EditPasswordOption" --]
[#-- @ftlvariable name="families" type="java.util.List<io.fusionauth.domain.Family>" --]
[#-- @ftlvariable name="groups" type="java.util.List<io.fusionauth.domain.Group>" --]
[#-- @ftlvariable name="membershipsAvailable" type="boolean" --]
[#-- @ftlvariable name="refreshTokens" type="java.util.List<io.fusionauth.domain.jwt.RefreshToken>" --]
[#-- @ftlvariable name="registrationsAvailable" type="boolean" --]
[#-- @ftlvariable name="sendSetPasswordEmail" type="boolean" --]
[#-- @ftlvariable name="systemConfiguration" type="io.fusionauth.domain.SystemConfiguration" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]
[#-- @ftlvariable name="timezones" type="java.util.SortedSet<java.lang.String>" --]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="userConsents" type="java.util.List<io.fusionauth.domain.UserConsent>" --]
[#-- @ftlvariable name="users" type="java.util.Map<java.util.UUID, io.fusionauth.domain.User>" --]
[#-- @ftlvariable name="userId" type="java.util.UUID" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/passwords.ftl" as passwords/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro passwordFields isOpen tenants]
[#-- See recommended autocomplete values:  https://www.chromium.org/developers/design-documents/form-styles-that-chromium-understands --]
  [#nested]
  <div id="password-fields" class="slide-open [#if isOpen]open[/#if]">
    [@helpers.custonFormRow labelKey="empty"]
      [#list tenants as tenant]
          [@passwords.rules tenant.passwordValidationRules tenant.id tenants?size == 1/]
      [/#list]
    [/@helpers.custonFormRow]

    [#-- Setting autocomplete to "new-password" because we never want these fields auto-completed by the browser or password manager--]
    [@control.password name="user.password" required=true autocomplete="new-password"/]
    [@control.password name="confirm" required=true autocomplete="new-password"/]
  </div>
[/#macro]

[#macro data]
  [#if user.hasUserData()]
    <div class="controls float-right">
      <label for="user-data-view-source" class="inline-block">[@message.print key="view-source"/]</label>
      <label class="toggle inline-block">
        <input type="checkbox" id="user-data-view-source"><span class="rail"></span><span class="pin"></span>
      </label>
    </div>

    [#--User Data--]
    [#if user.data??]
    <fieldset>
      <legend>[@message.print key="user-data"/]</legend>
      <pre class="code scrollable horizontal hidden mt-0">${fusionAuth.stringify(user.data)}</pre>
      <div class="formatted mt-0">
        [@fusionAuth.flatten_data data=user.data; name, value]
          [@properties.definitionList key=name value=value horizontal=true translateKey=false/]
        [/@fusionAuth.flatten_data]
      </div>
    </fieldset>
    [/#if]

    [#--Registration Custom Data--]
    [#list user.registrations as registration]
      [#if registration.data??]
      <fieldset>
        <legend>${applications(registration.applicationId).name}</legend>
        <pre class="code scrollable horizontal hidden mt-0">${fusionAuth.stringify(registration.data)}</pre>
        <div>
          <div class="formatted mt-0">
            [@fusionAuth.flatten_data data=registration.data; name, value]
              [@properties.definitionList key=name value=value horizontal=true translateKey=false/]
            [/@fusionAuth.flatten_data]
          </div>
        </div>
      </fieldset>
      [/#if]
    [/#list]

  [#else]
    [@message.print key="no-user-data"/]
  [/#if]
[/#macro]

[#macro userFormFields action]
<fieldset>
    [#if action == "edit"]
      [@control.hidden name="userId"/]
    [/#if]

    [@control.text name="user.email" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" /]
    [@control.text name="user.username" autocapitalize="none" autocomplete="off" autocorrect="off" /]
    [@control.text name="user.mobilePhone" autocapitalize="none" autocomplete="off" autocorrect="off"/]

    [#-- Tenant --]
    [#if action == "edit"]
      [@control.hidden name="tenantId" value=user.tenantId/]
      [#if tenants?size > 1]
        [#-- Use an empty name so we don't end up with duplicate Ids in the DOM --]
        [@control.text name="" labelKey="tenant" value=helpers.tenantName(user.tenantId) autocapitalize="none" autocomplete="off" autocorrect="off" disabled=true tooltip=function.message('{tooltip}readOnly')/]
      [/#if]
    [#else]
      [#if tenants?size == 1]
        [@control.hidden name="tenantId" value=tenants?keys?first/]
      [#else]
        [@control.select name="tenantId" labelKey="tenant" items=tenants textExpr="name" valueExpr="id" required=true headerL10n="selection-required" headerValue="" tooltip=function.message('{tooltip}tenant')/]
      [/#if]
    [/#if]
  </fieldset>

  [#-- Always show thie password stuff, we'll validate it based upon the tenant selected during an add --]
  [#local isOpen = (action == "add" && !sendSetPasswordEmail) || (action == "edit" && editPasswordOption == "update")/]
  <fieldset>
    [@passwordFields isOpen tenants?values]
      [#if action == "add"]
        [@control.checkbox name="sendSetPasswordEmail" value="true" uncheckedValue="false" data_slide_open="password-fields" data_slide_open_inverted=true/]
      [#elseif action == "edit"]
        [#if ftlCurrentUser.id == userId]
          [#-- Editing yourself --]
          [@control.checkbox name="editPasswordOption" value="update" uncheckedValue="useExisting" data_slide_open="password-fields"/]
        [#else]
          [#-- Editing another user --]
          [@control.select items=editPasswordOptions name="editPasswordOption"/]
        [/#if]
      [/#if]
    [/@passwordFields]
  </fieldset>

  [#-- Only an admin can modify 2FA settings, show controls if editing another user, not yourself --]
  [#if fusionAuth.has_one_role("admin") && (action == "add" || ftlCurrentUser.id != userId)]
    <fieldset class="mb-0">
      <legend>[@message.print key="two-factor-configuration"/]</legend>
        [@control.checkbox name="user.twoFactorEnabled" value="true" uncheckedValue="false" data_slide_open="two-factor-fields"/]
    </fieldset>
    <div id="two-factor-fields" class="slide-open [#if user.twoFactorEnabled]open[/#if]">
      [#if deliveryTypes?size > 1]
        [@control.select name="user.twoFactorDelivery" items=deliveryTypes/]
      [#else]
          [@control.hidden name="user.twoFactorDelivery"/]
      [/#if]

      <fieldset>
        [#if action == "edit" ]
            [#if editTwoFactorSecretOptions?size == 1]
              [@control.hidden name="editTwoFactorSecretOption"/]
            [#else]
              [@control.select items=editTwoFactorSecretOptions name="editTwoFactorSecretOption"/]
            [/#if]
          <div id="two-factor-secret-fields" class="slide-open [#if editTwoFactorSecretOption == "updateSecret"]open[/#if]">
            [@sharedTwoFactorFields/]
          </div>
        [#else]
          [@control.hidden name="editTwoFactorSecretOption"/]
          [@sharedTwoFactorFields/]
        [/#if]
      </fieldset>
    </div>
  [/#if]

  <fieldset>
    <legend>[@message.print key="options"/]</legend>
    [#-- If you're editing your self provide a description of how the language and timezone can be used in the FusionAuth UI --]
    [#if action == "edit" && ftlCurrentUser.id == userId]
    <p><em>[@message.print key="{description}fusionauth-user"/]</em></p>
    [/#if]
    [#-- To allow some additional flexibility for user entering values, support a few different formats, the first definition will be used for the initial format --]
    [@control.text name="user.birthDate" autocapitalize="none" autocomplete="off" autocorrect="off" class="birthdate-picker" _dateTimeFormat="[M/d/yyyy][MM/dd/yyyy][M/dd/yyyy][MM/d/yyyy]" data_date_only=true/]
    [@control.text name="user.firstName" autocapitalize="on" autocomplete="off" autocorrect="off"/]
    [@control.text name="user.middleName" autocapitalize="on" autocomplete="off" autocorrect="off"/]
    [@control.text name="user.lastName" autocapitalize="on" autocomplete="off" autocorrect="off"/]
    [@control.text name="user.fullName" autocapitalize="on" autocomplete="off" autocorrect="off" /]
    [@control.locale_select multiple=true name="user.preferredLanguages" tooltip=function.message('{tooltip}preferredLanguages')/]
    [@control.select items=timezones name="user.timezone" headerValue="" headerL10n="no-timezone-selected"/]
    [@control.text name="user.imageUrl" autocapitalize="none" autocomplete="off" autocorrect="off"/]
  </fieldset>

[/#macro]

[#macro sharedTwoFactorFields]
[@control.radio_list items=["Base32", "Base64"] name="secretEncoding"/]
[@control.text id="two-factor-secret-input" name="user.twoFactorSecret" autocapitalize="none" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=function.message("{tooltip}user.twoFactorSecret") rightAddonButton="<i class=\"fa fa-arrow-circle-right\"></i> <span class=\"text\">${message.inline('generate-secret')?markup_string}</span>"?no_esc/]
[@button.iconLinkWithText id="show-qr-code" href="/ajax/user/two-factor/qrcode" class="float-right" icon="qrcode" color="gray" textKey="show-qrcode" /]
[/#macro]

[#macro details]
<div class="row push-bottom user-details">
  <div class="col-xs-12 col-md-5 col-lg-3 tight-left tight-right">
    <div class="avatar">
      <div>[@helpers.avatar user/]</div>
      <div>
        [#if user.name??]
          ${user.name}
        [#elseif user.username??]
          ${user.username}
        [/#if]
      </div>
    </div>
  </div>
  <div class="col-xs-12 col-md-7 col-lg-9 tight-left">

    <div class="row">
      <div class="col-xs-12 col-md-12">
        [#local verified = user.verified/]
        [#-- If user has no email hide the verification icon --]
        [#if user.lookupEmail()??]
          [@properties.definitionList key="email" value="${user.lookupEmail()!''}" horizontal=true iconToolTipKey="email-verified-${verified?string}" icon="${verified?then('check', 'question-circle-o')}" iconColor="${verified?then('green', 'orange')}"/]
        [#else]
          [@properties.definitionList key="email" value="" horizontal=true/]
        [/#if]
        [@properties.definitionList key="user-id" value="${user.id}" horizontal=true /]
        [#if tenants?size > 1]
          [@properties.definitionList key="tenant" value="${helpers.tenantName(user.tenantId)}" horizontal=true /]
        [/#if]
      </div>
    </div>

    <div class="row">

      <div class="col-xs-12 col-md-4">
        [@properties.definitionList key="mobilePhone" value="${properties.phoneNumber(properties.display(user, 'mobilePhone'))}" /]
      </div>

      <div class="col-xs-12 col-md-4">
        [#if user.birthDate??]
          [@properties.definitionList key="birth-date" value="${function.format_local_date(user.birthDate, function.message('date-format'))} (${user.age})"/]
        [#else]
          [@properties.definitionList key="birth-date" value=""/]
        [/#if]
      </div>

      <div class="col-xs-12 col-md-4">
        [@properties.definitionList key="username" value="${properties.display(user, 'username')}" /]
      </div>

      <div class="col-xs-12 col-md-4">
        [@properties.definitionList key="preferred-languages" value="${fusionAuth.display_locale_names((user.preferredLanguages)![])}" /]
      </div>

      <div class="col-xs-12 col-md-4">
        [@properties.definitionList key="created" value="${function.format_zoned_date_time(user.insertInstant, function.message('date-time-format'), zoneId)}" /]
      </div>

      <div class="col-xs-12 col-md-4">
        [@properties.definitionList key="last-login" value="${(user.lastLoginInstant??)?then(function.format_zoned_date_time(user.lastLoginInstant, function.message('date-time-format'), zoneId), '')}" /]
      </div>

      [#if user.breachedPasswordStatus?? && user.breachedPasswordStatus != "None"]
        <div class="col-xs-12 col-md-4">
          [@properties.definitionList key="breach-detected" value=properties.display(user, "breachedPasswordLastCheckedInstant") /]
        </div>
      [/#if]

    </div>
  </div>
  <div class="panel-actions">
    <div class="status">
      [#if user.active]
        [#if user.id != ftlCurrentUser.id]
          [@button.ajaxLink href="/ajax/user/deactivate/${user.id}" color="green" icon="unlock-alt" tooltipKey="account-unlocked" additionalClass="icon" ajaxForm=true/]
        [#else]
          <a class="icon green" data-tooltip="${function.message('account-unlocked-current-user')}"><i class="fa fa-unlock-alt"></i></a>
        [/#if]
      [#else]
        [@button.ajaxLink href="/ajax/user/reactivate/${user.id}" color="red" icon="lock" tooltipKey="account-locked" additionalClass="icon" ajaxForm=true/]
      [/#if]
    </div>
  </div>
</div>
[/#macro]

[#macro currentActionsTable]
<table class="hover">
  <thead class="light-header">
  <tr>
    <th>[@message.print key="action"/]</th>
    <th class="hide-on-mobile">[@message.print key="comment"/]</th>
    <th class="instant">[@message.print key="start"/]</th>
    <th class="instant">[@message.print key="expiration"/]</th>
    <th class="hide-on-mobile">[@message.print key="actioning-user"/]</th>
    <th data-sortable="false" class="action">[@message.print key="action"/]</th>
  </thead>
  <tbody>
    [#if actions?? && actions?size > 0]
      [#assign active_count = 0/]
      [#list actions as action]
        [#if action.active]
          [#assign active_count = active_count + 1]
        <tr>
          <td>
            ${properties.display(action, 'name')}
            [#if action.localizedReason??]
              [${properties.display(action, 'localizedReason')}]
            [#elseif action.reason??]
              [${properties.display(action, 'reason')}]
            [/#if]
          </td>
          <td class="hide-on-mobile">${properties.display(action, 'comment')}</td>
          <td class="instant">${function.format_zoned_date_time(action.createInstant, function.message('date-time-format'), zoneId)}</td>
          <td class="instant">
            [#if action.expiry??]
              [#if function.format_zoned_date_time(action.expiry, function.message('date-time-format'), zoneId)?contains('+292278994')]
                [@message.print key="indefinite"/]
              [#else]
              ${function.format_zoned_date_time(action.expiry, function.message('date-time-format'), zoneId)}
              [/#if]
            [#else]
              &ndash;
            [/#if]
          </td>
          <td class="hide-on-mobile">
            [#if users(action.actionerUserId)??]
              ${users(action.actionerUserId).email}
            [#else]
              [#-- An action without an actioner was initiated by FusionAuth --]
              ${action.actionerUserId!"\x2013"}
            [/#if]
          </td>
          <td class="action">
            [@button.action href="/ajax/user/modify-action/${action.id}" icon="edit" key="modify-action" ajaxForm=true ajaxWideDialog=true/]
            [@button.action href="/ajax/user/cancel-action/${action.id}" color="red" icon="times" key="cancel-action" ajaxForm=true /]
          </td>
        [/#if]
      </tr>
      [/#list]
      [#if active_count < 1]
      <tr>
        <td colspan="6">[@message.print key="no-current-actions"/]</td>
      </tr>
      [/#if]
    [#else]
    <tr>
      <td colspan="6">[@message.print key="no-current-actions"/]</td>
    </tr>
    [/#if]
  </tbody>
</table>
[/#macro]

[#macro historyTable]
<table class="hover">
  <thead class="light-header">
  <tr>
    <th>[@message.print key="action"/]</th>
    <th class="hide-on-mobile">[@message.print key="comment"/]</th>
    <th class="instant">[@message.print key="start"/]</th>
    <th class="instant">[@message.print key="expiration"/]</th>
    <th class="hide-on-mobile">[@message.print key="actioning-user"/]</th>
  </tr>
  </thead>
  <tbody>
    [#if actions?? && actions?size > 0]
    [#--Don't show current actions on this table--]
      [#list actions as action]
        [#if !action.active]
        <tr>
          <td>
            [#if action.name??]
              ${properties.display(action, 'name')}
              [#if action.localizedReason??]
                [${properties.display(action, 'localizedReason')}]
              [#elseif action.reason??]
                [${properties.display(action, 'reason')}]
              [/#if]
            [#else]
              [@message.print key="comment"/]
            [/#if]
          </td>
          <td class="hide-on-mobile">${properties.display(action, 'comment')}</td>
          <td class="instant">${function.format_zoned_date_time(action.createInstant, function.message('date-time-format'), zoneId)}</td>
          <td class="instant">
            [#if action.expiry??]
              [#if function.format_zoned_date_time(action.expiry, function.message('date-time-format'), zoneId)?contains('+292278994')]
                [@message.print key="indefinite"/]
              [#else]
              ${function.format_zoned_date_time(action.expiry, function.message('date-time-format'), zoneId)}
              [/#if]
            [#else]
              &ndash;
            [/#if]
          </td>
          <td class="hide-on-mobile">
            [#if users(action.actionerUserId)??]
              ${users(action.actionerUserId).email}
            [#else]
              [#-- An action without an actioner was initiated by FusionAuth --]
              ${action.actionerUserId!"\x2013"}
            [/#if]
          </td>
        </tr>
        [/#if]
      [/#list]
    [#else]
    <tr>
      <td colspan="5">[@message.print key="no-history"/]</td>
    </tr>
    [/#if]
  </tbody>
</table>
[/#macro]

[#macro registrationsTable]
<table class="hover">
  <thead class="light-header">
  <tr>
    <th>[@message.print key="application"/]</th>
    <th class="hide-on-mobile">[@message.print key="username"/]</th>
    <th>[@message.print key="roles"/]</th>
    <th class="hide-on-mobile">[@message.print key="created"/]</th>
    <th class="hide-on-mobile">[@message.print key="last-login"/]</th>
    <th data-sortable="false" class="action">[@message.print key="action"/]</th>
  </thead>
  <tbody>
    [#if user.registrations?? && user.registrations?size gt 0]
      [#list user.registrations as registration]
        [#assign application = applications(registration.applicationId)/]
        <tr>
          <td>
            ${properties.display(application, "name")}
            [#if !application.active]<span class="small blue stamp"><i class="fa fa-moon-o"></i> [@message.print key="inactive"/]</span>[/#if]
          </td>
          <td class="hide-on-mobile">${properties.display(registration, "username")}</td>
          <td>${properties.display(registration, "roles")}</td>
          <td class="hide-on-mobile">${properties.display(registration, "insertInstant")}</td>
          <td class="hide-on-mobile">${properties.display(registration, "lastLoginInstant")}</td>
          <td class="action">
            [#if application.active]
              [#--You cannot currently edit a user registration for an inactive application. Seems like we could change this - but until we do - don't allow edit.--]
              [@button.action href="/admin/user/registration/edit/${user.id}/${registration.applicationId}?tenantId=${user.tenantId}" icon="edit" key="edit-registration" color="blue"/]
            [/#if]
            [@button.action href="/ajax/user/registration/view/${user.id}/${registration.applicationId}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true/]
            [#if ftlCurrentUser.id != user.id || registration.applicationId != fusionAuthId]
            [@button.action href="/ajax/user/registration/delete/${user.id}/${registration.applicationId}" icon="trash" key="delete-registration" color="red" ajaxForm=true/]
            [#if application.verifyRegistration && !registration.verified && user.email??]
            [@button.action href="/ajax/user/registration/resend-verification/${user.id}/${registration.applicationId}?tenantId=${user.tenantId}" icon="envelope" key="resend-verification" color="orange" ajaxForm=true/]
            [/#if]
          [/#if]
          </td>
        </tr>
      [/#list]
    [#else]
    <tr>
      <td colspan="5">[@message.print key="no-registrations"/]</td>
    </tr>
    [/#if]
  </tbody>
</table>
  [#if registrationsAvailable]
    [#-- Add the tenantId so that we can easily retrieve the correct applications for this User's tenant --]
    [@button.iconLinkWithText href="/admin/user/registration/add/${user.id}?tenantId=${user.tenantId}" icon="plus" color="blue" textKey="add-registration"/]
  [#else]
    <p><em>[@message.print key="no-registrations-available"/]</em></p>
  [/#if]
[/#macro]

[#macro membershipsTable]
<table class="hover">
  <thead class="light-header">
  <tr>
    <th>[@message.print key="group"/]</th>
    <th class="hide-on-mobile">[@message.print key="member-id"/]</th>
    <th class="hide-on-mobile">[@message.print key="created"/]</th>
    <th data-sortable="false" class="action">[@message.print key="action"/]</th>
  </thead>
  <tbody>
    [#if user.memberships?? && user.memberships?size gt 0]
      [#list user.memberships as membership]
      <tr>
        [#--noinspection FtlReferencesInspection--]
        <td>${properties.display(groups(membership.groupId), "name")}</td>
        <td class="hide-on-mobile">${properties.display(membership, "id")}</td>
        <td class="hide-on-mobile">${properties.display(membership, "insertInstant")}</td>
        <td class="action">
          [@button.action href="/ajax/group/member/view?userId=${user.id}&groupId=${membership.groupId}" icon="search" key="view" color="green" ajaxView=true ajaxWideDialog=true/]
          [@button.action href="/ajax/group/member/remove?userId=${user.id}&groupId=${membership.groupId}" icon="trash" key="remove-membership" color="red" ajaxForm=true ajaxWideDialog=true/]
        </td>
      </tr>
      [/#list]
    [#else]
    <tr>
      <td colspan="4">[@message.print key="no-groups"/]</td>
    </tr>
    [/#if]
  </tbody>
</table>
  [#if groups?has_content]
    [#if membershipsAvailable]
      [@button.iconLinkWithText href="/ajax/group/member/add?userId=${user.id}&tenantId=${user.tenantId}" icon="plus" color="blue" textKey="add-membership" ajaxForm=true ajaxWideDialog=true/]
    [#else]
    <p><em>[@message.print key="no-memberships-available"/]</em></p>
    [/#if]
  [/#if]
[/#macro]

[#macro session]
<table>
  <thead class="light-header">
  <tr>
    <th>[@message.print key="name"/]</th>
    <th class="hide-on-mobile">[@message.print key="type"/]</th>
    <th>[@message.print key="ip-address"/]</th>
    <th>[@message.print key="application"/]</th>
    <th class="hide-on-mobile">[@message.print key="created"/]</th>
    <th class="hide-on-mobile">[@message.print key="last-access-instant"/]</th>
    <th>[@message.print key="expiration"/]</th>
    <th data-sortable="false" class="action">[@message.print key="action"/]</th>
  </thead>
  <tbody>
    [#if refreshTokens?has_content]
      [#list refreshTokens![] as refreshToken]
      <tr>
        <td>${properties.display(refreshToken.metaData.device, "name")}</td>
        <td class="hide-on-mobile">${function.message('device-type-' + refreshToken.metaData.device.type)}</td>
        <td>${properties.display(refreshToken.metaData.device, "lastAccessedAddress")}</td>
        <td>${properties.display(refreshToken.application, "name")}</td>
        <td class="hide-on-mobile">${properties.display(refreshToken, "startInstant")}</td>
        <td class="hide-on-mobile">${properties.display(refreshToken.metaData.device, "lastAccessedInstant")}</td>
        <td>
          [#-- The Refresh Token TTL can be set in the application as well --]

          [#-- TODO : Test : this change, create some refresh tokens some with TTLs defined in Tenant and others TTL defined in application --]

          [#local refreshTokenTimeToLiveInMinutes = tenants(user.tenantId).lookupJWTConfiguration(refreshToken.application).refreshTokenTimeToLiveInMinutes /]
          ${properties.expiration(refreshToken.startInstant, refreshTokenTimeToLiveInMinutes)}
        </td>
        <td class="action">
          [@button.action href="/ajax/user/refresh-token/delete?token=${refreshToken.token?url}&tenantId=${user.tenantId}" icon="trash" key="delete-session" color="red" ajaxForm=true/]
        </td>
      </tr>
      [/#list]
    [#else]
    <td colspan="99">[@message.print key="no-refresh-tokens"/]</td>
    [/#if]
  </tbody>
</table>
[/#macro]

[#macro familiesTable]
<table class="hover">
  <thead class="light-header">
  <tr>
    <th>[@message.print key="name"/]</th>
    <th>[@message.print key="role"/]</th>
    <th>[@message.print key="age"/]</th>
    <th>[@message.print key="family"/]</th>
    <th>[@message.print key="added-on"/]</th>
    <th class="action">[@message.print key="action"/]</th>
  </thead>
  <tbody>
    [#if families?size > 0]
      [#list families![] as family]
        [#list family.members as member]
          [#assign memberUser = users(member.userId)/]
          <tr>
            <td class="icon"><a href="${memberUser.id}?tenantId=${memberUser.tenantId}">[@helpers.avatar memberUser/] ${properties.display(memberUser, 'name')}</a></td>
            <td>${properties.display(member, 'role')}</td>
            <td>${properties.display(memberUser, 'age')}</td>
            <td>${properties.display(family, 'id')}</td>
            <td>${properties.display(member, 'insertInstant')}</td>
            <td class="action">[@button.action href="${memberUser.id}?tenantId=${memberUser.tenantId}" icon="address-card-o" key="manage" color="purple"/]</td>
          </tr>
        [/#list]
      [/#list]
    [#else]
      <tr>
        <td colspan="99">[@message.print key="no-families"/]</td>
      </tr>
    [/#if]
  </tbody>
</table>
[/#macro]

[#macro consentTable]
  <table>
    <thead class="light-header">
    <tr>
      <th>[@message.print key="name"/]</th>
      <th>[@message.print key="values"/]</th>
      <th>[@message.print key="status"/]</th>
      <th>[@message.print key="given-on"/]</th>
      <th>[@message.print key="given-by"/]</th>
      <th class="action">[@message.print key="action"/]</th>
    </thead>
    <tbody>
    [#list userConsents![] as userConsent]
      <tr>
        <td>${properties.display(userConsent, 'consent.name')}</td>
        <td>${properties.display(userConsent, 'values')}</td>
        <td>${properties.display(userConsent, 'status')}</td>
        <td>${properties.display(userConsent, 'insertInstant')}</td>
        <td>
          [#if userConsent.userId == userConsent.giverUserId]
            [@message.print key='self'/]
          [#else]
            [#assign giver = users(userConsent.giverUserId)/]
            <a href="${giver.id}?tenantId=${giver.tenantId}">${properties.display(giver, 'name')}</a>
          [/#if]
        </td>
        <td class="action">
          [#if userConsent.status == 'Active']
            [#if userConsent.consent.values?has_content]
              [#-- You only edit a consent that has values since that is the only thing you can change --]
              [@button.action href="/ajax/user/consent/edit/${userConsent.id}" icon="edit" key="edit-consent" color="blue" ajaxView=false ajaxForm=true/]
            [/#if]
            [@button.action href="/ajax/user/consent/revoke/${userConsent.id}" icon="minus-circle" key="revoke" color="red" ajaxView=false ajaxForm=true/]
          [#else]
            [@button.action href="/ajax/user/consent/unrevoke/${userConsent.id}" icon="undo" key="unrevoke" color="green" ajaxView=false ajaxForm=true/]
          [/#if]
        </td>
      </tr>
    [#else]
      <tr>
        <td colspan="99">[@message.print key="no-consents"/]</td>
      </tr>
    [/#list]
    </tbody>
  </table>
  [#if consentsAvailable]
    [@button.iconLinkWithText href="/ajax/user/consent/add?userId=${user.id}&tenantId=${user.tenantId}" icon="plus" color="blue" textKey="add-consent" ajaxForm=true /]
  [#else]
    <p><em>[@message.print key="no-consents-available"/]</em></p>
  [/#if]
[/#macro]
