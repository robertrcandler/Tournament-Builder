[#ftl/]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="applications" type="java.util.List<io.fusionauth.domain.Application>" --]
[#-- @ftlvariable name="canEditRoles" type="boolean" --]
[#-- @ftlvariable name="registration" type="io.fusionauth.domain.UserRegistration" --]
[#-- @ftlvariable name="userId" type="java.util.UUID" --]
[#-- @ftlvariable name="groupNames" type="java.util.List<java.lang.String>" --]
[#-- @ftlvariable name="groupManagedRoles" type="boolean" --]
[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[#macro formFields action]
  <fieldset>
    <legend>
      [#if action == 'edit']
        [@message.print key="edit-registration" values=[application.name]/]
      [#else]
        [@message.print key="page-title"/]
      [/#if]
    </legend>
    [#if (application.id!'') == fusionAuth.statics['io.fusionauth.domain.Application'].FUSIONAUTH_APP_ID ]
    <p><em>[@message.print key="{description}fusionauth-registration"/]</em></p>
    [/#if]

    [#if groupManagedRoles]
    [@message.alertColumn message=function.message('group.managedRoles.info', properties.join(groupNames)) type="info" icon="info-circle"/]
    [/#if]
  </fieldset>
  <fieldset>
    [@control.hidden name="userId"/]
    [@control.hidden name="tenantId"/]
    [#if action="add" && applications??]
      [@control.select items=applications textExpr="name" valueExpr="id" name="registration.applicationId"/]
    [#else]
      [@control.hidden name="registration.applicationId"/]
    [/#if]
    [@control.text name="registration.username" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" /]
    [@control.locale_select multiple=true name="registration.preferredLanguages" tooltip=function.message('{tooltip}preferredLanguages')/]
    [@control.select items=timezones name="registration.timezone" headerValue="" headerL10n="no-timezone-selected" /]
    <div id="application-roles" class="form-row" data-disabled="${(!canEditRoles)?c}"></div>
  </fieldset>
[/#macro]
