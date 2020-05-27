/*
 * Copyright (c) 2018-2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles AJAX loading of application roles on the User Registration form.
 *
 * @param currentRoles {Array} The current list of roles that the user has.
 * @constructor
 */
FusionAuth.Admin.UserRegistrationForm = function(currentRoles) {
  Prime.Utils.bindAll(this);

  this.form = Prime.Document.queryById('registration-form');
  this.currentRoles = currentRoles;
  this.application = Prime.Document.queryById('registration_applicationId').addEventListener('change', this._handleApplicationChangeEvent);
  this.rolesDiv = Prime.Document.queryById('application-roles');
  this.update();

  this.preferredLanguages = this.form.queryFirst('select[name="registration.preferredLanguages"]');
  if (this.preferredLanguages !== null) {
    new Prime.Widgets.MultipleSelect(this.preferredLanguages)
        .withRemoveIcon('')
        .withCustomAddEnabled(false)
        .withPlaceholder('')
        .initialize();
  }
};

FusionAuth.Admin.UserRegistrationForm.prototype = {
  update: function() {
    var value = this.application.getValue();
    new Prime.Ajax.Request('/ajax/application/roles/' + value + '?render=checkboxList', 'GET')
        .withSuccessHandler(this._handleAJAXSuccess)
        .withErrorHandler(this._handleAJAXError)
        .go();
  },

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleAJAXSuccess: function(xhr) {
    this.rolesDiv.setHTML(xhr.responseText);
    this.rolesDiv.query('input[type=checkbox]').addEventListener('click', this._handleRoleCheckboxClick);

    for (var i = 0; i < this.currentRoles.length; i++) {
      var role = this.currentRoles[i];
      var checkbox =  this.rolesDiv.queryFirst('input[value="' + role + '"]');
      // Assuming if this is a super user role it is the only role they have assigned
      if (checkbox.is('[data-super-role="true"]')) {
        checkbox.fireEvent('click');
      } else {
        checkbox.setChecked(true);
      }
    }

    // Disable if requested
    if (this.rolesDiv.getDataAttribute('disabled') === 'true') {
      this.rolesDiv.query('input').setDisabled(true)
    }
  },

  _handleAJAXError: function(xhr) {
    console.error(xhr.status);
    alert('An unexpected error occurred. Please contact FusionAuth support for assistance');
  },

  /**
   * Handle the Application Change Event
   * @private
   */
  _handleApplicationChangeEvent: function() {
    this.update();
  },

  /**
   * Handles a roles change event.
   * @param event {MouseEvent} The Click Event.
   * @private
   */
  _handleRoleCheckboxClick: function(event) {
    var checkbox = new Prime.Document.Element(event.target);
    var checked = checkbox.isChecked();
    var superRole = checkbox.getDataAttribute('superRole') === 'true';
    if (superRole && checked) {
      this.rolesDiv.query('input[data-super-role="false"]').each(function(checkbox) {
        checkbox.setChecked(false)
                .setDisabled(true);
      });
    } else if (superRole && !checked) {
      this.rolesDiv.query('input[data-super-role="false"]').each(function(checkbox) {
        checkbox.setDisabled(false);
      });
    }
  }
};