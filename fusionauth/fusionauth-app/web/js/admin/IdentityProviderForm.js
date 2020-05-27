/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the add and edit Identity Provider form. The row table is managed by the ExpandableTable object.
 *
 * @constructor
 */
FusionAuth.Admin.IdentityProviderForm = function(type) {
  Prime.Utils.bindAll(this);

  switch (type) {
    case 'OpenIDConnect':
      this._setupOpenIdConnect();
      break;
    case 'SAMLv2':
      this._setupSAMLv2();
      break;
    case 'ExternalJWT':
      this._setupJWTType();
      break;
  }

  // For everything except the red headed step child
  if (type !== 'ExternalJWT') {
    this._attachApplicationEvents();
    this._expandOverrides();
  }
};

FusionAuth.Admin.IdentityProviderForm.constructor = FusionAuth.Admin.IdentityProviderForm;
FusionAuth.Admin.IdentityProviderForm.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _attachApplicationEvents: function() {
    // Attach override toggles
    Prime.Document.query('.slide-open-toggle').each(function(toggle) {
      toggle.addEventListener('click', this._handleOverrideClick)
    }.bind(this));
  },

  _expandOverrides: function() {
    var localStorage = Prime.Storage.getSessionObject('identityProvider.overrides') || {};
    for (var key in localStorage) {
      if (localStorage.hasOwnProperty(key)) {
        var target = Prime.Document.queryById(key);
        if (target !== null) {
          var icon = Prime.Document.queryFirst('[data-expand-open="' + key + '"]').queryFirst('i.fa');
          if (localStorage[key] === 'open') {
            icon.addClass('open');
            target.addClass('open');
          }
        }
      }
    }
  },

  _setupOpenIdConnect: function() {
    new FusionAuth.UI.TextEditor(Prime.Document.queryFirst('textarea[name="domains"]'))
        .withOptions({
          'mode': 'properties',
          'lineNumbers': true,
        })
        .render()
        .setHeight(100);

    this.openIdIssuer = Prime.Document.queryFirst('input[name="identityProvider.oauth2.issuer"]');
    this.useOpenIdDiscovery = Prime.Document.queryById('useOpenIdDiscovery').addEventListener('change', this._handleUserOpenIdDiscoveryChange);

    this.openIdIssuerSlideOpen = this.openIdIssuer.queryUp('.slide-open');
    this.openIdIssuerSlideOpen._open = this.useOpenIdDiscovery.isChecked();

    this.clientAuthenticationMethodSelector = Prime.Document.queryById('identityProvider_oauth2_clientAuthenticationMethod');
    if (this.clientAuthenticationMethodSelector != null) {
      this.openIdClientSecret = new Prime.Effects.SlideOpen(Prime.Document.queryById('openid-client-secret'));
      this.clientAuthenticationMethodSelector.addEventListener('change', this._handleClientAuthenticationMethodChange);
    }
  },

  _setupSAMLv2: function() {
    new FusionAuth.UI.TextEditor(Prime.Document.queryFirst('textarea[name="domains"]'))
        .withOptions({
          'mode': 'properties',
          'lineNumbers': true
        })
        .render()
        .setHeight(100);
  },

  _handleOverrideClick: function(event) {
    Prime.Utils.stopEvent(event);

    var toggle = new Prime.Document.Element(event.currentTarget); // currentTarget is the <a> the event was bound to
    var target = Prime.Document.queryById(toggle.getDataAttribute("expandOpen"));

    var localStorage = Prime.Storage.getSessionObject('identityProvider.overrides') || {};
    var storageKey = target.getId();

    var icon = toggle.queryFirst('i.fa');
    if (target.hasClass('open')) {
      icon.removeClass('open');
      localStorage[storageKey] = 'closed';
      new Prime.Effects.SlideOpen(target).toggle();
    } else {
      icon.addClass('open');
      localStorage[storageKey] = 'open';
      new Prime.Effects.SlideOpen(target).toggle();
    }

    Prime.Storage.setSessionObject('identityProvider.overrides', localStorage);
  },

  _handleClientAuthenticationMethodChange: function() {
    if (this.clientAuthenticationMethodSelector.getValue() !== 'none') {
      this.openIdClientSecret.open();
    } else {
      this.openIdClientSecret.close();
    }
  },

  _handleUserOpenIdDiscoveryChange: function() {
    if (this.openIdIssuerSlideOpen._open) {
      this.openIdIssuer.setDisabled(true);
      this.openIdIssuerSlideOpen._open = false;
    } else {
      this.openIdIssuer.setDisabled(false);
      this.openIdIssuerSlideOpen._open = true;
    }
  },

  _setupJWTType: function() {
    this.form = Prime.Document.queryById('identity-provider-form');
    this.addIdentityProvider = this.form.getAttribute('action') === '/admin/identity-provider/add';
    this.domainEditor = new FusionAuth.UI.TextEditor(this.form.queryFirst('textarea[name="domains"]'))
        .withOptions({
          'mode': 'properties',
          'lineNumbers': true,
        });

    // Add Claims
    this.claimTable = Prime.Document.queryById('claims-map-table');
    this.expandableClaimTable = new FusionAuth.UI.ExpandableTable(this.claimTable);

    this.claimDataSet = null;
    Prime.Document.queryById('add-claim').addEventListener('click', this._handleAddClaimClick);

    new Prime.Widgets.Tabs(Prime.Document.queryFirst('.tabs'))
        .withErrorClassHandling('error')
        .withLocalStorageKey(this.addIdentityProvider ? null : 'settings.identity-provider.external-jwt.tabs')
        .withSelectCallback(this._handleTabSelect)
        .initialize();
  },

  _getDataFromClaimForm: function() {
    var form = this.claimDialog.element.queryFirst('form');
    var data = {};
    data.incomingClaim = form.queryFirst('input[name="incomingClaim"]').getValue();
    data.fusionAuthClaim = form.queryFirst('select[name="fusionAuthClaim"]').getValue();
    return data;
  },

  _handleAddClaimClick: function(event) {
    Prime.Utils.stopEvent(event);

    this.claimDataSet = null;
    var anchor = new Prime.Document.Element(event.currentTarget);
    this.claimDialog = new Prime.Widgets.AJAXDialog()
        .withCallback(this._handleAddClaimDialogOpenSuccess)
        .withFormHandling(true)
        .withFormErrorCallback(this._handleAddClaimDialogOpenSuccess)
        .withFormSuccessCallback(this._handleAddClaimFormSuccess)
        .open(anchor.getAttribute('href') + '?identityProviderId=' + anchor.getAttribute('identityProviderId'));
  },

  _handleAddClaimFormSuccess: function() {
    var data = this._getDataFromClaimForm();

    var row = null;
    this.claimTable.query('tbody tr').each(function(r) {
      if (r.getDataSet().incomingClaim === data.incomingClaim) {
        row = r;
      }
    });

    if (row === null) {
      row = this.expandableClaimTable.addRow(data);
    }

    var dataSet = row.getDataSet();
    dataSet.incomingClaim = data.incomingClaim;
    dataSet.fusionAuthClaim = data.fusionAuthClaim;

    this._replaceClaimFieldValues(data);

    // Finally close the dialog
    this.claimDialog.close();
  },

  _handleAddClaimDialogOpenSuccess: function(dialog) {
    if (this.claimDataSet !== null) {
      dialog.element.queryFirst('input[name="incomingClaim"]').setValue(this.claimDataSet.incomingClaim);
      dialog.element.queryFirst('select[name="fusionAuthClaim"]').setValue(this.claimDataSet.fusionAuthClaim);
    }

    dialog.element.queryFirst('input[name="incomingClaim"]').focus();
  },

  /**
   * Handles the tab selection and enables CodeMirror on the Data Definition tab.
   *
   * @param {Object} tab The &lt;li&gt; tab element that was selected.
   * @param {Object} tabContent The &lt;div&gt; that contains the tab contents.
   * @private
   */
  _handleTabSelect: function(tab, tabContent) {
    if (tabContent.getId() === 'domains') {
      this.domainEditor.render();
    }
  },

  /**
   * Need to move the updated data-XXX attributes into the row, otherwise the edits won't get passed to the action.
   */
  _replaceClaimFieldValues: function(data) {
    var input = Prime.Document.queryById('identityProviders.claimMap_' + data.incomingClaim);
    input.setValue(data.fusionAuthClaim);

    input.queryUp('td').getNextSibling().setHTML(data.fusionAuthClaim);
  }
};
