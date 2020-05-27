[#ftl/]
[#-- @ftlvariable name="pushEnabled" type="boolean" --]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/message.ftl" as message/]
[@layout.html]
  [@layout.head]
    <script src="/js/qrcode-min-0.1.js"></script>
    <script>
    Prime.Document.onReady(function() {
      var qrCode = Prime.Document.queryById('qrcode');
      // https://github.com/google/google-authenticator/wiki/Key-Uri-Format
      new QRCode(qrCode.domElement, 'otpauth://totp/FusionAuth%3A' + encodeURIComponent("${ftlCurrentUser.getLogin()}") + '?issuer=FusionAuth&secret=${twoFactorSecretBase32}');

      var form = Prime.Document.queryById('2fa-form');
      new FusionAuth.Account.TwoFactor(form);
    });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="/account/two-factor/enable" id="2fa-form" method="POST" pageTitleKey="enable-two-factor" cancelURI="/admin/user/manage/${ftlCurrentUser.id}?tenantId=${ftlCurrentUser.tenantId}" includeSave=true breadcrumbs={"/admin/user/": "users", "/admin/user/manage/${ftlCurrentUser.id}?tenantId=${ftlCurrentUser.tenantId}": "manage", "/account/two-factor/enable": "enable-two-factor"}]
      [#-- Keep in the form submit for validation purposes --]
      [@control.hidden name="twoFactorSecretBase32"/]

      <div class="row">
        <div class="col-xs">
          <fieldset>
            [#if !pushEnabled]
              <p><em>[@message.print "push-disabled"/]</em></p>
            [/#if]
            [@control.select name="delivery" items=deliveryTypes/]
            [#if pushEnabled]
              [@control.text name="mobilePhone" autofocus="autofocus" /]
            [/#if]
            [@control.hidden name="secret"/]
            [@control.text name="code" autofocus=pushEnabled?then("", "autofocus") autocapitalize="none" autocomplete="off" autocorrect="off"/]
            [#if pushEnabled]
              [@button.iconLinkWithText id="send-initial-code" textKey="send" href="#" icon="arrow-circle-right" color="blue" class="small-square float-right push-left" /]
            [/#if]
          </fieldset>
        </div>
      </div>

      <div class="hidden container-fluid" data-application-configuration>
        <div class="row">
          <div class="col-xs">
            <fieldset>
              <legend>[@message.print key="setup-two-factor-application"/]</legend>
            </fieldset>
          </div>
        </div>
        <div class="row">
          <div class="col-xs-12 col-md-8">
            <fieldset>
              <span>[@message.print key="two-factor.step1.description" values=[twoFactorSecretBase32] /]</span>
            </fieldset>
          </div>
          <div class="col-xs-12 col-md-4">
            <div id="qrcode" class="qrcode pull-right push-right"></div>
          </div>
        </div>
      </div>

    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]