[#ftl/]
[#-- @ftlvariable name="theme" type="io.fusionauth.domain.Theme" --]
[#setting url_escaping_charset="UTF-8"]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/message.ftl" as message/]

[#macro tabLink name]
[#local value=("((theme.templates." + name + ")!'')")?eval/]
[#local icon = (value?has_content)?then("fa-info-circle", "fa-exclamation-triangle") ]
<a href="#${name}" [#if !value?has_content]class="requires-upgrade"[/#if]>
[@message.print key="theme.templates.${name}"/]
<label> <i class="fa ${icon}" data-tooltip="${function.message('{tooltip}theme.templates.${name}')}"></i></label>
</a>
[/#macro]

[#macro template name isFusionAuthTheme]
<div id="${name}" class="vertical-tab hidden">
  [#local value=("((theme.templates." + name + ")!'')")?eval/]
  [#if !value?has_content]
    <div class="mr-0 w-100 text-right pb-2">
      [@button.iconLinkWithText color="blue" icon="copy" href="/ajax/theme/copy-default-template?templateName=${name?url}" textKey="copy-in-default" tooltipKey="{tooltip}copy-in-default" data_copy_to="theme.templates.${name}"/]
    </div>
  [/#if]
  [@control.textarea name="theme.templates.${name}" autocapitalize="none" autocorrect="off" required=false labelKey="empty" disabled=isFusionAuthTheme/]
</div>
[/#macro]

[#macro formFields action]
  <fieldset>
    [#if action=="add"]
      [@control.text name="themeId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}themeId')/]
    [#else]
      [@control.text name="themeId" disabled=true tooltip=function.message('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="theme.name" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus" required=true tooltip=function.message('{tooltip}theme.name')/]
  </fieldset>
  <fieldset class="mt-4">
  [#local isFusionAuthTheme = (theme.id?has_content && theme.id == fusionAuth.statics['io.fusionauth.domain.Theme'].FUSIONAUTH_THEME_ID) /]
    <div id="theme-settings">
      <fieldset>
        <legend>[@message.print key="templates"/]</legend>
        [#if isFusionAuthTheme]
        [@message.alertColumn message=message.inline('{description}fusionAuthTheme') type="warning" icon="exclamation-triangle" includeDismissButton=false columnClass="tight-left col-xs"/]
        [/#if]
        <p><em>[@message.print key="templates-description"/]</em></p>
        [#if theme.missingTemplate()]
          [@message.alertColumn message=message.inline('{description}requiresUpgrade') type="warning" icon="exclamation-triangle" includeDismissButton=false columnClass="tight-left col-xs"/]
        [/#if]
        <div>
          <div class="row">
            <div class="col-xs-6 col-md-4 col-lg-3">
              <ul id="ui-tabs" class="vertical-tabs">
                <li><a href="#stylesheet">[@message.print key="theme.stylesheet"/] <label><i class="fa fa-info-circle" data-tooltip="${function.message('{tooltip}theme.stylesheet')}"></i></label></a></li>
                <li><a href="#messages">[@message.print key="theme.messages"/]<label><i class="fa fa-info-circle" data-tooltip="${function.message('{tooltip}theme.messages')}"></i></label></a></li>
                <li>[@tabLink "helpers"/]</li>
                <li>[@tabLink "emailComplete"/]</li>
                <li>[@tabLink "emailSend"/]</li>
                <li>[@tabLink "emailVerify"/]</li>
                <li>[@tabLink "oauth2Authorize"/]</li>
                <li>[@tabLink "oauth2ChildRegistrationNotAllowed"/]</li>
                <li>[@tabLink "oauth2ChildRegistrationNotAllowedComplete"/]</li>
                <li>[@tabLink "oauth2CompleteRegistration"/]</li>
                <li>[@tabLink "oauth2Device"/]</li>
                <li>[@tabLink "oauth2DeviceComplete"/]</li>
                <li>[@tabLink "oauth2Error"/]</li>
                <li>[@tabLink "oauth2Logout"/]</li>
                <li>[@tabLink "oauth2Passwordless"/]</li>
                <li>[@tabLink "oauth2Register"/]</li>
                <li>[@tabLink "oauth2TwoFactor"/]</li>
                <li>[@tabLink "oauth2Wait"/]</li>
                <li>[@tabLink "passwordChange"/]</li>
                <li>[@tabLink "passwordComplete"/]</li>
                <li>[@tabLink "passwordForgot"/]</li>
                <li>[@tabLink "passwordSent"/]</li>
                <li>[@tabLink "registrationComplete"/]</li>
                <li>[@tabLink "registrationSend"/]</li>
                <li>[@tabLink "registrationVerify"/]</li>
              </ul>
            </div>
            <div class="col-xs-6 col-md-8 col-lg-9">
              <div id="stylesheet" class="vertical-tab hidden">
                [@control.textarea name="theme.stylesheet" autocapitalize="none" autocorrect="off" required=false labelKey="empty" disabled=isFusionAuthTheme/]
              </div>
              <div id="messages" class="vertical-tab hidden">
                [#if !isFusionAuthTheme]
                <table id="localization-table" data-template="localization-template">
                  <thead>
                  <tr>
                    <th>[@message.print key="locale"/]</th>
                    <th data-sortable="false" class="action">[@message.print key="action"/]</th>
                  </tr>
                  </thead>
                  <tbody>
                  [#-- This empty row is not needed except to appease the JavaScript --]
                  <tr class="empty-row">
                    <td colspan="2">[@message.print key="no-localized-versions"/]</td>
                  </tr>
                  <tr data-locale="" data-messages="${((theme.defaultMessages)!'')}" data-is-default="true">
                    <td>
                      [@message.print key="default"/]
                      <input id="theme.defaultMessages" type="hidden" name="theme.defaultMessages" value="${((theme.defaultMessages)!'')}"/>
                    </td>
                    <td class="action">
                      [@button.action href="/ajax/theme/validate-localization?isDefault=true" color="blue" icon="edit" key="edit" ajaxWideDialog=true ajaxForm=true/]
                    </td>
                  </tr>
                  [#list theme.localizedMessages?keys![] as locale]
                    <tr data-locale="${locale}" data-messages="${((theme.localizedMessages(locale))!'')}" data-is-default="false">
                      <td>
                        ${locale.displayName}
                        <input id="theme.localizedMessages${locale}" type="hidden" name="theme.localizedMessages['${locale}']" value="${((theme.localizedMessages(locale))!'')}"/>
                      </td>
                      <td class="action">
                        [@button.action href="/ajax/theme/validate-localization" color="blue" icon="edit" key="edit" ajaxWideDialog=true ajaxForm=true/]
                        [@button.action href="/ajax/theme/delete-localization" color="red" icon="trash" key="delete" additionalClass="delete-button"/]
                      </td>
                    </tr>
                  [/#list]
                  </tbody>
                </table>
                [/#if]

                [#-- It is possible that an edit is occuring w/out modifying the messages and we are missing a message, show the error message here. --]
                [#if fieldMessages['theme.defaultMessages']?has_content]
                  <div class="form-row">
                    <span class="error">
                      [#list fieldMessages['theme.defaultMessages'] as e]
                        ${e.message}[#if e_has_next], [/#if]
                      [/#list]
                    </span>
                  </div>
                [/#if]

                [#-- Display the FusionAuth default messages so they can be copied / pasted and reviewed --]
                [#if isFusionAuthTheme]
                  [@control.textarea name="theme.defaultMessages" autocapitalize="none" autocorrect="off" required=false labelKey="empty" disabled=true/]
                [#else]
                  [@button.iconLinkWithText href="/ajax/theme/validate-localization" textKey="add-localization" id="add-localization" icon="plus"/]
                [/#if]
                <script type="x-handlebars" id="localization-template">
                  <tr>
                    <td>
                      {{localeDisplay}}
                      <input id="theme.localizedMessages{{locale}}" type="hidden" name="theme.localizedMessages['{{locale}}']" value="{{messages}}"/>
                    </td>
                    <td class="action">
                      [@button.action href="/ajax/theme/validate-localization" color="blue" icon="edit" key="edit" ajaxWideDialog=true ajaxForm=true/]
                      [@button.action href="/ajax/theme/delete-localization" color="red" icon="trash" key="delete" additionalClass="delete-button"/]
                    </td>
                  </tr>
                </script>
              </div>
              <div id="helpers" class="vertical-tab hidden">
                [@control.textarea name="theme.templates.helpers" autocapitalize="none" autocorrect="off" required=false labelKey="empty" disabled=isFusionAuthTheme/]
              </div>
              [@template "emailComplete" isFusionAuthTheme/]
              [@template "emailSend" isFusionAuthTheme/]
              [@template "emailVerify" isFusionAuthTheme/]
              [@template "oauth2Authorize" isFusionAuthTheme/]
              [@template "oauth2ChildRegistrationNotAllowed" isFusionAuthTheme/]
              [@template "oauth2ChildRegistrationNotAllowedComplete" isFusionAuthTheme/]
              [@template "oauth2CompleteRegistration" isFusionAuthTheme/]
              [@template "oauth2Device" isFusionAuthTheme/]
              [@template "oauth2DeviceComplete" isFusionAuthTheme/]
              [@template "oauth2Error" isFusionAuthTheme/]
              [@template "oauth2Logout" isFusionAuthTheme/]
              [@template "oauth2Passwordless" isFusionAuthTheme/]
              [@template "oauth2Register" isFusionAuthTheme/]
              [@template "oauth2TwoFactor" isFusionAuthTheme/]
              [@template "oauth2Wait" isFusionAuthTheme/]
              [@template "passwordChange" isFusionAuthTheme/]
              [@template "passwordComplete" isFusionAuthTheme/]
              [@template "passwordForgot" isFusionAuthTheme/]
              [@template "passwordSent" isFusionAuthTheme/]
              [@template "registrationComplete" isFusionAuthTheme/]
              [@template "registrationSend" isFusionAuthTheme/]
              [@template "registrationVerify" isFusionAuthTheme/]
            </div>
          </div>
        </div>
      </fieldset>
    </div>
  </fieldset>
[/#macro]