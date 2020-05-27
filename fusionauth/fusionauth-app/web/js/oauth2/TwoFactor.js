/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.OAuth2 = FusionAuth.OAuth2 || {};

/**
 * @constructor
 */
FusionAuth.OAuth2.TwoFactor = function() {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryById('2fa-form');
  this.resendCode = this.form.queryFirst('input[name="resendCode"]');
  // Be defensive because this template is themeable
  if (this.resendCode !== null) {
    var resend2fa = Prime.Document.queryById('resend-2fa');
    if (resend2fa !== null) {
      resend2fa.addEventListener('click', this._handleResendClick);
    }
  }
};

FusionAuth.OAuth2.TwoFactor.constructor = FusionAuth.OAuth2.TwoFactor;
FusionAuth.OAuth2.TwoFactor.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleResendClick: function(event) {
    Prime.Utils.stopEvent(event);
    this.resendCode.setValue('true');
    this.form.domElement.submit();
  }
};
