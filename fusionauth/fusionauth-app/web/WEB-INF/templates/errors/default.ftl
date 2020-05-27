[#ftl/]

[#import "../_utils/button.ftl" as button/]
[#import "../_layouts/user.ftl" as layout/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.main]
      [@panel.full titleKey="default-error-title" titleValues=[statusCode] rowClass="row center-xs" columnClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4"]
        Not exactly sure what happened. FusionAuth should have captured a stack trace in the log. If you have a licensed edition, contact support
        using the form under the "Get Support" menu item. Otherwise, check your logs to see what the error might be.
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
