[#ftl/]
[#-- @ftlvariable name="applications" type="io.fusionauth.domain.Application[]" --]
[#-- @ftlvariable name="redirectURL" type="java.lang.String" --]
[#-- @ftlvariable name="domains" type="java.lang.String" --]
[#-- @ftlvariable name="samlv2Lambdas" type="java.util.List<io.fusionauth.domain.Lambda>" --]
[#-- @ftlvariable name="openIDLambdas" type="java.util.List<io.fusionauth.domain.Lambda>" --]
[#-- @ftlvariable name="useOppenIdDiscovery" type="boolean" --]
[#-- @ftlvariable name="type" type="io.fusionauth.domain.provider.IdentityProviderType" --]
[#-- @ftlvariable name="identityProvider" type="io.fusionauth.domain.provider.BaseIdentityProvider" --]
[#-- @ftlvariable name="identityProviders" type="java.util.List<io.fusionauth.domain.provider.BaseIdentityProvider>" --]
[#-- @ftlvariable name="clientAuthenticationMethods" type="java.util.List<io.fusionauth.domain.provider.IdentityProviderOauth2Configuration.ClientAuthenticationMethod>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/dialog.ftl" as dialog/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_utils/properties.ftl" as properties/]

[#macro externalJWTFields identityProvider domains action]
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="externaljwt-enabled-settings"/]
  <div id="externaljwt-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
    [#if action=="edit"]
      [@control.hidden name="identityProviderId"/]
      [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
    [#else]
      [@control.text name="identityProviderId" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=message.inline('{tooltip}identityProviderId')/]
    [/#if]
    [@control.text name="identityProvider.name" autocapitalize="on" autocomplete="on" autocorrect="off" autofocus="autofocus" required=true tooltip=message.inline('{tooltip}identityProvider.name')/]
    [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>
    <fieldset>
      <legend>[@message.print key="options"/]</legend>

      <ul class="tabs">
        <li><a href="#applications">[@message.print "applications"/]</a></li>
        <li><a href="#jwt">[@message.print key="jwt"/]</a></li>
        <li><a href="#domains">[@message.print key="domains"/]</a></li>
        <li><a href="#oauth2">[@message.print "oauth2"/]</a></li>
      </ul>
      <div id="jwt" class="hidden">
        <fieldset>
        [@control.text name="identityProvider.uniqueIdentityClaim" autocapitalize="none" autocomplete="on" autocorrect="off" required=true placeholder=message.inline('{placeholder}identityProvider.uniqueIdentityClaim') tooltip=message.inline('{tooltip}identityProvider.uniqueIdentityClaim')/]
        [@control.text name="identityProvider.headerKeyParameter" autocapitalize="none" autocomplete="on" autocorrect="off" required=true placeholder=message.inline('{placeholder}identityProvider.headerKeyParameter') tooltip=message.inline('{tooltip}identityProvider.headerKeyParameter')/]
        [@control.select name="identityProvider.defaultKeyId" items=keys![] valueExpr="id" textExpr="name" headerL10n="no-default-selected" headerValue="" tooltip=message.inline('{tooltip}identityProvider.defaultKeyId') /]
        </fieldset>

        <fieldset>
          <legend>[@message.print key="claim-mapping"/]</legend>
          <p><em>[@message.print key="{description}claim-mapping"/]</em></p>

          <table id="claims-map-table" data-template="claim-map-template">
            <thead>
            <tr>
              <th>[@message.print key="claim-key"/]</th>
              <th>[@message.print key="claim-value"/]</th>
              <th data-sortable="false" class="action">[@message.print key="action"/]</th>
            </tr>
            </thead>
            <tbody>
            <tr class="empty-row">
              <td colspan="3">[@message.print key="no-claims"/]</td>
            </tr>
          [#list identityProvider.claimMap as incomingClaim, fusionAuthClaim]
          <tr data-incoming-claim="${(incomingClaim)!}" data-fusionauth-claim="${fusionAuthClaim}">
            <td>
              ${incomingClaim}
              <input id="identityProviders.claimMap_${incomingClaim}" type="hidden" name="identityProvider.claimMap['${incomingClaim}']" value="${fusionAuthClaim}"/>
            </td>
            <td>
              ${fusionAuthClaim}
            </td>
            <td class="action">
              [@button.action href="#" color="red" icon="trash" key="delete" additionalClass="delete-button"/]
            </td>
          </tr>
          [/#list]
            </tbody>
          </table>
        </fieldset>
        <script id="claim-map-template" type="text/x-handlebars-template">
          <tr>
            <td>
              {{incomingClaim}}
              <input id="identityProviders.claimMap_{{incomingClaim}}" type="hidden" name="identityProvider.claimMap['{{incomingClaim}}']" value="{{fusionAuthClaim}}"/>
            </td>
            <td>
              {{fusionAuthClaim}}
            </td>
            <td class="action">
            [@button.action href="#" color="red" icon="trash" key="delete" additionalClass="delete-button"/]
            </td>
          </tr>
        </script>
      [@button.iconLinkWithText href="/ajax/identity-provider/claim/add" textKey="{button}add-claim" id="add-claim" icon="plus" identityProviderId="${(identityProvider.id)!''}"/]
      </div>
      <div id="domains" class="hidden">
        <p><em>[@message.print key="{description}domains"/]</em></p>
        <fieldset>
        [@control.textarea name="domains" labelKey="empty"/]
        </fieldset>
      </div>
      <div id="oauth2" class="hidden">
        <p><em>[@message.print key="{description}oauth2"/]</em></p>
        <field>
        [@control.text name="identityProvider.oauth2.authorization_endpoint" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=message.inline('{tooltip}identityProvider.oauth2.authorization_endpoint')/]
        [@control.text name="identityProvider.oauth2.token_endpoint" autocapitalize="none" autocomplete="off" autocorrect="off" tooltip=message.inline('{tooltip}identityProvider.oauth2.token_endpoint')/]
        </field>
      </div>
      <div id="applications" class="hidden">
        <table class="hover">
          <thead>
          <tr>
            <th>[@message.print key="name"/]</th>
            [#if tenants?size > 1]
              <th class="hide-on-mobile">[@message.print key="tenant"/]</th>
            [/#if]
            <th>[@message.print key="enabled"/]</th>
            <th>[@message.print key="create-registration"/]</th>
          </tr>
          </thead>
          <tbody>
          [#list applications as application]
          [#local id = application.id/]
           [#if application.active]
           <tr>
             <td>${properties.display(application, "name")}</td>
             [#if tenants?size > 1]
               <td class="hide-on-mobile"> ${helpers.tenantName(application.tenantId)}</td>
             [/#if]
             <td class="icon">[@control.checkbox name="identityProvider.applicationConfiguration[${id}].enabled" labelKey="empty" uncheckedValue="false" value="true" includeFormRow=false /]</td>
             [#-- Do not allow createRegistration for the FusionAuth Application --]
             <td class="icon">[@control.checkbox name="identityProvider.applicationConfiguration[${id}].createRegistration" labelKey="empty" uncheckedValue="false" value="true" includeFormRow=false disabled=(id == fusionAuthId)/]</td>
           </tr>
           [#else]
             [@control.hidden name="identityProvider.applicationConfiguration[${id}].enabled" /]
             [@control.hidden name="identityProvider.applicationConfiguration[${id}].createRegistration" /]
           [/#if]
          [/#list]
          </tbody>
        </table>
      </div>
    </fieldset>
  </div>

<div id="key-view" class="prime-dialog hidden wide">
[@dialog.view titleKey="view-key"]
  <div class="mt-2">
    [@properties.table]
      <tr>
        <td class="top no-wrap">
          [@message.print key="label.keyId"/]
          [@message.print key="propertySeparator"/]
        </td>
        <td class="top" id="view-key-id"></td>
      </tr>
      <tr>
        <td class="top no-wrap">
          [@message.print key="label.encodedKey"/]
          [@message.print key="propertySeparator"/]
        </td>
        <td><pre class="code not-pushed" id="view-encoded-key"></pre></td>
      </tr>
    [/@properties.table]
  </div>
[/@dialog.view]
</div>

[/#macro]

[#macro socialAppConfig identityProvider]
  <fieldset>
    <legend>[@message.print key="applications"/]</legend>
    <div id="applications">
      <table class="hover">
        <thead>
        <tr>
          <th>[@message.print key="name"/]</th>
          [#if tenants?size > 1]
            <th class="hide-on-mobile">[@message.print key="tenant"/]</th>
          [/#if]
          <th>[@message.print key="enabled"/]</th>
          <th>[@message.print key="create-registration"/]</th>
          <th></th>
        </tr>
        </thead>
        <tbody>
          [#list applications as application]
            [#local id = application.id/]
            [#if application.active]
              <tr>
                <td>${properties.display(application, "name")}</td>
                [#if tenants?size > 1]
                  <td class="hide-on-mobile"> ${helpers.tenantName(application.tenantId)}</td>
                [/#if]
                <td class="icon">[@control.checkbox name="identityProvider.applicationConfiguration[${id}].enabled" labelKey="empty" uncheckedValue="false" value="true" includeFormRow=false /]</td>
                [#-- Do not allow createRegistration for the FusionAuth Application, but default enabled for new configurations --]
                [#local createRegistrationChecked = id != fusionAuthId ]
                [#if identityProvider.applicationConfiguration(id)??]
                  [#local createRegistrationChecked = identityProvider.applicationConfiguration(id).createRegistration/]
                [/#if]
                <td class="icon">[@control.checkbox name="identityProvider.applicationConfiguration[${id}].createRegistration" checked=createRegistrationChecked labelKey="empty" uncheckedValue="false" value="true" includeFormRow=false disabled=(id == fusionAuthId )/]</td>
                <td class="text-right">
                  <a href="#" class="slide-open-toggle" data-expand-open="${id}-advanced">
                    <div><i class="fa fa-angle-right"></i>&nbsp;[@message.print key="overrides"/]</div>
                  </a>
                </td>
              </tr>

              <tr class="advanced">
                <td colspan="4">
                  <div id="${id}-advanced" class="slide-open">
                    [#nested id application.active/]
                  </div>
                </td>
              </tr>
            [#else]
              [@control.hidden name="identityProvider.applicationConfiguration[${id}].enabled" /]
              [@control.hidden name="identityProvider.applicationConfiguration[${id}].createRegistration" /]
              [#nested id application.active/]
            [/#if]
          [/#list]
        </tbody>
      </table>
    </div>
  </fieldset>
[/#macro]

[#macro hyprFields identityProvider action]
  <p class="mt-0 mb-4">
     <em>[@message.print key="hypr-link"/] <a href="https://www.hypr.com/fusionauth-passwordless-mfa/" target="_blank">https://www.hypr.com/fusionauth-passwordless-mfa/</a>.</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="hypr-enabled-settings"/]
  <div id="hypr-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [/#if]
      [@control.text name="identityProvider.relyingPartyApplicationId" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.relyingPartyApplicationId')/]
      [@control.text name="identityProvider.relyingPartyURL" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.relyingPartyURL')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>
    [@socialAppConfig identityProvider; id, active]
      [#if active]
        [@control.text name="identityProvider.applicationConfiguration[${id}].relyingPartyApplicationId" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.relyingPartyApplicationId" tooltip=message.inline('{tooltip}identityProvider.relyingPartyApplicationId')/]
        [@control.text name="identityProvider.applicationConfiguration[${id}].relyingPartyURL" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.relyingPartyURL" tooltip=message.inline('{tooltip}identityProvider.relyingPartyURL')/]
      [#else]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].relyingPartyApplicationId" /]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].relyingPartyURL" /]
      [/#if]
    [/@socialAppConfig]
  </div>
[/#macro]

[#macro googleFields identityProvider action]
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="google-enabled-settings"/]
  <div id="google-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [/#if]
      [@control.text name="identityProvider.client_id" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.client_id')/]
      [@control.text name="identityProvider.client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
      [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" required=true placeholder=message.inline('{placeholder}googleButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
      [@control.text name="identityProvider.scope" autocapitalize="off" autocomplete="on" autocorrect="on" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.scope')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>
    [@socialAppConfig identityProvider; id, active]
      [#if active]
        [@control.text name="identityProvider.applicationConfiguration[${id}].client_id" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.client_id" tooltip=message.inline('{tooltip}identityProvider.client_id')/]
        [@control.text name="identityProvider.applicationConfiguration[${id}].client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey="identityProvider.client_secret" tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
        [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey="identityProvider.buttonText" tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
        [@control.text name="identityProvider.applicationConfiguration[${id}].scope" autocapitalize="off" autocomplete="on" autocorrect="on" spellcheck="false" labelKey="identityProvider.scope" tooltip=message.inline('{tooltip}identityProvider.scope')/]
      [#else]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].client_id" /]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].client_secret" /]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].scope" /]
      [/#if]
    [/@socialAppConfig]
  </div>
[/#macro]

[#macro twitterFields identityProvider action]
  <p class="mt-0 mb-4">
    <em>[@message.print key="{description}twitter-settings"/]</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="twitter-enabled-settings"/]
  <div id="twitter-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
    [#if action=="edit"]
      [@control.hidden name="identityProviderId"/]
      [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [@control.hidden name="identityProvider.name"/]
    [/#if]
      [@control.text name="identityProvider.consumerKey" autofocus="autofocus" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.consumerKey')/]
      [@control.text name="identityProvider.consumerSecret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.consumerSecret')/]
      [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" required=true placeholder=message.inline('{placeholder}twitterButtonText')  tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>
  [@socialAppConfig identityProvider; id, active]
    [#if active]
      [@control.text name="identityProvider.applicationConfiguration[${id}].consumerKey" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.consumerKey' tooltip=message.inline('{tooltip}identityProvider.consumerKey')/]
      [@control.text name="identityProvider.applicationConfiguration[${id}].consumerSecret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.consumerSecret' tooltip=message.inline('{tooltip}identityProvider.consumerSecret')/]
      [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey='identityProvider.buttonText' placeholder=message.inline('{placeholder}twitterButtonText')  tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
    [#else]
      [@control.hidden name="identityProvider.applicationConfiguration[${id}].consumerKey" /]
      [@control.hidden name="identityProvider.applicationConfiguration[${id}].consumerSecret" /]
      [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
    [/#if]
  [/@socialAppConfig]
  </div>
[/#macro]

[#macro facebookFields identityProvider action]
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="facebook-enabled-settings"/]
  <div id="facebook-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
    [#if action=="edit"]
      [@control.hidden name="identityProviderId"/]
      [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
    [/#if]
    [@control.text name="identityProvider.appId" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.appId')/]
    [@control.text name="identityProvider.client_secret" labelKey="identityProvider.appSecret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
    [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" required=true placeholder=message.inline('{placeholder}facebookButtonText')  tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
    [@control.text name="identityProvider.fields" autocapitalize="off" autocomplete="off" autocorrect="off"  spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.fields')/]
    [@control.text name="identityProvider.permissions" autocapitalize="off" autocomplete="off" autocorrect="off"  spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.permissions')/]
    [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>
  [@socialAppConfig identityProvider; id, active]
    [#if active]
     <fieldset>
     [@control.text name="identityProvider.applicationConfiguration[${id}].appId" autocapitalize="off" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" labelKey='identityProvider.appId' tooltip=message.inline('{tooltip}identityProvider.appId')/]
     [@control.text name="identityProvider.applicationConfiguration[${id}].client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.client_secret' tooltip=message.inline('{tooltip}identityProvider.client_secret')/]
     [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey='identityProvider.buttonText' placeholder=message.inline('{placeholder}facebookButtonText')  tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
     [@control.text name="identityProvider.applicationConfiguration[${id}].fields" autocapitalize="off" autocomplete="off" autocorrect="off"  spellcheck="false" labelKey='identityProvider.fields' tooltip=message.inline('{tooltip}identityProvider.fields')/]
     [@control.text name="identityProvider.applicationConfiguration[${id}].permissions" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.permissions' tooltip=message.inline('{tooltip}identityProvider.permissions')/]
    </fieldset>
    [#else]
      [@control.hidden name="identityProvider.applicationConfiguration[${id}].appId" /]
      [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
      [@control.hidden name="identityProvider.applicationConfiguration[${id}].client_secret" /]
      [@control.hidden name="identityProvider.applicationConfiguration[${id}].fields" /]
      [@control.hidden name="identityProvider.applicationConfiguration[${id}].permissions" /]
    [/#if]
  [/@socialAppConfig]
  </div>
[/#macro]

[#macro openIdFields identityProvider domains action]
  <p class="mt-0 mb-4">
    <em>[@message.print key="{description}oidc-settings"/]</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="openid-enabled-settings"/]
  <div id="openid-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [#else]
        [@control.text name="identityProviderId" tooltip=message.inline('{tooltip}identityProviderId')/]
      [/#if]
      [@control.text name="identityProvider.name" autocapitalize="on" autocomplete="on" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.name')/]
      [@control.text name="identityProvider.oauth2.client_id" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.oauth2.client_id')/]
      [@control.select items=clientAuthenticationMethods name="identityProvider.oauth2.clientAuthenticationMethod"  wideTooltip=function.message('{tooltip}identityProvider.oauth2.clientAuthenticationMethod')/]
      <div id="openid-client-secret" class="slide-open [#if identityProvider.oauth2.clientAuthenticationMethod != 'none']open[/#if]">
        [@control.text name="identityProvider.oauth2.client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.client_secret') required=true/]
      </div>
    </fieldset>
    <fieldset>
      [#assign useOpenIdDiscovery = action == "add" || identityProvider.oauth2.issuer?has_content/]
      [@control.checkbox name="useOpenIdDiscovery" value="true" uncheckedValue="false" checked=(action == "add" || identityProvider.oauth2.issuer?has_content) labelKey="discover-endpoints" data_slide_open="issuer-endpoint-configuration" data_slide_closed="issuer-configuration" tooltip=message.inline('{tooltip}useOpenIdDiscovery')/]
      <div id="issuer-configuration" class="slide-open [#if useOpenIdDiscovery]open[/#if]">
        [@control.text name="identityProvider.oauth2.issuer" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.issuer')/]
      </div>
      <div id="issuer-endpoint-configuration" class="slide-open [#if !useOpenIdDiscovery]open[/#if]">
        [@control.text name="identityProvider.oauth2.authorization_endpoint" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.authorization_endpoint')/]
        [@control.text name="identityProvider.oauth2.token_endpoint" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.token_endpoint')/]
        [@control.text name="identityProvider.oauth2.userinfo_endpoint" autocapitalize="off" autocomplete="off" autocorrect="off" required=true spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.userinfo_endpoint')/]
      </div>
      [@control.select items=openIDLambdas valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
    </fieldset>
    <fieldset>
      [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" required=true placeholder=message.inline('{placeholder}openIdButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
      [@control.text name="identityProvider.buttonImageURL" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.buttonImageURL')/]
      [@control.text name="identityProvider.oauth2.scope" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.oauth2.scope')/]
      [@control.textarea name="domains" labelKey="managed-domains" tooltip=message.inline('{tooltip}domains')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

    [@socialAppConfig identityProvider; id, active]
      [#if active]
        [@control.text name="identityProvider.applicationConfiguration[${id}].oauth2.client_id" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.oauth2.client_id' tooltip=message.inline('{tooltip}identityProvider.oauth2.client_id')/]
        [@control.text name="identityProvider.applicationConfiguration[${id}].oauth2.client_secret" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.oauth2.client_secret' tooltip=message.inline('{tooltip}identityProvider.oauth2.client_secret')/]
        [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey='identityProvider.buttonText' placeholder=message.inline('{placeholder}openIdButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
        [@control.text name="identityProvider.applicationConfiguration[${id}].buttonImageURL" autocapitalize="on" autocomplete="on" autocorrect="on" spellcheck="false" labelKey='identityProvider.buttonImageURL' tooltip=message.inline('{tooltip}identityProvider.buttonImageURL')/]
        [@control.text name="identityProvider.applicationConfiguration[${id}].oauth2.scope" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" labelKey='identityProvider.oauth2.scope' tooltip=message.inline('{tooltip}identityProvider.oauth2.scope')/]
      [#else]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].oauth2.client_id" /]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].oauth2.client_secret"/]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonImageURL" /]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].oauth2.scope" /]
      [/#if]
    [/@socialAppConfig]
  </div>
[/#macro]

[#macro samlv2Fields identityProvider domains action]
  <p class="mt-0 mb-4">
    <em>[@message.print key="{description}samlv2-settings"/]</em>
  </p>
  [@control.checkbox name="identityProvider.enabled" value="true" uncheckedValue="false" data_slide_open="samlv2-enabled-settings"/]
  <div id="samlv2-enabled-settings" class="slide-open [#if identityProvider.enabled]open[/#if]">
    <fieldset>
      [#if action=="edit"]
        [@control.hidden name="identityProviderId"/]
        [@control.text disabled=true name="identityProviderId" tooltip=message.inline('{tooltip}readOnly')/]
      [#else]
        [@control.text name="identityProviderId" tooltip=message.inline('{tooltip}identityProviderId')/]
      [/#if]
      [@control.text name="identityProvider.name" autocapitalize="on" autocomplete="on" autocorrect="off" autofocus="autofocus" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.name')/]

      [@control.text name="identityProvider.idpEndpoint" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.idpEndpoint')/]
      [@control.checkbox name="identityProvider.useNameIdForEmail" value="true" uncheckedValue="false" tooltip=message.inline('{tooltip}identityProvider.useNameIdForEmail') data_slide_open="saml-email-claim"/]
      <div id="saml-email-claim" class="slide-open [#if !identityProvider.useNameIdForEmail]open[/#if]">
        [@control.text name="identityProvider.emailClaim" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=message.inline('{tooltip}identityProvider.emailClaim')/]
      </div>
      [@control.select items=keys![] name="identityProvider.keyId" valueExpr="id" textExpr="name" headerValue="" headerL10n="select-samlv2-key" required=true tooltip=message.inline('{tooltip}identityProvider.keyId')/]
    </fieldset>
    <fieldset>
      <legend>[@message.print key="options"/]</legend>
      [@control.text name="identityProvider.buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" required=true placeholder=message.inline('{placeholder}openIdButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
      [@control.text name="identityProvider.buttonImageURL" autocapitalize="off" autocomplete="off" autocorrect="off" spellcheck="false" tooltip=message.inline('{tooltip}identityProvider.buttonImageURL')/]
      [@control.select items=samlv2Lambdas![] valueExpr="id" textExpr="name" headerValue="" headerL10n="none-selected-lambda-disabled" name="identityProvider.lambdaConfiguration.reconcileId" tooltip=message.inline('{tooltip}identityProvider.lambdaConfiguration.reconcileId')/]
      [@control.textarea name="domains" labelKey="managed-domains" tooltip=message.inline('{tooltip}domains')/]
      [@control.checkbox name="identityProvider.debug" value="true" uncheckedValue="false" tooltip=function.message('{tooltip}identityProvider.debug')/]
    </fieldset>

    [@socialAppConfig identityProvider; id, active]
      [#if active]
        [@control.text name="identityProvider.applicationConfiguration[${id}].buttonText" autocapitalize="on" autocomplete="on" autocorrect="on" labelKey='identityProvider.buttonText' placeholder=message.inline('{placeholder}samlv2ButtonText') tooltip=message.inline('{tooltip}identityProvider.buttonText')/]
        [@control.text name="identityProvider.applicationConfiguration[${id}].buttonImageURL" autocapitalize="on" autocomplete="on" autocorrect="on" spellcheck="false" labelKey='identityProvider.buttonImageURL' tooltip=message.inline('{tooltip}identityProvider.buttonImageURL')/]
      [#else]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonText" /]
        [@control.hidden name="identityProvider.applicationConfiguration[${id}].buttonImageURL" /]
      [/#if]
    [/@socialAppConfig]
  </div>
[/#macro]

[#macro identityProviderFields identityProvider action domains=""]
  [@control.hidden name="type"/]

  [#switch type!""]
    [#case "HYPR"]
      [@hyprFields identityProvider=identityProvider action=action/]
      [#break]
    [#case "Google"]
      [@googleFields identityProvider=identityProvider action=action/]
      [#break]
    [#case "Twitter"]
      [@twitterFields identityProvider=identityProvider action=action/]
      [#break]
    [#case "Facebook"]
      [@facebookFields identityProvider=identityProvider action=action/]
      [#break]
    [#case "OpenIDConnect"]
      [@openIdFields identityProvider=identityProvider domains=domains action=action/]
      [#break]
    [#case "SAMLv2"]
      [@samlv2Fields identityProvider=identityProvider domains=domains action=action/]
      [#break]
    [#default]
      [@externalJWTFields identityProvider=identityProvider domains=domains action=action/]
  [/#switch]
[/#macro]

[#macro identityProvidersGrid]
  [#if identityProviders?has_content ]
  <fieldset>
    <p class="mt-0">
      <em>[@message.print key="{description}page"/]</em>
    </p>
  </fieldset>
  [/#if]
  <div class="row">
    [#list identityProviders![] as provider]
      <a class="grid-trading-card col-xs-6 col-sm-4 col-md-4 col-lg-3 col-xl-2 ${provider.enabled?then('', 'disabled')}" href="edit/${provider.type}/${provider.id}">
        <header><span class="pl-1 pr-1">${properties.display(provider, "name")}</span></header>
        <div class="main">
          <img src="${request.contextPath}/images/identityProviders/${provider.type?lower_case}.svg" alt="${message.inline(provider.type)}">
        </div>

        <footer>
          <div data-view-url="/ajax/identity-provider/view/${provider.id}">
            <span class="green-text">
              [@message.print key="view"/]
            </span>
            <span class="green-text">
              <i class="fa fa-search"></i>
            </span>
          </div>
        </footer>
      </a>
    [/#list]

    <a class="grid-trading-card col-xs-6 col-sm-4 col-md-4 col-lg-3 col-xl-2" href="/ajax/identity-provider/types">
      <header>[@message.print key="add-provider"/]</header>
      <div class="main">
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
          <path fill="currentColor" d="M384 250v12c0 6.6-5.4 12-12 12h-98v98c0 6.6-5.4 12-12 12h-12c-6.6 0-12-5.4-12-12v-98h-98c-6.6 0-12-5.4-12-12v-12c0-6.6 5.4-12 12-12h98v-98c0-6.6 5.4-12 12-12h12c6.6 0 12 5.4 12 12v98h98c6.6 0 12 5.4 12 12zm120 6c0 137-111 248-248 248S8 393 8 256 119 8 256 8s248 111 248 248zm-32 0c0-119.9-97.3-216-216-216-119.9 0-216 97.3-216 216 0 119.9 97.3 216 216 216 119.9 0 216-97.3 216-216z"></path>
        </svg>
      </div>
      <div class="footer">&nbsp;</div>
    </a>
  </div>
[/#macro]

