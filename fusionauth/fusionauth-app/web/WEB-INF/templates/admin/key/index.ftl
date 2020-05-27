[#ftl/]
[#-- @ftlvariable name="keys" type="java.util.List<io.fusionauth.domain.Key>" --]

[#import "../../_utils/button.ftl" as button/]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/message.ftl" as message/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]

[@layout.html]
  [@layout.head]
  <script>
    Prime.Document.onReady(function() {
      new FusionAuth.Admin.Keys();
    });
  </script>
  [/@layout.head]
  [@layout.body]
    [@layout.pageHeader titleKey="page-title" includeSave=false includeCancel=false includeAdd=false breadcrumbs={"": "settings", "/admin/key/": "key-master"}]
    <div id="key-actions" class="split-button" data-local-storage-key="keys-split-button">
      <a class="gray button square" href="#"><i class="fa fa-spinner fa-pulse"></i> [@message.print key="loading"/]</a>
      <button type="button" class="gray button square" aria-haspopup="true" aria-expanded="false">
        <span class="sr-only">[@message.print key="toggle-dropdown"/]</span>
      </button>
      <div class="menu">

        [#-- Import --]
        <a id="import-public" class="item" href="/ajax/key/import?t=public"  href="#">
          <i class="green-text fa fa-upload"></i> [@message.print key="import-public"/]
        </a>
        <a id="import-certificate" class="item" href="/ajax/key/import?t=certificate"  href="#">
          <i class="green-text fa fa-upload"></i> [@message.print key="import-certificate"/]
        </a>
        <a id="import-rsa" class="item" href="/ajax/key/import/RSA"  href="#">
          <i class="green-text fa fa-upload"></i> [@message.print key="import-rsa"/]
        </a>
        <a id="import-ec" class="item" href="/ajax/key/import/EC">
          <i class="green-text fa fa-upload"></i> [@message.print key="import-ec"/]
        </a>
        <a id="import-hmac" class="item" href="/ajax/key/import/HMAC">
          <i class="green-text fa fa-upload"></i> [@message.print key="import-hmac"/]
        </a>

        [#-- Generate --]
        <a id="generate-rsa" class="item" href="/ajax/key/generate/RSA" data-ajax-form="true">
          <i class="blue-text fa fa-refresh"></i> [@message.print key="generate-rsa"/]
        </a>
        <a id="generate-ec" class="item default" href="/ajax/key/generate/EC" data-ajax-form="true">
          <i class="blue-text fa fa-refresh"></i> [@message.print key="generate-ec"/]
        </a>
        <a id="generate-hmac" class="item" href="/ajax/key/generate/HMAC" data-ajax-form="true">
          <i class="blue-text fa fa-refresh"></i> [@message.print key="generate-hmac"/]
        </a>
      </div>
    </div>
    [/@layout.pageHeader]

    [@layout.main]
      [@panel.full]
        <table class="hover">
          <thead>
          <tr>
            <th class="hide-on-mobile"><a href="#">[@message.print key="id"/]</a></th>
            <th><a href="#">[@message.print key="name"/]</a></th>
            <th class="hide-on-mobile"><a href="#">[@message.print key="type"/]</a></th>
            <th><a href="#">[@message.print key="algorithm"/]</a></th>
            <th class="hide-on-mobile"><a href="#">[@message.print key="expiration"/]</a></th>
            <th data-sortable="false" class="action">[@message.print key="action"/]</th>
          </tr>
          </thead>
          <tbody>
            [#list keys![] as key]
              [#assign shadowKey = fusionAuth.statics['io.fusionauth.api.service.system.KeyService'].ClientSecretShadowKeys.contains(key.id)/]
              <tr>
                <td class="hide-on-mobile">${properties.display(key, "id")}</td>
                <td>${properties.display(key, "name")}</td>
                <td class="hide-on-mobile">[@message.print key=key.type.name()/]</td>
                <td>${properties.display(key, "algorithm")}</td>
                <td class="hide-on-mobile">${properties.displayZonedDateTime(key, "expirationInstant", "date-format", true)}</td>
                <td class="action">
                  [#if !shadowKey]
                    [@button.action href="edit/${key.id}" icon="edit" key="edit" color="blue"/]
                  [/#if]
                  [@button.action href="/ajax/key/view/${key.id}" icon="search" key="view" ajaxView=true ajaxWideDialog=true color="green"/]
                  [#if key.type != "HMAC"]
                  [@button.action href="/admin/key/download/${key.id}" icon="download" key="download" color="purple"/]
                  [/#if]
                  [#if !shadowKey]
                  [@button.action href="/ajax/key/delete/${key.id}" icon="trash" key="delete" ajaxForm=true color="red"/]
                  [/#if]
                </td>
              </tr>
            [#else]
              <tr>
                <td colspan="3">[@message.print key="no-keys"/]</td>
              </tr>
            [/#list]
          </tbody>
        </table>
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
