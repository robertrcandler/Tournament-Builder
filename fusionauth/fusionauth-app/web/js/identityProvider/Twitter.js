/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.IdentityProvider = FusionAuth.IdentityProvider || {};

/**
 * @constructor
 */
FusionAuth.IdentityProvider.Twitter = function() {
  Prime.Utils.bindAll(this);

  // Load the client id
  var scripts = document.getElementsByTagName('script');
  var lastScript = new Prime.Document.Element(scripts[scripts.length - 1]);
  this.clientId = lastScript.getDataAttribute('clientId');

  Prime.Document.onReady(function() {
    this.button = Prime.Document.queryById('twitter-login-button');
    Prime.Document.addDelegatedEventListener('click', '#twitter-login-button', this._handleLoginClick);
  }.bind(this));
};

FusionAuth.IdentityProvider.Twitter.constructor = FusionAuth.IdentityProvider.Twitter;
FusionAuth.IdentityProvider.Twitter.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleLoginClick: function(event) {
    Prime.Utils.stopEvent(event);
    if (FusionAuth.IdentityProvider.InProgress) {
      FusionAuth.IdentityProvider.InProgress.open();
    }

    var state = FusionAuth.IdentityProvider.Helper.captureState({
      identityProviderId: '45bb233c-0901-4236-b5ca-ac46e2e0a5a5'
    });
    window.location.href = '/oauth1/request-token'
        + '?state.client_id=' + this.clientId
        + '&state.state=' + state
        + '&state.identityProviderId=45bb233c-0901-4236-b5ca-ac46e2e0a5a5';
  }
};

FusionAuth.IdentityProvider.Twitter.instance = new FusionAuth.IdentityProvider.Twitter();

//noinspection DuplicatedCode
if (document.getElementById('idp_helper') === null) {
  var element = document.createElement('script');
  element.id = 'idp_helper';
  element.src = '/js/identityProvider/Helper.js?version=' + (FusionAuth.Version || '1.11.0');
  element.async = false;
  document.getElementsByTagName("head")[0].appendChild(element);
}