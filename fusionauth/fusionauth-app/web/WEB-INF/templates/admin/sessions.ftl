[#ftl/]
[#-- @ftlvariable name="deadSessions" type="java.util.List<io.fusionauth.app.action.admin.SessionsAction.CoolHttpSession>" --]
[#-- @ftlvariable name="oauthSessions" type="java.util.List<io.fusionauth.app.action.admin.SessionsAction.CoolHttpSession>" --]
[#-- @ftlvariable name="fusionAuthSessions" type="java.util.List<io.fusionauth.app.action.admin.SessionsAction.CoolHttpSession>" --]

[#import "../_layouts/admin.ftl" as layout/]
[#import "../_utils/button.ftl" as button/]
[#import "../_utils/message.ftl" as message/]
[#import "../_utils/panel.ftl" as panel/]
[#import "../_utils/properties.ftl" as properties/]

[#macro sessionTable sessions]
 <table data-session-table>
   <thead>
   <tr>
     <th><a href="#">[@message.print key="login"/]</a></th>
     <th><a href="#">[@message.print key="usersId"/]</a></th>
     <th><a href="#">[@message.print key="name"/]</a></th>
     <th><a href="#">[@message.print key="lastAccess"/]</a></th>
     <th><a href="#">[@message.print key="remaining"/]</a></th>
     <th data-sortable="false" class="action">[@message.print key="action"/]</th>
   </tr>
   </thead>
   <tbody>
      [#if sessions?has_content]
      [#list sessions![] as session]
        <tr>
          <td>
            [#if (session.user.email)??]
              ${(session.user.email)!"\x2013"}
            [#else]
              ${(session.user.username)!"\x2013"}
            [/#if]
          </td>
          <td>${(session.user.id)!"\x2013"}</td>
          <td>${(session.user.name)!"\x2013"}</td>
          <td data-sort-type="number" data-sort-value="${session.lastAccessInstant.toInstant().toEpochMilli()}">${function.format_zoned_date_time(session.lastAccessInstant, function.message('date-time-seconds-format'), zoneId)}</td>
          <td data-sort-type="number">${session.remainingMinutes} minutes</td>
          <td data-sortable="false" class="action">
            [#if (session.user.id)?has_content]
              [@button.action href="/admin/user/manage/${session.user.id}?tenantId=${session.user.tenantId}" icon="address-card-o" key="manage" color="purple"/]
            [/#if]
          </td>
        </tr>
      [/#list]
      [#else]
      <tr>
        <td colspan="5">No sessions</td>
      </tr>
      [/#if]

   </tbody>
 </table>
  [#if sessions?has_content && sessions?size > 1]
  <em>${sessions?size} sessions</em>
  [/#if]
[/#macro]


[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      Prime.Document.query('[data-session-table]').each(function(table) {
        new FusionAuth.UI.Listing(table);
      });
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" /]
    [@layout.main]

      [@panel.full titleKey="fusionauth-sessions"]
        [@sessionTable fusionAuthSessions /]
      [/@panel.full]

      [@panel.full titleKey="oauth-sessions"]
        [@sessionTable oauthSessions /]
      [/@panel.full]

      [#-- Not really expecting any of these - but this may be a sign of something bad if we see these show up --]
      [#if deadSessions?has_content]
        [@panel.full titleKey="dead-sessions"]
          [@sessionTable deadSessions /]
        [/@panel.full]
      [/#if]

    [/@layout.main]
  [/@layout.body]
[/@layout.html]