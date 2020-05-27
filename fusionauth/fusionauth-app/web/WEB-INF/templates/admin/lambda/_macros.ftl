[#ftl/]
[#-- @ftlvariable name="lambda" type="io.fusionauth.domain.Lambda" --]
[#-- @ftlvariable name="types" type="io.fusionauth.domain.LambdaType[]" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/message.ftl" as message/]

[#macro formFields action]
  <fieldset>
    [#if action=="add"]
      [@control.text name="lambdaId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}lambdaId')/]
    [#else]
      [@control.text name="lambdaId" disabled=true autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=function.message('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="lambda.name" autocapitalize="on" autocomplete="on" autocorrect="on" autofocus="autofocus" required=true tooltip=function.message('{tooltip}lambda.name')/]
    [#if action="add"]
      [@control.select items=types name="lambda.type" tooltip=function.message('{tooltip}lambda.type')/]
    [#else]
      [@control.hidden name="lambda.type"/]
      [@helpers.fauxInput type="text" name="lambda.type" labelKey="lambda.type" value=lambda.type?has_content?then(message.inline(lambda.type), '') tooltip=function.message('{tooltip}readOnly') disabled=true/]
    [/#if]
    [@control.checkbox name="lambda.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}lambda.debug')/]
    [@control.textarea name="lambda.body" autocapitalize="on" autocomplete="on" autocorrect="on" required=true tooltip=function.message('{tooltip}lambda.body')/]
  </fieldset>
  [#list types as type]
    <div id="${type}" class="hidden">${type.example}</div>
  [/#list]
[/#macro]