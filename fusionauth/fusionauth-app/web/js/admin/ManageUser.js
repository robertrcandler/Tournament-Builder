/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * JavaScript for the manage user page.
 *
 * @constructor
 * @param userId {string} the user id.
 */
FusionAuth.Admin.ManageUser = function(userId) {
  Prime.Utils.bindAll(this);

  // Last Login table
  this.userId = userId;
  new FusionAuth.Admin.LastLogins(this.userId);

  this.tabs = new Prime.Widgets.Tabs(Prime.Document.queryFirst('.tabs'))
      .withErrorClassHandling('error')
      .withLocalStorageKey('user.manage.tabs')
      .initialize();

  // Attach a delegated listener to all the ajax forms anchors
  Prime.Document.addDelegatedEventListener('click', '[data-ajax-form="true"], [data-ajax-view="true"]', this._handleActionClick);

  // Custom User Data
  new FusionAuth.Admin.UserData(Prime.Document.queryById('user-data')).initialize();
};

FusionAuth.Admin.ManageUser.constructor = FusionAuth.Admin.ManageUser;
FusionAuth.Admin.ManageUser.prototype = {

  /* ===================================================================================================================
   * Private Methods
   * ===================================================================================================================*/

  _handleActionUserDialogOpen: function() {
    new FusionAuth.Admin.UserActioningForm(Prime.Document.queryById('user-actioning-form'));
  },

  _handleAddConsentDialogOpen: function() {
    new FusionAuth.Admin.AddUserConsentForm(Prime.Document.queryById('add-user-consent-form'));
  },

  _handleActionClick: function(event) {
    Prime.Utils.stopEvent(event);
    var button = new Prime.Document.Element(event.target);
    if (!button.is('a')) {
      button = button.queryUp('a');
    }

    var uri = button.getAttribute('href');

    if (uri.indexOf('/ajax/user/consent/add') !== -1) {
      new Prime.Widgets.AJAXDialog()
          .withFormHandling(true)
          .withCallback(this._handleAddConsentDialogOpen)
          .withFormErrorCallback(this._handleAddConsentDialogOpen)
          .withAdditionalClasses(button.is('[data-ajax-wide-dialog=true]') ? 'wide' : '')
          .open(uri);
    } else if (uri.indexOf('/ajax/user/action') === -1 && uri.indexOf('/ajax/user/modify-action') === -1) {
      var formHandling = uri.indexOf("/view") === -1; // if this isn't a view ajax, it has a form
      new Prime.Widgets.AJAXDialog()
          .withFormHandling(formHandling)
          .withAdditionalClasses(button.is('[data-ajax-wide-dialog=true]') ? 'wide' : '')
          .open(uri);
    } else {
      new Prime.Widgets.AJAXDialog()
          .withFormHandling(true)
          .withCallback(this._handleActionUserDialogOpen)
          .withFormErrorCallback(this._handleActionUserDialogOpen)
          .withAdditionalClasses(button.is('[data-ajax-wide-dialog=true]') ? 'wide' : '')
          .open(uri);
    }
  }
};