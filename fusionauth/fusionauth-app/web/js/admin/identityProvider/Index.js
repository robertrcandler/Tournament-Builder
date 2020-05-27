/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */

FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};
FusionAuth.Admin.IdentityProvider = FusionAuth.Admin.IdentityProvider || {};

/**
 * @constructor
 */
FusionAuth.Admin.IdentityProvider.Index = function() {
  Prime.Utils.bindAll(this);
  Prime.Document.query('a[href^="/ajax/"]').addEventListener('click', this._handleAddClick);
  Prime.Document.query('[data-view-url]').addEventListener('click', this._handleViewClick);
};

FusionAuth.Admin.IdentityProvider.Index.constructor = FusionAuth.Admin.IdentityProvider.Index;
FusionAuth.Admin.IdentityProvider.Index.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleAddClick: function(event) {
    Prime.Utils.stopEvent(event);
    var uri = new Prime.Document.Element(event.currentTarget).getAttribute('href');
    new Prime.Widgets.AJAXDialog().open(uri);
  },

  _handleViewClick: function(event) {
    Prime.Utils.stopEvent(event);
    var uri = new Prime.Document.Element(event.currentTarget).getDataAttribute('viewUrl');
    new Prime.Widgets.AJAXDialog()
        .withAdditionalClasses('resize wide')
        .open(uri);
  }
};

