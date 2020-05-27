[#ftl/]

[#import "../_utils/button.ftl" as button/]
[#import "../_layouts/user.ftl" as layout/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.main columnClass="col-xs col-lg-6"]

      [@panel.full titleKey="page-title" rowClass="row center-xs" columnClass="col-xs col-lg-6"]
        [@control.form action="/support/login" method="POST" class="labels-above full"]
        <fieldset>
          [@control.text name="email" autocapitalize="none" autocomplete="off" autocorrect="off" required=true autofocus="autofocus" labelKey="empty" leftAddon="user"/]
          [@control.text name="smtpUsername" autocapitalize="none" autocomplete="off" autocorrect="off" required=true labelKey="empty" leftAddon="lock"/]
          [@control.password name="smtpPassword" autocapitalize="none" autocomplete="off" autocorrect="off" required=true labelKey="empty" leftAddon="lock"/]
        </fieldset>
        <div class="form-row">
          [@button.formIcon icon="key"/]
        </div>
        [/@control.form]
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
