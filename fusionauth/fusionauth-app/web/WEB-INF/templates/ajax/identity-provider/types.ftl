[#ftl]
[#-- @ftlvariable name="availableTypes" type="io.fusionauth.domain.provider.IdentityProviderType[]" --]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]

[@dialog.view titleKey="title"]
  <div class="mt-2">
    [#list availableTypes as type]
      <a href="add/${type}" class="address-label" style="height: 60px">
        <div class="image">
          <img src="${request.contextPath}/images/identityProviders/${type?lower_case}.svg" alt="${message.inline(type?string)}">
        </div>
        <div class="heading">[@message.print key=type?string/]</div>
      </a>
    [/#list]
  </div>
[/@dialog.view]
