[#ftl/]

[#import "../../../_utils/dialog.ftl" as dialog/]
[#import "../../../_utils/helpers.ftl" as helpers/]
[#import "../../../_utils/message.ftl" as message/]
[#import "../../../_utils/panel.ftl" as panel/]
[#import "../../../_utils/properties.ftl" as properties/]

[@dialog.basic titleKey="title" includeFooter=true]
<div style="display: flex; justify-content: center; flex-wrap: wrap">
  [#--  Set the height so we don't get a FOUC (ish) event - while we render the QR code which adjusts the height of the dialog --]
  [#--  The data-height is used to set the height of the QRCode --]
  <div id="qrcode" style="height: 325px;" data-height="325"></div>
  <form class="full mt-4 w-100">
    <input type="hidden" id="key-base32-secret">
    <div class="form-row">
      <label for="key-issuer">[@message.print key="key-issuer"/]</label>
      <input type="text" id="key-issuer" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false">
    </div>
    <div class="form-row">
      <label for="key-user">[@message.print key="key-user"/]</label>
      <input type="text" id="key-user" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false">
    </div>
    <div class="form-row">
      <label for="key-uri">[@message.print key="key-uri"/]</label>
      <textarea type="text" id="key-uri" style="resize: none; height: auto;" autocapitalize="none" autocomplete="off" autocorrect="off" autofocus="autofocus" spellcheck="false" disabled></textarea>
    </div>
  </form>
</div>
[/@dialog.basic]
