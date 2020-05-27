[#ftl/]

[#import "_utils/button.ftl" as button/]
[#import "_layouts/user.ftl" as layout/]
[#import "_utils/message.ftl" as message/]
[#import "_utils/panel.ftl" as panel/]

[@layout.html]
  [@layout.head/]
  [@layout.body]
    [@layout.main columnClass="col-xs col-lg-8"]
      [@panel.full titleKey="panel-title" rowClass="row center-xs" columnClass="col-xs col-lg-8" panelClass="orange panel"]
        Silent configuration of the database and search engine configuration was attempted and failed. Silent configuration was
        attempted because you provided the following environment variables:

         <ul>
           <li><code>DATABASE_URL</code></li>
           <li><code>DATABASE_ROOT_USER</code></li>
           <li><code>FUSIONAUTH_SEARCH_SERVERS</code></li>
         </ul>

         Possible reasons why this failed and you ended up here:
         <ol>
           <li>The database is not started, or not accessible using the JDBC URL provided in the <code>DATABASE_URL</code> environment variable.</li>
           <li>The database root credentials provided by <code>DATABASE_ROOT_USER</code> and optionally <code>DATABASE_ROOT_PASSWORD</code> environment variables
             were incorrect or did not have adequate privileges to create the schema.</li>
           <li>Elasticsearch is not started, or not accessible using the URL(s) provided in the <code>FUSIONAUTH_SEARCH_SERVERS</code> environment variable.</li>
           <li>A problem exists between the keyboard and chair. (PEBKAC)</li>
         </ol>

          Please review the values you specified in the environment variables, ensure the database and Elasticsearch services are accessible
          and review the FusionAuth logs.
      [/@panel.full]
    [/@layout.main]
  [/@layout.body]
[/@layout.html]
