[#ftl/]
[#-- @ftlvariable name="key" type="io.fusionauth.domain.Key" --]
[#-- @ftlvariable name="type" type="io.fusionauth.domain.Key.KeyType" --]
[#-- @ftlvariable name="t" type="java.lang.String" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/locale.ftl" as locale/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.form action="import" titleKey="import-${(type??)?then(type?lower_case, t)}" formClass="labels-left full"]
  <fieldset>
    [@control.hidden name="t"/]
    [@control.hidden name="type"/]
    [@control.text name="keyId" autocapitalize="none" autocomplete="off" autocorrect="off"  tooltip=function.message('{tooltip}keyId')/]
    [@control.text name="key.name" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=true tooltip=function.message('{tooltip}key.name')/]
    [@control.text name="key.kid" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" required=false placeholder=function.message('{placeholder}key.kid') tooltip=function.message('{tooltip}key.kid')/]
    [#if (key.type!'') == "RSA" || (key.type!'') == "EC"]
    [@control.select name="key.algorithm" items=algorithms  tooltip=function.message('{tooltip}key.algorithm')/]
    [/#if]
  </fieldset>

  <fieldset>
    [#if (key.type!'') == "HMAC"]
      [@control.textarea name="key.secret" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}key.secret')/]
    [#elseif (key.type!'') == "EC" || (key.type!'') == "RSA"]
      [@control.textarea name="key.publicKey" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}key.publicKey')/]
      [@control.textarea name="key.privateKey" autocapitalize="none" autocomplete="off" autocorrect="off" required=false tooltip=function.message('{tooltip}key.privateKey')/]
    [#elseif t == "public"]
      [@control.textarea name="key.publicKey" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}key.publicKey')/]
    [#elseif t == "certificate"]
      [@control.textarea name="key.certificate" autocapitalize="none" autocomplete="off" autocorrect="off" required=true tooltip=function.message('{tooltip}key.certificate')/]
    [/#if]
  </fieldset>
[/@dialog.form]