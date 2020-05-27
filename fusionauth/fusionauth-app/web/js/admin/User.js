/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * JavaScript for the add / edit user page.
 *
 * @constructor
 */
FusionAuth.Admin.User = function() {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryById('user-form');
  this.passwordFields = Prime.Document.queryById('password-fields');
  this.twoFactorSecretFields = Prime.Document.queryById('two-factor-secret-fields');

  this.tenantIdSelect = this.form.queryFirst('select[name="tenantId"]');
  if (this.tenantIdSelect !== null) {
    this.tenantIdSelect.addEventListener('change', this._handleTenantIdChange);
  }

  // Edit User Password Options
  this.editUserPasswordOptions = this.form.queryFirst('select[name="editPasswordOption"]');
  if (this.editUserPasswordOptions !== null) {
    this.editUserPasswordOptions.addEventListener('change', this. _handleEditUserPasswordEvent);
  }

  // Edit Two Factor Secret Options
  this.editTwoFactorSecretOptions = this.form.queryFirst('select[name="editTwoFactorSecretOption"]');
  if (this.editTwoFactorSecretOptions !== null) {
    this.editTwoFactorSecretOptions.addEventListener('change', this. _handleTwoFactorSecretEvent);
  }

  this.qrCode = null;
  this.showQRCode= Prime.Document.queryById('show-qr-code');
  if (this.showQRCode !== null) {
    this.showQRCode.addEventListener('click', this._handleShowQRCodeClick);
  }

  this.twoFactorSecretInput = Prime.Document.queryById('two-factor-secret-input');
  if (this.twoFactorSecretInput !== null) {
    this.generateTwoFactorSecretButton = this.twoFactorSecretInput.getNextSibling().addEventListener('click', this._handleGenerateTwoFactorSecretClick);
  }

  // Birthdate date picker
  var birthDatePicker = this.form.queryFirst('.birthdate-picker');
  var birthDateSet = birthDatePicker.getValue().length > 0;
  new Prime.Widgets.DateTimePicker(birthDatePicker)
      .withCustomFormatHandler(this._handleDateFormat)
      .initialize();

  this.preferredLanguages = this.form.queryFirst('select[name="user.preferredLanguages"]');
  if (this.preferredLanguages !== null) {
    new Prime.Widgets.MultipleSelect(this.preferredLanguages)
        .withRemoveIcon('')
        .withCustomAddEnabled(false)
        .withPlaceholder('')
        .initialize();
  }

  // Kind of a hack for now, we should have an option on the date picker to not set the value on initialize unless the field contains a value
  if (!birthDateSet) {
    birthDatePicker.setValue('');
  }

  // handle this for field validation while change password is selected
  this._handleEditUserPasswordEvent();

  // Show password rules if necessary on load
  this._handleTenantIdChange();
};

