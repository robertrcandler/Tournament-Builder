/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * @constructor
 */
FusionAuth.Admin.TenantForm = function() {
  Prime.Utils.bindAll(this);

  this.form =  Prime.Document.queryById('tenant-form');
  this.addTenant = this.form.getAttribute('action') === '/admin/tenant/add';
  this.smtpEditor = null;
  this.smtpErrorEditor = null;

  new FusionAuth.UI.AdvancedControls(this.form, 'io.fusionauth.tenant.codeGeneratorDescription').initialize();

  new Prime.Widgets.Tabs(Prime.Document.queryFirst('.tabs'))
      .withErrorClassHandling('error')
      .withSelectCallback(this._handleTabSelect)
      .withLocalStorageKey(this.addTenant ? null : 'settings.tenant.tabs')
      .initialize();

  this.childRegistrationCheckbox = this.form.queryFirst('input[name="tenant.familyConfiguration.allowChildRegistrations"]').addEventListener('change', this._handleChildRegistrationChange);
  this.noChildRegistrationDiv = new Prime.Effects.SlideOpen(Prime.Document.queryById('no-child-registration'));
  this.childRegistrationDiv = new Prime.Effects.SlideOpen(Prime.Document.queryById('child-registration'));

  this.failedAuthenticationUserAction = Prime.Document.queryById('tenant_failedAuthenticationConfiguration_userActionId').addEventListener('change', this._handleFailedAuthenticationUserActionChange);
  this.failedAuthenticationSettings = new Prime.Effects.SlideOpen(Prime.Document.queryById('failed-authentication-options'));

  this.sendTestEmailButton = Prime.Document.queryById('send-test-email').addEventListener('click', this._handleSMTPTestClick);
};

FusionAuth.Admin.TenantForm.prototype = {

  /* ===================================================================================================================
   * Private Methods
   * ===================================================================================================================*/

  _handleChildRegistrationChange: function() {
    if (this.childRegistrationCheckbox.isChecked()) {
      this.noChildRegistrationDiv.close();
      this.childRegistrationDiv.open();
    } else {
      this.noChildRegistrationDiv.open();
      this.childRegistrationDiv.close();
    }
  },

  _handleFailedAuthenticationUserActionChange: function() {
    if (this.failedAuthenticationUserAction.getValue() === '') {
      this.failedAuthenticationSettings.close();
    } else {
      this.failedAuthenticationSettings.open();
    }
  },

  _handleSMTPTestClick: function(event) {
    Prime.Utils.stopEvent(event);

    var anchor = new Prime.Document.Element(event.target);
    this.smtpTestDialog = new Prime.Widgets.AJAXDialog()
        .withCallback(this._handleSMTPTestDialogOpen)
        .withAdditionalClasses('wide')
        .open(anchor.getAttribute('href'));
  },

  _handleSMTPTestDialogOpen: function() {
    // On open wire up the submit button and focus the first field, intentionally not using the default form handler.
    this.smtpTestDialog.element.queryFirst('form').addEventListener('submit', this._handleSMPTTestFormSubmit);
    this.smtpTestDialog.element.queryFirst('input[type="text"]').focus();
  },

  _handleSMPTTestFormSubmit: function(event) {
    Prime.Utils.stopEvent(event);
    Prime.Document.queryById('smtp-sent-ok').addClass('hidden');

    // Sync the Advanced SMTP properties so they'll get picked up in the form data
    if (this.smtpEditor !== null) {
      this.smtpEditor.sync();
    }

    var email = this.smtpTestDialog.element.queryFirst('input[name="email"]').getValue();
    var submitButton = this.smtpTestDialog.element.queryFirst('button');
    var submitIcon = this.smtpTestDialog.element.queryFirst('button i');
    submitIcon.removeClass('fa-arrow-right')
        .addClass('fa-spinner fa-spin fa-fw');
    submitButton.addClass('disabled').setAttribute('disabled', 'disabled');

    new Prime.Ajax.Request('/ajax/tenant/smtp/test?email=' + encodeURIComponent(email), 'POST')
        .withDataFromForm(this.form)
        .withSuccessHandler(this._handleSMTPTestSuccess)
        .withErrorHandler(this._handleSMTPTestError)
        .go();
  },

  _handleSMTPTestSuccess: function(xhr) {
    var submitButton = this.smtpTestDialog.element.queryFirst('button');
    var submitIcon = this.smtpTestDialog.element.queryFirst('button i');
    submitButton.removeClass('disabled').removeAttribute('disabled');
    submitIcon.removeClass('fa-spinner fa-spin')
              .addClass('fa-arrow-right');

    if (xhr.status === 200) {
      var response = JSON.parse(xhr.responseText);
      var errorResponse = Prime.Document.queryById('smtp-error-response');
      if (response.message) {
        errorResponse.removeClass('hidden');
        if (this.smtpErrorEditor !== null) {
          this.smtpErrorEditor.destroy();
        }

        this.smtpErrorEditor = new FusionAuth.UI.TextEditor(Prime.Document.queryById('smtp-error-textarea'))
            .withOptions({
              'readOnly': true,
              'lineNumbers': true
            })
            .render()
            .setHeight(100);

        this.smtpErrorEditor.setValue(response.message);
      } else {
        Prime.Document.queryById('smtp-sent-ok').removeClass('hidden');
      }
    }
  },

  _handleSMTPTestError: function(xhr) {
    this.smtpTestDialog.setHTML(xhr.responseText);
  },

  _handleTabSelect: function(tab, tabContent) {
    if (tabContent.getId() === 'advanced-configuration') {
      var smtpProperties = Prime.Document.queryFirst('textarea[name="tenant.emailConfiguration.properties"]');
      if (this.smtpEditor === null) {
        this.smtpEditor = new FusionAuth.UI.TextEditor(smtpProperties)
            .withOptions({
              'mode': 'properties',
              'lineNumbers': true
            })
            .render()
            .setHeight(100);
      }
    }
  }
};
