[#ftl/]

[#import "button.ftl" as button/]
[#import "helpers.ftl" as helpers/]
[#import "message.ftl" as message/]

[#macro full titleKey="" titleValues=[] rowClass="row" columnClass="col-xs" panelClass="panel" mainClass=""]
<div class="${rowClass}">
  <div class="${columnClass}">
    <div class="${panelClass}">
      [#if titleKey != ""]
        <h2>[@message.print key=titleKey values=titleValues/]</h2>
      [/#if]
      <main class="${mainClass}">
        [#nested/]
      </main>
    </div>
  </div>
</div>
[/#macro]

[#macro customFull titleKey="" titleValues=[] rowClass="row" columnClass="col-xs" panelClass="panel" mainClass=""]
<div class="${rowClass}">
  <div class="${columnClass}">
    <div class="${panelClass}">
      [#nested/]
    </div>
  </div>
</div>
[/#macro]

[#macro simple titleKey="page-title" class="panel"]
<div class="${class}">
  <h2>[@message.print key=titleKey/]</h2>
  <main>
    [#nested/]
  </main>
</div>
[/#macro]

[#macro whatIsNew titleKey="what-is-new" versions=[] titleValues=[] rowClass="row" columnClass="col-xs" panelClass="panel orange" mainClass=""]
<div class="${rowClass} what-is-new" data-versions="${versions?join(",")}">
  <div class="${columnClass}">
    <div class="${panelClass}">
      [#if titleKey != ""]
        <h2>[@message.print key=titleKey values=titleValues/]</h2>
      [/#if]
      <main class="${mainClass}">
        [#nested/]
        <p>[@message.print key="see-release-notes" values=["https://fusionauth.io/docs/v1/tech/release-notes"]/]</p>
        <div class="row mb-3 mt-4">
         <label class="checkbox" style="margin-top: auto;">
            <input type="checkbox" class="checkbox" name="do-not-show-again" />
              <span class="box"></span>
              <span class="label">[@message.print key="do-not-show-again"/]</span>
          </label>
        </div>
        <div class="row">
          <a href="#" class="gray button mr-2 dismiss" > <i class="fa fa-check green-text"> </i> <span class="text">[@message.print key="dismiss" /]</span></a>
        </div>
      </main>
    </div>
  </div>
</div>
[/#macro]

