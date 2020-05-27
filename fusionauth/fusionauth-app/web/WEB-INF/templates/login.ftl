[#ftl/]
[#import "_utils/button.ftl" as button/]
[#import "_layouts/user.ftl" as layout/]
[#import "_utils/message.ftl" as message/]
[#import "_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.main]
      [@panel.full titleKey="empty" rowClass="row center-xs" columnClass="col-xs col-sm-8 col-md-6 col-lg-5 col-xl-4"]
        <a href="/logout">[@message.print key="back-to-login"/]</a>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
