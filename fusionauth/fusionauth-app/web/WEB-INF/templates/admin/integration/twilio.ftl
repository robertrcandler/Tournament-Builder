[#ftl/]
[#-- @ftlvariable name="integrations" type="io.fusionauth.domain.Integrations" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head]
  <script src="${request.contextPath}/js/admin/integrations/TwilioConfiguration.js?version=${version}"></script>
  <script src="${request.contextPath}/js/vkbeautify-0.9.00.beta.js"></script>
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.TwilioConfiguration();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="twilio" method="POST" id="twilio-integration" includeSave=true includeCancel=true cancelURI="/admin/integration/" breadcrumbs={"/admin/integration/": "integrations", "/admin/integration/twioio": "page-title"}]
      [@control.checkbox name="integrations.twilio.enabled" value="true" uncheckedValue="false" data_slide_open="twilio-enabled-settings"/]
      <div id="twilio-enabled-settings" class="slide-open [#if integrations.twilio.enabled]open[/#if]">
        <fieldset>
          [@control.text name="integrations.twilio.url" autofocus=integrations.twilio.enabled?then('autofocus', '') autocapitalize="none" autocomplete="on" autocorrect="off" required=true tooltip=function.message('{tooltip}integrations.twilio.url')/]
          [@control.text name="integrations.twilio.accountSID" autocapitalize="none" autocomplete="off" autocorrect="off" required=true autofocus="autofocus"  spellcheck="false" tooltip=function.message('{tooltip}integrations.twilio.accountSID')/]
          [@control.text name="integrations.twilio.authToken" autocapitalize="none" autocomplete="off" autocorrect="off" spellcheck="false" required=true tooltip=function.message('{tooltip}integrations.twilio.authToken')/]
          [@control.text name="integrations.twilio.fromPhoneNumber" autocapitalize="none" autocomplete="on" autocorrect="off" tooltip=function.message('{tooltip}integrations.twilio.fromPhoneNumber')/]
          [@control.text name="integrations.twilio.messagingServiceSid" autocapitalize="none" autocomplete="on" autocorrect="off" spellcheck="false" tooltip=function.message('{tooltip}integrations.twilio.messagingServiceSid')/]
        </fieldset>

        <fieldset>
          <legend>[@message.print key="verify-configuration"/]</legend>
          <p>[@message.print key="verify-configuration-description"/]</p>

          <div class="form-row">
            <label for="test-phone-number">[@message.print key="test-phone-number"/]<span class="required">*</span></label>
            <div class="input-addon-group">
              <input id="test-phone-number" type="text" autocomplete="off" autocorrect="off" autocapitalize="none" />
              <a id="send-test-message" href="#" class="button blue"><i class="fa fa-arrow-circle-right"></i> <span class="text">[@message.print key="send-test-message"/]</span></a>
            </div>
          </div>

        </fieldset>

        <fieldset class="padded">
          <div id="twilio-ok" class="hidden">
            [@message.alert message=message.inline('test-success') type="info" icon="info-circle" includeDismissButton=false/]
          </div>
          <div id="twilio-error" class="hidden">
            [@message.alert message=message.inline('test-failure') type="error" icon="exclamation-circle" includeDismissButton=false/]
          </div>
          <textarea id="twilio-error-response" class="hidden"></textarea>
        </fieldset>
      </div>
    [/@layout.pageForm]

  [/@layout.body]
[/@layout.html]