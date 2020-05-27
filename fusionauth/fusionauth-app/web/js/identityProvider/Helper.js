/*
 * Copyright (c) 2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.IdentityProvider = FusionAuth.IdentityProvider || {};

FusionAuth.IdentityProvider.Helper = {
  /**
   * URL Safe Base64 Encoding. Replace the + (plus) and a / (slash) with - (dash) and _ (under bar)
   *
   *  Code   Base64   URL Safe
   *  ------------------------
   *  62     +        -
   *  63     /        _
   *
   * Also remove trailing padding characters (=)
   *
   * @param s
   * @returns {string}
   */
  base64URLEncode: function(s) {
    return btoa(s).replace(/\+/g, '-')
                  .replace(/\//g, '_')
                  .replace(/=+$/, '');
  },

  captureState: function(additionalFields) {

    // Not all fields will be present in older themes, so check for null.
    function safeEncode(selector) {
      var element = Prime.Document.queryFirst(selector);
      if (element === null) {
        return '';
      }

      return encodeURIComponent(element.getValue());
    }

    var state =
        'client_id=' + safeEncode('input[name=client_id]')
        + '&code_challenge=' + safeEncode('input[name="code_challenge"]')
        + '&code_challenge_method=' + safeEncode('input[name="code_challenge_method"]')
        + '&metaData.device.name=' + safeEncode('input[name="metaData.device.name"]')
        + '&metaData.device.type=' + safeEncode('input[name="metaData.device.type"]')
        + '&nonce=' + safeEncode('input[name="nonce"]')
        + '&redirect_uri=' + safeEncode('input[name=redirect_uri]')
        + '&response_mode=' + safeEncode('input[name="response_mode"]')
        + '&response_type=' + safeEncode('input[name=response_type]')
        + '&scope=' + safeEncode('input[name=scope]')
        + '&state=' + safeEncode('input[name=state]')
        + '&tenantId=' + safeEncode('input[name=tenantId]')
        + '&timezone=' + safeEncode('input[name=timezone]')
        + '&user_code=' + safeEncode('input[name="user_code"]');

    // This map will be parameter name and value (already extracted from the DOM)
    // - Assuming the parameter name does not need escaping.
    if (additionalFields) {
      Object.keys(additionalFields).forEach(function(key) {
        var value = additionalFields[key];
        if (Prime.Utils.isDefined(value)) {
          state += '&' + key + '=' + encodeURIComponent(value);
        }
      });
    }

    // It should not be necessary to encode this Base64 encoded string, but it should not hurt.
    return encodeURIComponent(FusionAuth.IdentityProvider.Helper.base64URLEncode(state));
  }
};