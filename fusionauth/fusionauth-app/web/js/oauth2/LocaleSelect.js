/*
 * Copyright (c) 2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.OAuth2 = FusionAuth.OAuth2 || {};

/**
 * @constructor
 */
FusionAuth.OAuth2.LocaleSelect = function(element) {
  Prime.Utils.bindAll(this);

  this.element = element;
  element.addEventListener('change', this._handleChange)
};

FusionAuth.OAuth2.LocaleSelect.constructor = FusionAuth.OAuth2.LocaleSelect;
FusionAuth.OAuth2.LocaleSelect.prototype = {
  _handleChange: function() {
    document.cookie = 'fusionauth.locale=' + this.element.getSelectedValues()[0] + '; path=/';

    // Strip off the parameter if there is one so that it doesn't override the cookie
    var url = document.location.href;
    var index = url.indexOf('locale=');
    if (index >= 0) {
      var indexOfAmp = url.indexOf('&', index + 8);
      if (indexOfAmp > 0) {
        url = url.substring(0, index) + url.substring(indexOfAmp + 1);
      } else {
        url = url.substring(0, index - 1);
      }
    }
    document.location = url;
  }
};
