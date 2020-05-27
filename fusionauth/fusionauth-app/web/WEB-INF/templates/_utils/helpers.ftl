[#ftl/]
[#import "message.ftl" as message/]

[#-- Functions --]
[#function hashToAttributes hash]
  [#assign result = ""/]
  [#list hash?keys as key]
    [#assign result = result + " ${key?string?replace('_', '-')}=${hash[key]?string}"/]
  [/#list]
   [#-- Return an extra space to ensure it can but up against anything else --]
  [#return result  + " "]
[/#function]

[#-- Truncate the string at the max length and add a title tag if the length is exceeded. --]
[#macro truncate string maxLength default="\x2013"]
  [#if string?has_content]
    [#if string?length lte maxLength]
      ${string}
    [#else]
      <span title="${string}">${string?substring(0, maxLength - 1)}&hellip;</span>
    [/#if]
  [#else]
    ${default}
  [/#if]
[/#macro]

[#macro avatar user]
[#if user.imageUrl??]
  <img src="${user.imageUrl}" class="profile w-100"/>
[#elseif user.lookupEmail()??]
  <img src="${function.gravatar(user.lookupEmail(), 200)}" class="profile w-100"/>
[#else]
  <img src="${request.contextPath}/images/missing-user-image.jpg" class="profile w-100"/>
[/#if]
[/#macro]

[#-- Prefer [@control.select/] - use this if you don't need the backing portion of prime --]
[#macro select options=[] labelKey="" id="" attributes...]
[#if labelKey?has_content && labelKey != ""]
<label for="${id}">[@message.print key="${labelKey}"/]</label>
[/#if]
<label class="select">
  [#if attributes['leftAddon']?? || attributes['rightAddon']??]
  <div class="input-addon-group">
    [#if attributes['leftAddon']??]
      <span class="icon"><i class="fa fa-${attributes['leftAddon']}"></i></span>
    [/#if]
  [/#if]
  <select class="select" id="${id}">
    [#list options as option]
      <option value="${option}">${option}</option>
    [/#list]
  </select>
  [#if attributes['leftAddon']?? || attributes['rightAddon']??]
    [#if attributes['rightAddon']??]
      <span class="icon"><i class="fa fa-${attributes['rightAddon']}"></i></span>
    [/#if]
  </div>
  [/#if]
</label>
[/#macro]

[#macro fauxCheckbox name="" labelKey="" uncheckedValue="" includeFormRow=true id="" tooltip="" attributes...]
  [#local id=id?has_content?then(id, name)/]
  [#if includeFormRow]
<div [#if id?has_content]id="${id}-form-row"[/#if] class="form-row">
  [/#if]
  [#if labelKey!="empty" && (labelKey?has_content || name?has_content)]
    <label [#if id?has_content]for="${id}"[/#if]>[@message.print key=labelKey?has_content?then(labelKey, name)/]</label>
  [/#if]
  [#if name != ""]
  <input type="hidden" name="__cb_${name}" value="${uncheckedValue}"/>
  [/#if]
  <label class="toggle" [#if tooltip?has_content]data-tooltip="${tooltip}"[/#if]><input type="checkbox"[#if id?has_content] id="${id}"[/#if] ${hashToAttributes(attributes)}/><span class="rail"></span><span class="pin"></span></label>
  [#if includeFormRow]
</div>
  [/#if]
[/#macro]

[#macro custonFormRow id="" labelKey="" required=false tooltip="" classes=""]
<div class="form-row ${classes}">
  [#if labelKey?has_content][#t/]
    <label for="${id}"[#if fieldMessages?size > 0 && fieldMessages?keys?seq_contains(labelKey)] class="error"[/#if]>[@message.print key=labelKey/][#if required]<span class="required">*</span>[/#if][#t/]
    [#if tooltip?has_content][#t/]
    <i class="fa fa-info-circle" data-tooltip="${tooltip}"></i>[#t/]
    [/#if][#t/]
    </label>[#t/]
  [#elseif labelKey == "empty"]
  <label></label>
  [/#if]
  <div class="inline-block">
    [#nested/]
  </div>
</div>
[/#macro]

[#macro fauxInput type name id="" value="" autocapitalize="none" autocomplete="on" autocorrect="off" autofocus=false labelKey="" placeholder="" leftAddon="" required=false tooltip="" disabled=false]
  [#local id=id?has_content?then(id, name)/]
<div class="form-row">
  [#if labelKey?has_content && labelKey!="empty"][#t/]
    <label for="${id}"[#if fieldMessages?size > 0 && fieldMessages?keys?seq_contains(labelKey)] class="error"[/#if]>[@message.print key=labelKey/][#if required]<span class="required">*</span>[/#if][#t/]
    [#if tooltip?has_content][#t/]
      <i class="fa fa-info-circle" data-tooltip="${tooltip}"></i>[#t/]
    [/#if][#t/]
    </label>[#t/]
  [/#if]
  [#if leftAddon?has_content]
    <div class="input-addon-group">
      <span class="icon"><i class="fa fa-${leftAddon}"></i></span>
  [/#if]
  <input type="${type}" name="${name}" [#if type != "password"]value="${value}"[/#if] autocapitalize="${autocapitalize}" autocomplete="${autocomplete}" autocorrect="${autocorrect}" [#if autofocus]autofocus="autofocus"[/#if] placeholder="${placeholder}" [#if disabled]disabled="disabled"[/#if]>

  [#if leftAddon?has_content]
    </div>
  [/#if]
</div>
[/#macro]

[#function approximateFromMinutes minutes]
  [#if minutes <= 90] [#-- less than or equal to 90 minutes --]
    [#return  minutes + " " + function.message((minutes > 1)?then("MINUTES", "MINUTE"))/]
  [#elseif minutes < 2880] [#-- less than to 48 hours --]
    [#local hours = (minutes / (60))?string("##0")/]
    [#return ((minutes % 60) != 0)?then("~", "") + hours + " " + function.message(((minutes / 60) > 1)?then("HOURS", "HOUR"))/]
  [#else]
    [#local days = (minutes / (24 * 60))?string("##0")/]
    [#return ((minutes % (24 * 60)) != 0)?then("~", "") + days + " " + function.message(((minutes / (24 * 60)) > 1)?then("DAYS", "DAY"))/]
  [/#if]
[/#function]

[#function approximateFromSeconds seconds]
  [#if seconds < 120]
    [#return seconds + " " + function.message((seconds > 1)?then("SECONDS", "SECOND"))/]/]
  [#elseif seconds <= 5400] [#-- less than or equal to 90 minutes --]
    [#local minutes = (seconds / (60))?string("##0")/]
    [#return (seconds % (60) != 0)?then("~", "") + minutes + " " + function.message(((seconds / 60) > 1)?then("MINUTES", "MINUTE"))/]
  [#elseif seconds < 172800] [#-- less than to 48 hours --]
    [#local hours = (seconds / (60 * 60))?string("##0")/]
    [#return (seconds % (60 * 60) != 0)?then("~", "") + hours + " " + function.message(((seconds / (60 * 60)) > 1)?then("HOURS", "HOUR"))/]
  [#else]
    [#local days = (seconds / (24 * 60 * 60))?string("##0")/]
    [#return (seconds % (24 * 60 * 60) != 0)?then("~", "") + days + " " + function.message(((seconds / (24 * 60 * 60)) > 1)?then("DAYS", "DAY"))/]
  [/#if]
[/#function]

[#function approximateFromMilliSeconds milliseconds]
  [#if milliseconds < 1000]
    [#return milliseconds + " " + function.message((milliseconds > 1)?then("MILLISECONDS", "MILLISECOND"))/]/]
  [#else]
    [#local seconds = (milliseconds / (1000))?string("##0")/]
    [#return (milliseconds % (1000) != 0)?then("~", "") + seconds + " " + function.message(((milliseconds / 1000) > 1)?then("SECONDS", "SECOND"))/]
  [/#if]
[/#function]

[#function tenantName tenantId]
  [#return tenants(tenantId).name/]
[/#function]

[#function tenantById tenantId]
    [#return tenants(tenantId)/]
[/#function]