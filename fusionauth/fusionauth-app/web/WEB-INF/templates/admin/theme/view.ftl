[#ftl/]
[#-- @ftlvariable name="applicationId" type="java.util.UUID" --]
[#-- @ftlvariable name="hasDomainBasedIdentityProviders" type="boolean" --]
[#-- @ftlvariable name="showPasswordField" type="boolean" --]
[#-- @ftlvariable name="showPasswordValidationRules" type="boolean" --]
[#-- @ftlvariable name="theme" type="io.fusionauth.domain.Theme" --]
[#-- @ftlvariable name="userCodeLength" type="int" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/helpers.ftl" as helpers/]


[@layout.html]
[@layout.head]
<script>
  Prime.Document.onReady(function() {
    new Prime.Widgets.Tabs(Prime.Document.queryById('ui-tabs'))
        .withErrorClassHandling('error')
        .withLocalStorageKey('settings.theme.ui-configuration.tabs')
        .initialize();

    Prime.Document.query('.theme-preview input[type="checkbox"],select').addEventListener('change', function(event) {
      var target=  Prime.Document.Element.wrap(event.target);
      target.queryUp('form').domElement.submit();
    });
  });
</script>
[/@layout.head]
<body>
[@panel.full panelClass="panel mt-4" mainClass="h-100"]
  [@properties.table]
    [@properties.rowEval nameKey="name" object=theme propertyName="name"/]
    [@properties.rowEval nameKey="id" object=theme propertyName="id"/]
  [/@properties.table]

    [#assign templates = [
      "emailComplete",
      "emailSend",
      "emailVerify",
      "oauth2Authorize",
      "oauth2ChildRegistrationNotAllowed",
      "oauth2ChildRegistrationNotAllowedComplete",
      "oauth2CompleteRegistration",
      "oauth2Device",
      "oauth2DeviceComplete",
      "oauth2Error",
      "oauth2Logout",
      "oauth2Passwordless",
      "oauth2Register",
      "oauth2TwoFactor",
      "oauth2Wait",
      "passwordChange",
      "passwordComplete",
      "passwordForgot",
      "passwordSent",
      "registrationComplete",
      "registrationSend",
      "registrationVerify"
     ]/]

  <div class="row h-100 theme-preview">
    <div class="col-xs-6 col-md-4 col-lg-6 col-xl-2">
      <ul id="ui-tabs" class="vertical-tabs">
        [#list templates as template]
          <li><a href="#${template}">[@message.print key="theme.templates.${template}"/] <label><i class="fa fa-info-circle" data-tooltip="${function.message('{tooltip}theme.templates.${template}')}"></i></label></a></li>
        [/#list]
      </ul>
    </div>
    <div class="col-xs-6 col-md-8 col-lg-6 col-xl-10">
    [#list templates as template]
      <div id="${template}" class="vertical-tab hidden">
        <div>
          [#assign previewURL = "/admin/theme/preview"
          + "?applicationId=${applicationId}"
          + "&themeId=${theme.id}"
          + "&template=${template}"
          + "&hasDomainBasedIdentityProviders=${hasDomainBasedIdentityProviders?c}"
          + "&showPasswordField=${showPasswordField?c}"
          + "&showPasswordValidationRules=${showPasswordValidationRules?c}"
          + "&userCodeLength=${userCodeLength}"
          /]
        <iframe style="display: block; width: 100%; min-height: 500px; height: calc(100vh - 300px); border: 1px solid #bfbfbf;" src="${previewURL}"></iframe>
        </div>
        <div class="mt-3">
            [@control.form action="view" method="GET" class="full labels-left"]
                [@control.hidden name="themeId"/]
                [#-- Show controls relevant to the template --]
                [#if template == "oauth2Authorize" || template = "oauth2ChildRegistrationNotAllowedComplete" || template = "oauth2CompleteRegistration"]
                  <div class="row">
                    <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                      [@control.checkbox name="hasDomainBasedIdentityProviders" value="true" uncheckedValue="false"/]
                    </div>
                    <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                      [@control.checkbox name="showPasswordField" value="true" uncheckedValue="false"/]
                    </div>
                  </div>
                [#elseif template == "passwordChange"]
                  <div class="row">
                    <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                      [@control.select items=applications name="applicationId" textExpr="name" valueExpr="id"/]
                    </div>
                    <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                      [@control.checkbox name="showPasswordValidationRules" value="true" uncheckedValue="false"/]
                    </div>
                  </div>
                [#elseif template == "oauth2Device"]
                  <div class="row">
                    <div class="col-xs-6 col-md-6 col-lg-6 col-xl-12">
                      [@control.text name="userCodeLength"/]
                    </div>
                  </div>
                [/#if]
            [/@control.form]
        </div>
      </div>
    [/#list]
    </div>
  </div>
[/@panel.full]
</body>
[/@layout.html]
