[#ftl/]
[#setting url_escaping_charset='UTF-8'/]
[#-- @ftlvariable name="actionsAvailable" type="boolean" --]
[#-- @ftlvariable name="actions" type="java.util.List<io.fusionauth.domain.UserActionLog>" --]
[#-- @ftlvariable name="families" type="java.util.List<io.fusionauth.domain.Family>" --]
[#-- @ftlvariable name="groups" type="java.util.List<io.fusionauth.domain.Group>" --]
[#-- @ftlvariable name="application" type="io.fusionauth.domain.Application" --]
[#-- @ftlvariable name="registrationsAvailable" type="boolean" --]
[#-- @ftlvariable name="refreshTokens" type="java.util.List<io.fusionauth.domain.jwt.RefreshToken>" --]
[#-- @ftlvariable name="user" type="io.fusionauth.domain.User" --]
[#-- @ftlvariable name="tenant" type="io.fusionauth.domain.Tenant" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_utils/helpers.ftl" as helpers/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "_macros.ftl" as userMacros/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      var userId = '${user.id}';
      new FusionAuth.Admin.ManageUser(userId);
    });
  </script>
  [/@layout.head]
  [@layout.body]

    [@layout.pageHeader titleKey="page-title" breadcrumbs={"/admin/user/": "users", "/admin/user/manage/${user.id}?tenantId=${user.tenantId}": "manage"}]
      <div class="split-button" data-local-storage-key="user-manage-split-button">
        <a class="gray button square" href="#"><i class="fa fa-spinner fa-pulse"></i> [@message.print key="loading"/]</a>
        <button type="button" class="gray button square" aria-haspopup="true" aria-expanded="false">
          <span class="sr-only">[@message.print key="toggle-dropdown"/]</span>
        </button>
        <div class="menu">
          <a id="edit-user" class="item default" href="/admin/user/edit/${user.id}?tenantId=${user.tenantId}"><i class="fa fa-edit"></i>
            [#if user.id == ftlCurrentUser.id][@message.print key="edit-profile"/][#else][@message.print key="edit"/][/#if]
          </a>
          [#if user.id == ftlCurrentUser.id]
            [#if user.twoFactorEnabled]
              <a id="disable-two-factor" class="item" href="/account/two-factor/disable"><i class="fa fa-key"></i> [@message.print key="disable-two-factor"/]</a>
            [#else]
              <a id="enable-two-factor" class="item" href="/account/two-factor/enable"><i class="fa fa-key"></i> [@message.print key="enable-two-factor"/]</a>
            [/#if]
          [/#if]
          <a id="add-user-comment" class="item" href="/ajax/user/comment/${user.id}" data-ajax-form="true"><i class="fa fa-comment-o"></i> [@message.print key="comment-user"/]</a>
          [#if actionsAvailable]
            <a id="add-user-action" class="item" href="/ajax/user/action/${user.id}" data-ajax-form="true" data-ajax-wide-dialog="true"><i class="fa fa-gavel"></i> [@message.print key="action-user"/]</a>
          [/#if]
          [#if user.id != ftlCurrentUser.id]
            <a id="delete-user" class="item" href="/admin/user/delete/${user.id}?tenantId=${user.tenantId}"><i class="fa fa-trash"></i> [@message.print key="delete"/]</a>
          [/#if]
          [#if user.active]
            [#if user.id != ftlCurrentUser.id]
              <a id="deactivate-user" class="item" href="/ajax/user/deactivate/${user.id}" data-ajax-form="true"><i class="fa fa-lock"></i> [@message.print key="lock-account"/]</a>
            [/#if]
          [#else]
            <a id="reactivate-user" class="item" href="/ajax/user/reactivate/${user.id}" data-ajax-form="true"><i class="fa fa-unlock-alt"></i> [@message.print key="unlock-account"/]</a>
          [/#if]
          [#if tenant.emailConfiguration.forgotPasswordEmailTemplateId?? && user.email??]
            <a id="send-password-reset" class="item" href="/ajax/user/send-password-reset/${user.id}?tenantId=${user.tenantId}" data-ajax-form="true"><i class="fa fa-envelope"></i> [@message.print key="send-password-reset"/]</a>
          [/#if]
          [#if tenant.emailConfiguration.verifyEmail && !user.verified && user.email??]
            <a id="resend-email-verification" class="item" href="/ajax/user/resend-email-verification/${user.id}?tenantId=${user.tenantId}" data-ajax-form="true"><i class="fa fa-envelope"></i> [@message.print key="resend-email-verification"/]</a>
          [/#if]
          <a id="require-password-change" class="item" href="/ajax/user/require-password-change/${user.id}?tenantId=${user.tenantId}" data-ajax-form="true"><i class="fa fa-lock"></i> [@message.print key="require-password-change"/]</a>
        </div>
      </div>
    [/@layout.pageHeader]

    [@layout.main]
      [#if user.breachedPasswordStatus?? && user.breachedPasswordStatus != "None"]
      <div class="row">
        <div class="col-xs">
          [@message.alert message=message.inline('[Breached' + user.breachedPasswordStatus + ']') type="warning" icon="exclamation-triangle" includeDismissButton=false/]
        </div>
      </div>
      [/#if]

      [#assign panelColor = user.active?then('blue', 'red')/]
      [#if user.breachedPasswordStatus?? && user.breachedPasswordStatus != "None"]
        [#assign panelColor = 'orange'/]
      [/#if]

      [@panel.full panelClass="panel ${panelColor}"]
        [@userMacros.details/]

        <ul class="tabs">
          <li><a href="#registrations">[@message.print key="registrations"/]</a></li>
          <li><a href="#families">[@message.print key="families"/]</a></li>
          <li><a href="#memberships">[@message.print key="groups"/]</a></li>
          <li><a href="#recent-logins">[@message.print key="recent-logins"/]</a></li>
          <li><a href="#consent">[@message.print key="consent"/]</a></li>
          <li><a href="#sessions">[@message.print key="sessions"/]</a></li>
          <li><a href="#user-data">[@message.print key="user-data"/]</a></li>
          <li><a href="#user-actions">[@message.print key="current-actions"/]</a></li>
          <li><a href="#user-history">[@message.print key="user-history"/]</a></li>
        </ul>

        <div id="registrations" class="hidden">
          [@userMacros.registrationsTable/]
        </div>

        <div id="families" class="hidden">
          [@userMacros.familiesTable/]
        </div>

        <div id="memberships" class="hidden">
          [@userMacros.membershipsTable/]
        </div>

        <div id="recent-logins">
          <div id="user-last-logins">
            [#include "*/ajax/user/recent-logins.ftl"/]
          </div>
        </div>

        <div id="consent" class="hidden">
          [@userMacros.consentTable/]
        </div>

        <div id="sessions">
          [@userMacros.session/]
        </div>

        <div id="user-data">
          [@userMacros.data/]
        </div>

        <div id="user-actions">
          [@userMacros.currentActionsTable/]
        </div>

        <div id="user-history">
          [@userMacros.historyTable/]
        </div>

      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]

