[#ftl/]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "./_macros.ftl" as userMacros/]

[@layout.html]
  [@layout.head]
    <script src="/js/qrcode-min-0.1.js"></script>
    <script src="${request.contextPath}/js/admin/User.js?version=${version}"></script>
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.User();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" id="user-form" includeSave=true includeCancel=true cancelURI="/admin/" breadcrumbs={"/admin/user/": "users", "/admin/user/add": "add"}]
      [@userMacros.userFormFields "add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]