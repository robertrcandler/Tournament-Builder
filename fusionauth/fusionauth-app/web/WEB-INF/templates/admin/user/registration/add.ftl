[#ftl/]
[#-- @ftlvariable name="registration" type="io.fusionauth.domain.UserRegistration" --]
[#-- @ftlvariable name="userId" type="java.util.UUID" --]
[#import "../../../_layouts/admin.ftl" as layout/]
[#import "_macros.ftl" as registrationMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.UserRegistrationForm([]);
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="add" method="POST" class="labels-left full" id="registration-form" cancelURI="/admin/user/manage/${userId}?tenantId=${tenantId}"
    breadcrumbs={"/admin/user/": "users", "/admin/user/manage/${userId}?tenantId=${tenantId}": "manage", "/admin/user/registration/add/${userId}?tenantId=${tenantId}": "user-registration"}]
      [@registrationMacros.formFields action="add"/]
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]