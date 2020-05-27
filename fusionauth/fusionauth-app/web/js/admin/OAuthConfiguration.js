/*
 * Copyright (c) 2018-2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Constructs a OAuthConfiguration object.
 *
 * @param {Prime.Document.Element} element The form element.
 * @constructor
 */
FusionAuth.Admin.OAuthConfiguration = function(element) {
  Prime.Utils.bindAll(this);

  if (element.is('form')) {
    this.element = element;
  } else {
    this.element = element.queryFirst('form');
  }

  this.redirectURLs = Prime.Document.queryById('redirectURLs');
  this.origins = Prime.Document.queryById('origins');

  if (this.redirectURLs !== null) {
    new Prime.Widgets.MultipleSelect(this.redirectURLs)
        .withPlaceholder('e.g. https://www.example.com/oauth2callback')
        .withRemoveIcon('')
        .withCustomAddLabel('Add URL ')
        .initialize();
  }

  if (this.origins !== null) {
    new Prime.Widgets.MultipleSelect(this.origins)
        .withPlaceholder('e.g. https://www.example.com')
        .withRemoveIcon('')
        .withCustomAddLabel('Add URL ')
        .initialize();
  }

  this.clientSecretInput = Prime.Document.queryById('client-secret-input');
  this.clientSecretHidden = Prime.Document.queryById('client-secret-hidden');
  if (this.clientSecretInput !== null) {
    this.clientSecretInput.queryUp('div').queryFirst('a.button').addEventListener('click', this._handleRegenerateClick);
  }
};

FusionAuth.Admin.OAuthConfiguration.constructor = FusionAuth.Admin.OAuthConfiguration;

FusionAuth.Admin.OAuthConfiguration.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleRegenerateClick: function(event) {
    Prime.Utils.stopEvent(event);
    this.dialog = new Prime.Widgets.AJAXDialog()
        .withFormHandling(true)
        .withFormSuccessCallback(this._handleRegenerateSuccess)
        .open('/ajax/application/regenerate-client-secret');
  },

  _handleRegenerateSuccess: function(dialog, xhr) {
    this.dialog.close();
    var response = JSON.parse(xhr.responseText);
    this.clientSecretInput.setValue(response.clientSecret);
    this.clientSecretHidden.setValue(response.clientSecret);
  }
};
