[#ftl/]
[#-- @ftlvariable name="codeUserActionExample" type="java.lang.String" --]
[#-- @ftlvariable name="eventType" type="java.lang.String" --]
[#-- @ftlvariable name="id" type="java.util.UUID" --]
[#-- @ftlvariable name="jwtPublicKeyUpdateExample" type="java.lang.String" --]
[#-- @ftlvariable name="jwtRefreshTokenRevokeExample" type="java.lang.String" --]
[#-- @ftlvariable name="jwtRefreshExample" type="java.lang.String" --]
[#-- @ftlvariable name="temporalUserActionExample" type="java.lang.String" --]
[#-- @ftlvariable name="userBulkCreateExample" type="java.lang.String" --]
[#-- @ftlvariable name="userCreateExample" type="java.lang.String" --]
[#-- @ftlvariable name="userDeactivateExample" type="java.lang.String" --]
[#-- @ftlvariable name="userDeleteExample" type="java.lang.String" --]
[#-- @ftlvariable name="userReactivateExample" type="java.lang.String" --]
[#-- @ftlvariable name="userLoginFailedExample" type="java.lang.String" --]
[#-- @ftlvariable name="userLoginSuccessExample" type="java.lang.String" --]
[#-- @ftlvariable name="userRegistrationCreateExample" type="java.lang.String" --]
[#-- @ftlvariable name="userRegistrationDeleteExample" type="java.lang.String" --]
[#-- @ftlvariable name="userRegistrationUpdateExample" type="java.lang.String" --]
[#-- @ftlvariable name="userUpdateExample" type="java.lang.String" --]
[#-- @ftlvariable name="userRegistrationVerifiedExample" type="java.lang.String" --]
[#-- @ftlvariable name="userEmailVerifiedExample" type="java.lang.String" --]
[#-- @ftlvariable name="userPasswordBreachExample" type="java.lang.String" --]


[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "_macros.ftl" as webhookMacros/]

[#function selected value]
  [#if eventType?? && eventType == value]
    [#return "selected=\"selected\""/]
  [/#if]

  [#return ""/]
[/#function]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.WebhookTest()
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageForm action="/admin/webhook/test/${id}" method="POST" includeSave=true saveColor="purple" saveKey="send" saveIcon="send-o" includeCancel=true cancelURI="/admin/webhook/" breadcrumbs={"": "settings", "/admin/webhook/": "webhooks", "/admin/webhook/test/${id}": "test"}]
      <p class="no-top-margin"><em>[@message.print key="intro"/]</em></p>
        <fieldset>
            [@control.text name="webhook.url" disabled=true/]
          </fieldset>
          <div class="form-row">
            <label for="event-type-select">[@message.print key="event-type"/]</label>
            <label class="select">
              <select id="event-type-select">
                [#if temporalUserActionExample?has_content]
                  <option value="temporalUserAction" ${selected("temporalUserAction")}>Temporal User Action [user.action]</option>
                [/#if]
                [#if codeUserActionExample?has_content]
                  <option value="codeUserAction" ${selected("codeUserAction")}>Code-Based User Action [user.action]</option>
                [/#if]
                [#if userBulkCreateExample?has_content]
                  <option value="userBulkCreate" ${selected("userBulkCreate")}>User Bulk Create [user.bulk.create]</option>
                [/#if]
                [#if userCreateExample?has_content]
                  <option value="userCreate" ${selected("userCreate")}>User Create [user.create]</option>
                [/#if]
                [#if userDeactivateExample?has_content]
                  <option value="userDeactivate" ${selected("userDeactivate")}>User Deactivate [user.deactivate]</option>
                [/#if]
                [#if userDeleteExample?has_content]
                  <option value="userDelete" ${selected("userDelete")}>User Delete [user.delete]</option>
                [/#if]
                [#if userReactivateExample?has_content]
                  <option value="userReactivate" ${selected("userReactivate")}>User Reactivate [user.reactivate]</option>
                [/#if]
                [#if userUpdateExample?has_content]
                  <option value="userUpdate" ${selected("userUpdate")}>User Update [user.update]</option>
                [/#if]
                [#if jwtRefreshTokenRevokeExample?has_content]
                  <option value="jwtRefreshTokenRevoke" ${selected("jwtRefreshTokenRevoke")}>JWT Refresh Token Revoke [jwt.refresh-token.revoke]</option>
                [/#if]
                [#if jwtPublicKeyUpdateExample?has_content]
                  <option value="jwtPublicKeyUpdate" ${selected("jwtPublicKeyUpdate")}>JWT Public Key Update [jwt.public-key.update]</option>
                [/#if]
                 [#if jwtRefreshExample?has_content]
                  <option value="jwtRefresh" ${selected("jwtRefresh")}>JWT Refresh [jwt.refresh]</option>
                [/#if]
                [#if userLoginFailedExample?has_content]
                  <option value="userLoginFailed" ${selected("userLoginFailed")}>User Login Failed [user.login.failed]</option>
                [/#if]
                [#if userLoginSuccessExample?has_content]
                  <option value="userLoginSuccess" ${selected("userLoginSuccess")}>User Login Success [user.login.success]</option>
                [/#if]
                [#if userRegistrationCreateExample?has_content]
                  <option value="userRegistrationCreate" ${selected("userRegistrationCreate")}>User Registration Create [user.registration.create]</option>
                [/#if]
                [#if userRegistrationDeleteExample?has_content]
                  <option value="userRegistrationDelete" ${selected("userRegistrationDelete")}>User Registration Delete [user.registration.delete]</option>
                [/#if]
                [#if userRegistrationUpdateExample?has_content]
                  <option value="userRegistrationUpdate" ${selected("userRegistrationUpdate")}>User Registration Update [user.registration.update]</option>
                [/#if]
                [#if userRegistrationVerifiedExample?has_content]
                  <option value="userRegistrationVerified" ${selected("userRegistrationVerified")}>User Registration Verified [user.registration.verified]</option>
                [/#if]
                [#if userEmailVerifiedExample?has_content]
                  <option value="userEmailVerified" ${selected("userEmailVerified")}>User Email Verified [user.email.verified]</option>
                [/#if]
                [#if userPasswordBreachExample?has_content]
                  <option value="userPasswordBreach" ${selected("userPasswordBreach")}>User Password Breach [user.password.breach]</option>
                [/#if]
              </select>
            </label>
          </div>
          <div id="form-container" class="form-row">
          [#if temporalUserActionExample?has_content]
            <div id="temporalUserAction" class="hidden">
              [@control.textarea name="temporalUserActionExample"/]
              [@control.hidden name="type" value="UserAction"/]
              [@control.hidden name="eventType" value="temporalUserAction"/]
            </div>
          [/#if]
          [#if codeUserActionExample?has_content]
            <div id="codeUserAction" class="hidden">
              [@control.textarea name="codeUserActionExample"/]
              [@control.hidden name="type" value="UserAction"/]
              [@control.hidden name="eventType" value="codeUserAction"/]
            </div>
          [/#if]
          [#if userBulkCreateExample?has_content]
            <div id="userBulkCreate" class="hidden">
              [@control.textarea name="userBulkCreateExample"/]
              [@control.hidden name="type" value="UserBulkCreate"/]
              [@control.hidden name="eventType" value="userBulkCreate"/]
            </div>
          [/#if]
          [#if userCreateExample?has_content]
            <div id="userCreate" class="hidden">
              [@control.textarea name="userCreateExample"/]
              [@control.hidden name="type" value="UserCreate"/]
              [@control.hidden name="eventType" value="userCreate"/]
            </div>
          [/#if]
          [#if userDeactivateExample?has_content]
            <div id="userDeactivate" class="hidden">
              [@control.textarea name="userDeactivateExample"/]
              [@control.hidden name="type" value="UserDeactivate"/]
              [@control.hidden name="eventType" value="userDeactivate"/]
            </div>
          [/#if]
          [#if userDeleteExample?has_content]
            <div id="userDelete" class="hidden">
              [@control.textarea name="userDeleteExample"/]
              [@control.hidden name="type" value="UserDelete"/]
              [@control.hidden name="eventType" value="userDelete"/]
            </div>
          [/#if]
          [#if userReactivateExample?has_content]
            <div id="userReactivate" class="hidden">
              [@control.textarea name="userReactivateExample"/]
              [@control.hidden name="type" value="UserReactivate"/]
              [@control.hidden name="eventType" value="userReactivate"/]
            </div>
          [/#if]
          [#if userUpdateExample?has_content]
            <div id="userUpdate" class="hidden">
              [@control.textarea name="userUpdateExample"/]
              [@control.hidden name="type" value="UserUpdate"/]
              [@control.hidden name="eventType" value="userUpdate"/]
            </div>
          [/#if]
          [#if jwtRefreshTokenRevokeExample?has_content]
            <div id="jwtRefreshTokenRevoke" class="hidden">
              [@control.textarea name="jwtRefreshTokenRevokeExample"/]
              [@control.hidden name="type" value="JWTRefreshTokenRevoke"/]
              [@control.hidden name="eventType" value="jwtRefreshTokenRevoke"/]
            </div>
          [/#if]
          [#if jwtPublicKeyUpdateExample?has_content]
            <div id="jwtPublicKeyUpdate" class="hidden">
              [@control.textarea name="jwtPublicKeyUpdateExample"/]
              [@control.hidden name="type" value="JWTPublicKeyUpdate"/]
              [@control.hidden name="eventType" value="jwtPublicKeyUpdate"/]
            </div>
          [/#if]
          [#if jwtRefreshExample?has_content]
            <div id="jwtRefresh" class="hidden">
              [@control.textarea name="jwtRefreshExample"/]
              [@control.hidden name="type" value="JWTRefresh"/]
              [@control.hidden name="eventType" value="jwtRefresh"/]
            </div>
          [/#if]
          [#if userLoginSuccessExample?has_content]
            <div id="userLoginSuccess" class="hidden">
              [@control.textarea name="userLoginSuccessExample"/]
              [@control.hidden name="type" value="UserLoginSuccess"/]
              [@control.hidden name="eventType" value="userLoginSuccess"/]
            </div>
          [/#if]
          [#if userLoginFailedExample?has_content]
            <div id="userLoginFailed" class="hidden">
              [@control.textarea name="userLoginFailedExample"/]
              [@control.hidden name="type" value="UserLoginFailed"/]
              [@control.hidden name="eventType" value="userLoginFailed"/]
            </div>
          [/#if]
          [#if userRegistrationCreateExample?has_content]
            <div id="userRegistrationCreate" class="hidden">
              [@control.textarea name="userRegistrationCreateExample"/]
              [@control.hidden name="type" value="UserRegistrationCreate"/]
              [@control.hidden name="eventType" value="userRegistrationCreate"/]
            </div>
          [/#if]
          [#if userRegistrationDeleteExample?has_content]
            <div id="userRegistrationDelete" class="hidden">
              [@control.textarea name="userRegistrationDeleteExample"/]
              [@control.hidden name="type" value="UserRegistrationDelete"/]
              [@control.hidden name="eventType" value="userRegistrationDelete"/]
            </div>
          [/#if]
          [#if userRegistrationUpdateExample?has_content]
            <div id="userRegistrationUpdate" class="hidden">
              [@control.textarea name="userRegistrationUpdateExample"/]
              [@control.hidden name="type" value="UserRegistrationUpdate"/]
              [@control.hidden name="eventType" value="userRegistrationUpdate"/]
            </div>
          [/#if]
          [#if userRegistrationVerifiedExample?has_content]
            <div id="userRegistrationVerified" class="hidden">
                [@control.textarea name="userRegistrationVerifiedExample"/]
                [@control.hidden name="type" value="UserRegistrationVerified"/]
                [@control.hidden name="eventType" value="userRegistrationVerified"/]
            </div>
          [/#if]
          [#if userEmailVerifiedExample?has_content]
            <div id="userEmailVerified" class="hidden">
                [@control.textarea name="userEmailVerifiedExample"/]
                [@control.hidden name="type" value="UserEmailVerified"/]
                [@control.hidden name="eventType" value="userEmailVerified"/]
            </div>
          [/#if]
          [#if userPasswordBreachExample?has_content]
            <div id="userPasswordBreach" class="hidden">
                [@control.textarea name="userPasswordBreachExample"/]
                [@control.hidden name="type" value="UserPasswordBreach"/]
                [@control.hidden name="eventType" value="userPasswordBreach"/]
            </div>
          [/#if]
        </div>
    [/@layout.pageForm]
  [/@layout.body]
[/@layout.html]