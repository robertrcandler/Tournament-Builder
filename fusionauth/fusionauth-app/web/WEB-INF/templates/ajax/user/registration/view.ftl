[#ftl/]
[#-- @ftlvariable name="registration" type="io.fusionauth.domain.UserRegistration" --]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="id" object=registration  propertyName="id"/]
    [@properties.rowEval nameKey="application" object=application propertyName="name"/]
    [@properties.rowEval nameKey="username" object=registration propertyName="username"/]
    [#if registration.username?? && (application.cleanSpeakConfiguration.usernameModeration.enabled)!false]
      [@properties.row nameKey="username-status" value=message.inline("username-" + registration.usernameStatus?lower_case)/]
    [/#if]
    [#assign preferredLanguages = fusionAuth.display_locale_names((registration.preferredLanguages)![]) /]
    [@properties.row nameKey="preferredLanguages" value=preferredLanguages?has_content?then(preferredLanguages, "\x2013")/]
    [@properties.rowEval nameKey="timezone" object=registration propertyName="timezone"/]
    [@properties.rowEval nameKey="roles" object=registration propertyName="roles"/]
    [#if application.authenticationTokenConfiguration.enabled]
      [@properties.rowEval nameKey="authenticationToken" object=registration propertyName="authenticationToken"/]
    [/#if]
    [@properties.rowEval nameKey="created" object=registration propertyName="insertInstant"/]
    [@properties.rowEval nameKey="last-login" object=registration propertyName="lastLoginInstant"/]
    [@properties.rowEval nameKey="verified" object=registration propertyName="verified"  booleanAsCheckmark=false/]
  [/@properties.table]

  [#if (registration.data)?? && registration.data?has_content]
  <h3>[@message.print key="data"/]</h3>
  <pre class="code scrollable horizontal mt-3">${fusionAuth.stringify(registration.data)}</pre>
  [/#if]
[/@dialog.view]