/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * JavaScript for the User Data.
 *
 * @constructor
 * @param element
 */
FusionAuth.Admin.UserData = function(element) {
  Prime.Utils.bindAll(this);
  this.element = element;
};

FusionAuth.Admin.UserData.constructor = FusionAuth.Admin.UserData;
FusionAuth.Admin.UserData.prototype = {

  initialize: function() {
    this.viewJSON = this.element.queryFirst('input[type="checkbox"]');
    if (this.viewJSON === null) {
      return;
    }

    this.viewJSON.removeEventListener('change', this._handleRawToggle);
    this.viewJSON.addEventListener('change', this._handleRawToggle);
    this.formattedSections = this.element.query('.formatted');
    this.rawSections = this.element.query('pre.code');
    this.rawSections.hide();

    this.json = false;
  },

  _handleRawToggle: function(event) {
    Prime.Utils.stopEvent(event);
    this._toggleView();
  },

  _toggleView: function() {
    if (this.json) {
      this.rawSections.hide();
      this.formattedSections.show();
      this.json = false;
    } else {
      this.rawSections.show();
      this.formattedSections.hide();
      this.json = true;
    }
  }
};