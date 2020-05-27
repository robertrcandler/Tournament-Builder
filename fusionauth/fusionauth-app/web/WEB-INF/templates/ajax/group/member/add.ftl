[#ftl/]
[#-- @ftlvariable name="groups" type="java.util.List<io.fusionauth.domain.Group>" --]
[#-- @ftlvariable name="users" type="java.util.List<io.fusionauth.domain.User>" --]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "_macros.ftl" as memberMacros/]

[@dialog.form action="add" formClass="labels-left full" disableSubmit=errorMessages?has_content]
  [@memberMacros.memberFields/]
[/@dialog.form]
