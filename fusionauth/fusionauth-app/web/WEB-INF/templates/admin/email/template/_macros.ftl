[#ftl/]
[#-- @ftlvariable name="emailTemplate" type="io.fusionauth.domain.email.EmailTemplate" --]

[#import "../../../_utils/button.ftl" as button/]
[#import "../../../_utils/message.ftl" as message/]

[#macro formFields action]
  <fieldset>
    <p class="no-top-margin">
      <em>[@message.print key="freemarker-note"/]</em>
    </p>
    [#if action == "add"]
      [@control.text name="emailTemplateId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}emailTemplateId')/]
    [#else]
      [@control.text name="emailTemplateId" disabled=true tooltip=message.inline('{tooltip}readOnly')/]
      [@control.hidden name="emailTemplateId"/]
    [/#if]
    [@control.text name="emailTemplate.name" autocapitalize="on" autocomplete="off" autocorrect="on" autofocus="autofocus" required=true tooltip=function.message('{tooltip}emailTemplate.name') /]
    [@control.text name="emailTemplate.defaultSubject" autocapitalize="on" autocomplete="off" autocorrect="on" required=true tooltip=function.message('{tooltip}emailTemplate.defaultSubject') rightAddon="code"/]
    [@control.text name="emailTemplate.fromEmail" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}emailTemplate.fromEmail')/]
    [@control.text name="emailTemplate.defaultFromName" autocapitalize="on" autocomplete="on" autocorrect="off" tooltip=function.message('{tooltip}emailTemplate.defaultFromName') rightAddon="code"/]
  </fieldset>
  <fieldset class="mt-4">
    <ul class="tabs">
      <li><a href="#html">[@message.print key="html-template"/]</a></li>
      <li><a href="#text">[@message.print key="text-template"/]</a></li>
      <li><a href="#localization">[@message.print key="localization"/]</a></li>
    </ul>
    <div id="text" class="hidden">
      [@control.textarea name="emailTemplate.defaultTextTemplate" class="tall code" autocapitalize="on" autocomplete="on" autocorrect="on" required=true tooltip=function.message('{tooltip}emailTemplate.defaultTextTemplate')/]
      <div class="text-right">
        [@button.iconLinkWithText href="/ajax/email/template/preview" color="blue" icon="search" textKey="preview" tooltipKey="email-preview"/]
      </div>
    </div>
    <div id="html" class="hidden">
      [@control.textarea name="emailTemplate.defaultHtmlTemplate" class="tall code" autocapitalize="on" autocomplete="on" autocorrect="on" required=true tooltip=function.message('{tooltip}emailTemplate.defaultHtmlTemplate')/]
      <div class="text-right">
        [@button.iconLinkWithText href="/ajax/email/template/preview" color="blue" icon="search" textKey="preview" tooltipKey="email-preview"/]
      </div>
    </div>
    <div id="localization" class="hidden">
      <table id="localization-table" data-template="localization-template">
        <thead>
        <tr>
          <th>[@message.print key="locale"/]</th>
          <th data-sortable="false" class="action">[@message.print key="action"/]</th>
        </tr>
        </thead>
        <tbody>
          <tr class="empty-row">
            <td colspan="3">[@message.print key="no-localized-versions"/]</td>
          </tr>
          [#list emailTemplate.localizations![] as locale]
          <tr data-locale="${locale}" data-from-name="${((emailTemplate.localizedFromNames(locale))!'')}" data-html-template="${((emailTemplate.localizedHtmlTemplates(locale))!'')}" data-subject="${((emailTemplate.localizedSubjects(locale))!'')}" data-text-template="${((emailTemplate.localizedTextTemplates(locale))!'')}">
            <td>
            ${locale.displayName}
              <input id="emailTemplate.localizedFromNames${locale}" type="hidden" name="emailTemplate.localizedFromNames['${locale}']" value="${((emailTemplate.localizedFromNames(locale))!'')}"/>
              <input id="emailTemplate.localizedHtmlTemplates${locale}" type="hidden" name="emailTemplate.localizedHtmlTemplates['${locale}']" value="${((emailTemplate.localizedHtmlTemplates(locale))!'')}"/>
              <input id="emailTemplate.localizedSubjects${locale}" type="hidden" name="emailTemplate.localizedSubjects['${locale}']" value="${((emailTemplate.localizedSubjects(locale))!'')}"/>
              <input id="emailTemplate.localizedTextTemplates${locale}" type="hidden" name="emailTemplate.localizedTextTemplates['${locale}']" value="${((emailTemplate.localizedTextTemplates(locale))!'')}"/>
            </td>
            <td class="action">
              [@button.action href="/ajax/email/template/validate-localization" color="blue" icon="edit" key="edit" ajaxWideDialog=true ajaxForm=true/]
              [@button.action href="/ajax/email/template/delete-localization" color="red" icon="trash" key="delete" additionalClass="delete-button"/]
            </td>
          </tr>
          [/#list]
        </tbody>
      </table>
      [@button.iconLinkWithText href="/ajax/email/template/validate-localization" textKey="add-localization" id="add-localization" icon="plus"/]
      <script type="x-handlebars" id="localization-template">
        <tr>
          <td>
            {{localeDisplay}}
            <input id="emailTemplate.localizedFromNames{{locale}}" type="hidden" name="emailTemplate.localizedFromNames['{{locale}}']" value="{{fromName}}"/>
            <input id="emailTemplate.localizedHtmlTemplates{{locale}}" type="hidden" name="emailTemplate.localizedHtmlTemplates['{{locale}}']" value="{{htmlTemplate}}"/>
            <input id="emailTemplate.localizedSubjects{{locale}}" type="hidden" name="emailTemplate.localizedSubjects['{{locale}}']" value="{{subject}}"/>
            <input id="emailTemplate.localizedTextTemplates{{locale}}" type="hidden" name="emailTemplate.localizedTextTemplates['{{locale}}']" value="{{textTemplate}}"/>
          </td>
          <td class="action">
            [@button.action href="/ajax/email/template/validate-localization" color="blue" icon="edit" key="edit" ajaxWideDialog=true ajaxForm=true/]
            [@button.action href="/ajax/email/template/delete-localization" color="red" icon="trash" key="delete" additionalClass="delete-button"/]
          </td>
        </tr>
      </script>
    </div>
  </fieldset>
[/#macro]