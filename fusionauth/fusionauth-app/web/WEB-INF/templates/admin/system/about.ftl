[#ftl/]
[#-- @ftlvariable name="instance" type="io.fusionauth.api.domain.Instance" --]
[#-- @ftlvariable name="productInformation" type="io.fusionauth.api.domain.ProductInformation" --]
[#import "../../_layouts/admin.ftl" as layout/]
[#import "../../_utils/panel.ftl" as panel/]
[#import "../../_utils/properties.ftl" as properties/]
[#import "../../_utils/message.ftl" as message/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.pageHeader breadcrumbs={"": "system", "/admin/system/about": "about"}/]
    [@layout.main]
      [@panel.full titleKey="product-information"]
        <fieldset>
          [@properties.table]
            [@properties.rowEval nameKey="version" object=productInformation propertyName="currentProductVersion"/]
            [@properties.rowNestedValue nameKey="latest-version"]
              [#if productInformation.productUpdateAvailable]
                ${productInformation.latestProductVersion}
              [#else]
                <i class="fa fa-check green-text"></i>
              [/#if]
            [/@properties.rowNestedValue]
            [@properties.row nameKey="nodes" value=productInformation.nodes?size /]
            [@properties.row nameKey="instance-id" value=properties.display(instance, "id")/]
          [/@properties.table]
        </fieldset>

        [#list productInformation.nodes as node]
          <h3>[@message.print key="node"/][#if productInformation.nodes?size > 1] ${node?index + 1}[/#if]</h3>
          <fieldset>
            [@properties.table]
              [@properties.rowEval nameKey="nodeId" object=node propertyName="id" /]
              [@properties.rowEval nameKey="startup" object=node propertyName="insertInstant" /]
              [@properties.rowEval nameKey="uptime" object=node propertyName="uptimeInDays" /]
             [#if productInformation.nodes?size > 1]
               [@properties.rowEval nameKey="me" object=node propertyName="me" /]
             [/#if]
            [/@properties.table]
          </fieldset>
        [/#list]
      [/@panel.full]

      [@panel.full titleKey="system-information"]
        <fieldset>
          [@properties.table]
            [@properties.row nameKey="dbEngine" value=message.inline(productInformation.dbEngine)/]
            [@properties.row nameKey="searchEngine" value=message.inline(productInformation.searchEngine)/]
          [/@properties.table]
        </fieldset>
      [/@panel.full]

    [/@layout.main]
  [/@layout.body]
[/@layout.html]