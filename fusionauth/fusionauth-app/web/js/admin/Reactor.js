/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 *
 * @constructor
 */
FusionAuth.Admin.Reactor = function() {
  Prime.Utils.bindAll(this);

  // Refresh key
  this.regenerateButton = Prime.Document.queryById('regenerate-key').addEventListener('click', this._handleRegenerateClick);
};

FusionAuth.Admin.Reactor.constructor = FusionAuth.Admin.Reactor;
FusionAuth.Admin.Reactor.prototype = {
  _handleRegenerateClick: function(event) {
    Prime.Utils.stopEvent(event);
    var uri = this.regenerateButton.getAttribute('href');
    var available = this.regenerateButton.getDataAttribute('available') === 'true';
    this.dialog = new Prime.Widgets.AJAXDialog()
        .withFormHandling(available)
        .withFormSuccessCallback(this._handleRegenerateSuccess)
        .open(uri);
  },

  _handleRegenerateSuccess: function() {
    this.dialog.close();
    window.location.reload();
  }
};
