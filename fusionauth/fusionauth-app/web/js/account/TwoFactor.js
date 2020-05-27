/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
var FusionAuth = FusionAuth || {};
FusionAuth.Account = FusionAuth.Account || {};
'use strict';

/**
 * Handles the Two Factor enable / disable form.
 *
 * @param {Prime.Document.Element} element the form element
 * @constructor
 */
FusionAuth.Account.TwoFactor = function(element) {
  Prime.Utils.bindAll(this);

  this.errors = null;
  this.form = element;
  this.applicationConfiguration = this.form.queryFirst('[data-application-configuration]');
  this.delivery = this.form.queryFirst('select[name="delivery"]');
  this.mobilePhone = this.form.queryFirst('input[name="mobilePhone"]');
  this.sendButton = this.form.queryFirst('a[href="#"]');

  if (this.delivery !== null) {
   this.delivery.addEventListener('change', this._handleDeliveryChange);
    this.toggleDeliveryTypes();
  }

  if (this.sendButton) {
    this.sendButton.addEventListener('click', this._handleSendClick);
  }
};

FusionAuth.Account.TwoFactor.constructor = FusionAuth.Account.TwoFactor;
FusionAuth.Account.TwoFactor.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  toggleDeliveryTypes: function() {
    if (this.delivery.getValue() === 'TextMessage') {
      this.applicationConfiguration.hide();
      if (this.mobilePhone !== null) {
        this.mobilePhone.queryUp('.form-row').show();
      }
      if (this.sendButton !== null) {
        this.sendButton.show();
      }
    } else {
      this.applicationConfiguration.show();
      if (this.mobilePhone !== null) {
        this.mobilePhone.queryUp('.form-row').hide();
      }
      if (this.sendButton !== null) {
        this.sendButton.hide();
      }
    }
  },

  _handleDeliveryChange: function() {
    this.toggleDeliveryTypes();
  },

  _handleSendClick: function(event) {
    Prime.Utils.stopEvent(event);

    var request = {};

    // Add secret if provided
    var secret = this.form.queryFirst('input[name="secret"]');
    if (secret !== null) {
      request.secret = secret.getValue();
      if (this.mobilePhone !== null) {
        request.mobilePhone = this.mobilePhone.getValue();
      }
    }

    if (this.errors !== null) {
      this.errors.destroy();
    }

    var csrfToken = encodeURIComponent(this.form.queryFirst('input[type="hidden"][name="primeCSRFToken"]').getValue());
    var inProgress = new Prime.Widgets.InProgress(this.form.queryFirst('.panel')).withMinimumTime(500);
    new Prime.Ajax.Request('/ajax/account/two-factor/send?primeCSRFToken=' + csrfToken, 'POST')
        .withInProgress(inProgress)
        .withJSON(request)
        .withErrorHandler(this._handleSendResponse)
        .withSuccessHandler(this._handleSendResponse)
        .go();
  },

  _handleSendResponse: function(xhr) {
    if (xhr.status === 400) {
      this.errors = new FusionAuth.UI.Errors()
          .withErrors(JSON.parse(xhr.responseText))
          .withForm(this.form)
          .initialize();
    }
  }
};