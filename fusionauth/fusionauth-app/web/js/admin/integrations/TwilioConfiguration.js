/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};
'use strict';

/**
 * Handles the Twilio Configuration form.
 *
 * @constructor
 */
FusionAuth.Admin.TwilioConfiguration = function() {
  Prime.Utils.bindAll(this);

  this.twilioSettings = Prime.Document.queryById('twilio-enabled-settings');
  this.errorResponse = Prime.Document.queryById('twilio-error-response');
  this.errorEditor = null;
  this.errorMessage = Prime.Document.queryById('twilio-error');
  this.okMessage = Prime.Document.queryById('twilio-ok');

  this.testConfiguration = Prime.Document.queryById('send-test-message').addEventListener('click', this._handleTestClick);
  this.testPhoneNumber = this.testConfiguration.getPreviousSibling();
};

FusionAuth.Admin.TwilioConfiguration.constructor = FusionAuth.Admin.TwilioConfiguration;
FusionAuth.Admin.TwilioConfiguration.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleTestClick: function(event) {
    Prime.Utils.stopEvent(event);

    if (this.testPhoneNumber.getValue() === "") {
      this.testPhoneNumber.addClass('error');
      this.testPhoneNumber.getPreviousSibling().addClass('error');
      return;
    }

    var inProgress = new Prime.Widgets.InProgress(this.testConfiguration.queryUp('.panel')).withMinimumTime(0);
    new Prime.Ajax.Request('/ajax/integration/twilio/test', 'POST')
        .withData({
          'primeCSRFToken' : this.testConfiguration.queryUp('form').queryFirst('input[type="hidden"][name="primeCSRFToken"]').getValue(),
          'testNumber': this.testPhoneNumber.getValue(),
          'configuration.accountSID': this.twilioSettings.queryFirst('input[name="integrations.twilio.accountSID"]').getValue(),
          'configuration.authToken': this.twilioSettings.queryFirst('input[name="integrations.twilio.authToken"]').getValue(),
          'configuration.fromPhoneNumber': this.twilioSettings.queryFirst('input[name="integrations.twilio.fromPhoneNumber"]').getValue(),
          'configuration.messagingServiceSid': this.twilioSettings.queryFirst('input[name="integrations.twilio.messagingServiceSid"]').getValue(),
          'configuration.url': this.twilioSettings.queryFirst('input[name="integrations.twilio.url"]').getValue()
        })
        .withInProgress(inProgress)
        .withSuccessHandler(this._handleTestSuccess)
        .withErrorHandler(this._handleTestFailure)
        .go();
  },

  _handleTestFailure: function(event) {
    if (event.status === 401) {
      location.reload();
    }
  },

  _handleTestSuccess: function(event) {
    var response = JSON.parse(event.responseText);
    if (response.status === 200) {
      this.okMessage.show();
      this.errorMessage.hide();
      if (this.errorEditor !== null) {
        this.errorEditor.destroy();
        this.errorEditor = null;
      }
    } else {
      this.okMessage.hide();
      this.errorMessage.show();
      if (this.errorEditor === null) {
        this.errorEditor = new FusionAuth.UI.TextEditor(this.errorResponse)
            .withOptions({
              'mode': 'xml',
              'readOnly': true,
              'lint': true,
              'lineNumbers': true,
              'gutters': ['CodeMirror-lint-markers']
            })
            .render();
      }
      this.errorEditor.setValue(vkbeautify.xml(response.message || 'No response. Ensure you have filled out the required fields.'));
    }
  }
};