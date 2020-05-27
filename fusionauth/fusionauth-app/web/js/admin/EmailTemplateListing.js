/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

FusionAuth.Admin.EmailTemplateListing = function() {
  Prime.Utils.bindAll(this);

  var table = Prime.Document.queryFirst('table');
  new FusionAuth.UI.Listing(table)
      .withAJAXCallback(this._handleViewClick)
      .initialize();
};

FusionAuth.Admin.EmailTemplateListing.prototype = {
  _handleViewClick: function() {
    var htmlSource = Prime.Document.queryById('html-source');
    if (htmlSource !== null) {
      var html = FusionAuth.Util.unescapeHTML(htmlSource.getHTML());
      var htmlIframe = htmlSource.getParent().queryFirst('iframe').domElement.contentWindow.document;
      htmlIframe.open();
      htmlIframe.write(html);
      htmlIframe.close();
    }
  }
};

