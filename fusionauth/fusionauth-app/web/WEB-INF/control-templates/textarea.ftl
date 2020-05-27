[#ftl/]
[#import "_macros.ftl" as macros/]
<div id="${attributes['id']}-form-row" class="form-row">
[@macros.dynamic_attributes/]
[@macros.control_label/]
<textarea class="${macros.class('textarea')}" [@macros.append_attributes ["value"]/]>${(attributes['value']!'')}</textarea>
[@macros.errors/]
</div>
