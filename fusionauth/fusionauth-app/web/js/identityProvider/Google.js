/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.IdentityProvider = FusionAuth.IdentityProvider || {};

/**
 * @constructor
 */
FusionAuth.IdentityProvider.Google = function() {
  Prime.Utils.bindAll(this);

  // Load the client id
  var scripts = document.getElementsByTagName('script');
  var lastScript = new Prime.Document.Element(scripts[scripts.length - 1]);
  this.clientId = lastScript.getDataAttribute('clientId');

  Prime.Document.onReady(function() {
    this.button = Prime.Document.queryById('google-login-button');
    this.scope = this.button.getDataAttribute('scope');

    gapi.load('auth2', function() {
      // Retrieve the singleton for the GoogleAuth library and set up the client.
      var auth2 = gapi.auth2.init({
        client_id: this.clientId,
        scope: this.scope
      });

      auth2.attachClickHandler(this.button.domElement, {}, this._onSignIn, this._onFailure);
    }.bind(this));
  }.bind(this));
};

FusionAuth.IdentityProvider.Google.constructor = FusionAuth.IdentityProvider.Google;
FusionAuth.IdentityProvider.Google.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _onFailure: function(error) {
    if (error.error !== 'popup_closed_by_user') {
      console.log(error);
    }
  },

  _onSignIn: function(response) {
    if (FusionAuth.IdentityProvider.InProgress) {
      FusionAuth.IdentityProvider.InProgress.open();
    }

    // Disconnect so we do not auto-login when we return to this page
    var auth2 = gapi.auth2.getAuthInstance();
    auth2.disconnect();

    this._loginCallback(response);
  },

  _loginCallback: function(response) {
    var state = FusionAuth.IdentityProvider.Helper.captureState();
    window.location.href = '/oauth2/callback'
        + '?token=' + encodeURIComponent(response.getAuthResponse().id_token)
        + '&identityProviderId=82339786-3dff-42a6-aac6-1f1ceecb6c46'
        + '&state=' + state;
  }
};

FusionAuth.IdentityProvider.Google.instance = new FusionAuth.IdentityProvider.Google();

//noinspection DuplicatedCode
if (document.getElementById('idp_helper') === null) {
  var element = document.createElement('script');
  element.id = 'idp_helper';
  element.src = '/js/identityProvider/Helper.js?version=' + (FusionAuth.Version || '1.11.0');
  element.async = false;
  document.getElementsByTagName("head")[0].appendChild(element);
}