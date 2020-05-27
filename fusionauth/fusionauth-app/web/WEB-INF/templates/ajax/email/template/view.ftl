[#ftl/]
[#-- @ftlvariable name="emailTemplate" type="io.fusionauth.domain.email.EmailTemplate" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.view]
  <h3>[@message.print key="fields"/]</h3>
  [@properties.table]
    [@properties.rowEval nameKey="name" object=emailTemplate propertyName="name"/]
    [@properties.rowEval nameKey="id" object=emailTemplate propertyName="id"/]
    [@properties.rowEval nameKey="from-email" object=emailTemplate propertyName="fromEmail"/]
    [@properties.rowEval nameKey="from-name" object=emailTemplate propertyName="defaultFromName"/]
    [@properties.rowEval nameKey="subject" object=emailTemplate propertyName="defaultSubject"/]
    <tr>
      <td class="top">[@message.print key="html-template"/]</td>
      <td>
        <iframe class="preview">
        </iframe>
        <div id="html-source" class="hidden">
          [#if emailTemplate??]
            ${emailTemplate.defaultHtmlTemplate}
          [/#if]
        </div>
      </td>
    </tr>
    <tr>
      <td class="top">[@message.print key="text-template"/]</td>
      <td>
        <pre class="preview">${properties.display(emailTemplate, "defaultTextTemplate")}</pre>
      </td>
    </tr>
    <tr>
      <td>[@message.print key="localized-versions"/]</td>
      <td>
        <ul>
          [#list (emailTemplate.localizedSubjects?keys)![] as locale]
            <li>${properties.display(locale, "displayName")}</li>
          [#else]
            <li>[@message.print key="no-localized-versions"/]</li>
          [/#list]
        </ul>
      </td>
    </tr>
  [/@properties.table]
[/@dialog.view]
