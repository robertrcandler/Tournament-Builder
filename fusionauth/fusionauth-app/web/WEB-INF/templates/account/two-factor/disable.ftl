[#ftl/]
[#-- @ftlvariable name="pushEnabled" type="boolean" --]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/message.ftl" as message/]
[@layout.html]
  [@layout.head]
    <script>
    Prime.Document.onReady(function() {
      var form = Prime.Document.queryById('2fa-form');
      new FusionAuth.Account.TwoFactor(form);
    });
    </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="/account/two-factor/disable" id="2fa-form" method="POST" pageTitleKey="disable-two-factor" cancelURI="/admin/user/manage/${ftlCurrentUser.id}?tenantId=${ftlCurrentUser.tenantId}" includeSave=true breadcrumbs={"/admin/user/": "users", "/admin/user/manage/${ftlCurrentUser.id}?tenantId=${ftlCurrentUser.tenantId}": "manage", "/account/two-factor/disable": "disable-two-factor"}]
      <fieldset>
        <p><em>[@message.print "two-factor.disable.description"/]</em></p>
        [@control.text name="code" autofocus="autofocus" autocapitalize="none" autocomplete="off" autocorrect="off"/]
        [#if ftlCurrentUser?? && (ftlCurrentUser.twoFactorDelivery) == "TextMessage"]
          [#if pushEnabled]
            [@button.iconLinkWithText id="send-initial-code" textKey="send" href="#" icon="arrow-circle-right" color="blue" class="small-square float-right push-left"/]
          [#else]
            [@button.iconLinkWithText id="send-initial-code" textKey="send" href="#" icon="arrow-circle-right" color="blue" class="small-square float-right push-left disabled" disabled="disabled"/]
          [/#if]
        [/#if]
      </fieldset>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]