/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the webhook form by setting up an ExpandableTable for the headers.
 *
 * @constructor
 */
FusionAuth.Admin.WebhookForm = function(element) {
  Prime.Utils.bindAll(this);

  this.element = Prime.Document.Element.wrap(element);
  // uncheck the applications when we select 'Use for All Applications'. The API enforces this list to be empty if set to global.
  this.globalCheckbox = Prime.Document.queryById('webhook_global').addEventListener('click', this._handleGlobalClick);
  this.applicationSelect = Prime.Document.queryById('webhook_applicationIds');

  // Setup the header table
  new FusionAuth.UI.ExpandableTable(Prime.Document.queryById('header-table'));

  // Setup the editor
  this.certificateEditor = new FusionAuth.UI.TextEditor(element.queryFirst('textarea[name="webhook.sslCertificate"]')).withOptions({'mode': 'text/plain', 'lineWrapping': true});

  // Setup the tabs
  new Prime.Widgets.Tabs(element.queryFirst('.tabs')).withSelectCallback(this._handleTabSelect).initialize();
};

FusionAuth.Admin.WebhookForm.constructor = FusionAuth.Admin.WebhookForm;
FusionAuth.Admin.WebhookForm.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleGlobalClick: function() {
    if (this.globalCheckbox.isChecked()) {
      this.applicationSelect.query('input').setChecked(false);
    }
  },

  _handleTabSelect: function(tab) {
    if (tab.queryFirst('a').getAttribute('href') === '#security') {
      this.certificateEditor.render();
    }
  }
};