FusionAuth.Admin.User.constructor = FusionAuth.Admin.User;
FusionAuth.Admin.User.prototype = {

  /* ===================================================================================================================
   * Private Methods
   * ===================================================================================================================*/

  _handleQRCodeDialogOpen: function() {
    var secret = this.form.queryFirst('input[name="user.twoFactorSecret"]').getValue();
    var encoding = this.form.queryFirst('input[name="secretEncoding"]:checked').getValue();

    // Null the qrCode widget to ensure we re-build it
    this.qrCode = null;

    // Ensure we have the Base32 version of the secret
    new Prime.Ajax.Request('/ajax/user/two-factor/qrcode-secret?secretEncoding=' + encoding + '&secret=' + encodeURIComponent(secret), 'GET')
        .withSuccessHandler(this._showQRCodeWithSecret)
        .go();
  },

  _handleShowQRCodeClick: function(event) {
    Prime.Utils.stopEvent(event);
    var button = new Prime.Document.Element(event.target);
    if (!button.is('a')) {
      button = button.queryUp('a');
    }

    var secret = this.form.queryFirst('input[name="user.twoFactorSecret"]').getValue();
    if (secret.length === 0) {
      return;
    }

    var uri = button.getAttribute('href');
    new Prime.Widgets.AJAXDialog()
        .withCallback(this._handleQRCodeDialogOpen)
        .open(uri);
  },

  _handleTenantIdChange: function() {
    // We call this on page load as well, so be defensive
    if (this.tenantIdSelect !== null) {
      var tenantId = this.tenantIdSelect.getSelectedValues()[0];
      this.form.query('[id^=password-rules-]').hide();
      var passwordRules = Prime.Document.queryById('password-rules-' + tenantId);
      if (passwordRules !== null) {
        passwordRules.show();
      }
    }
  },

  _showQRCodeWithSecret: function(xhr) {
    var response = JSON.parse(xhr.responseText);
    var secret = response.secretBase32Encoded;

    var secretHolder  = Prime.Document.queryById('key-base32-secret');
    secretHolder.setValue(secret);

    Prime.Document.queryById('key-issuer').setValue('FusionAuth').addEventListener('keyup', this._renderQRCode);
    Prime.Document.queryById('key-user').addEventListener('keyup', this._renderQRCode)
         .setValue(this.form.queryFirst('input[name="user.email"]').getValue() || this.form.queryFirst('input[name="user.username"]').getValue());

    this._renderQRCode();
  },

  _renderQRCode: function() {
    var qrCodeDiv = Prime.Document.queryById('qrcode');

    var keyIssuer = Prime.Document.queryById('key-issuer').getValue();
    var keyUser = Prime.Document.queryById('key-user').getValue();
    var secret = Prime.Document.queryById('key-base32-secret').getValue();

    // https://github.com/google/google-authenticator/wiki/Key-Uri-Format
    var keyURI = 'otpauth://totp/' + encodeURIComponent(keyIssuer) + '%3A' + encodeURIComponent(keyUser) + '?issuer=' + encodeURIComponent(keyIssuer) + '&secret=' + secret;
    Prime.Document.queryById('key-uri').setValue(keyURI);

    if (this.qrCode === null) {
      this.qrCode = new QRCode(qrCodeDiv.domElement, {
        text: keyURI,
        width: parseInt(qrCodeDiv.getDataAttribute('height')),
        height: parseInt(qrCodeDiv.getDataAttribute('height')),
      });
    } else {
      // Refresh it on subsequent requests
      this.qrCode.clear();
      this.qrCode.makeCode(keyURI);
    }
  },

  _handleGenerateSecretSuccess: function(xhr) {
    var response = JSON.parse(xhr.responseText);
    var encoding = this.form.queryFirst('input[name="secretEncoding"]:checked').getValue();

    if (encoding === 'Base32') {
      this.twoFactorSecretInput.setValue(response.secretBase32Encoded);
    } else {
      this.twoFactorSecretInput.setValue(response.secret);
    }
  },

  _handleGenerateTwoFactorSecretClick: function(event) {
    Prime.Utils.stopEvent(event);

    new Prime.Ajax.Request('/ajax/user/two-factor/generate-secret', 'GET')
        .withSuccessHandler(this._handleGenerateSecretSuccess)
        .go();
  },

  /**
   * Handles the select change event.
   * @private
   */
  _handleTwoFactorSecretEvent: function() {
    if (this.editTwoFactorSecretOptions !== null) {
      if (this.editTwoFactorSecretOptions.getValue() === 'updateSecret') {
        this.twoFactorSecretFields.addClass('open');
      } else {
        this.twoFactorSecretFields.removeClass('open');
      }
    }
  },

  /**
   * Handles the select change event.
   * @private
   */
  _handleEditUserPasswordEvent: function() {
    if (this.editUserPasswordOptions !== null) {
      if (this.editUserPasswordOptions.getValue() === 'update') {
        this.passwordFields.addClass('open');
      } else {
        this.passwordFields.removeClass('open');
      }
    }
  },

  /**
   * Hard coding this for now - we should really build a formatter into the Date Picker
   * @param date the current date value of the date picker
   * @returns {string} return a string to be set into the input field
   * @private
   */
  _handleDateFormat: function(date) {
    return (date.getMonth() + 1)  + "/" + date.getDate() + "/" + date.getFullYear();
  }
};