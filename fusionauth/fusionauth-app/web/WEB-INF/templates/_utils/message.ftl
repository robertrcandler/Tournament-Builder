[#ftl/]

[#-- Macros --]

[#macro alert message type icon includeDismissButton=true]
<div class="alert ${type}">
  <i class="fa fa-${icon}"></i>
  <p>
    ${message}
  </p>
  [#if includeDismissButton]
    <a href="#" class="dismiss-button"><i class="fa fa-times-circle"></i></a>
  [/#if]
</div>
[/#macro]

[#macro alertColumn message type icon includeDismissButton=true columnClass=""]
<div class="row center-xs">
  [#-- columnClass may be in scope from another macro --]
  <div class="${columnClass?has_content?then(columnClass, "col-xs")}">
    [@alert message type icon includeDismissButton/]
  </div>
</div>
[/#macro]

[#macro print key values=[]]
  [#local escapedValues = [] /]
  [#list values as value]
    [#local escapedValues += [value?is_string?then(value?esc?markup_string, value)] /]
  [/#list]
  [#noautoesc][@control.message key=key values=escapedValues/][/#noautoesc][#t]
[/#macro]

[#macro printErrorAlerts columnClass=""]
  [#if errorMessages?size > 0]
    [#list errorMessages as m]
      [@alertColumn message=m type="error" icon="exclamation-circle" columnClass=columnClass/]
    [/#list]
  [/#if]
[/#macro]

[#macro printInfoAlerts columnClass=""]
  [#if infoMessages?size > 0]
    [#list infoMessages as m]
      [@alertColumn message=m type="info" icon="info-circle" columnClass=columnClass/]
    [/#list]
  [/#if]
[/#macro]

[#macro printWarningAlerts columnClass=""]
  [#if warningMessages?size > 0]
    [#list warningMessages as m]
      [@alertColumn message=m type="warning" icon="exclamation-triangle" columnClass=columnClass/]
    [/#list]
  [/#if]
[/#macro]


[#-- Functions --]

[#function inline key]
  [#return function.message(key)?no_esc/]
[/#function]

