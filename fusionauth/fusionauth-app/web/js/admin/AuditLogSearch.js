/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the audit log search.
 *
 * @param element the form
 * @constructor
 */
FusionAuth.Admin.AuditLogSearch = function(element) {
  Prime.Utils.bindAll(this);

  this.form = element;
  this.numberOfResults = this.form.queryFirst('input[name="s.numberOfResults"]');

  this.form.query('.date-time-picker').each(function(e) {
    new Prime.Widgets.DateTimePicker(e).initialize();
  });

  // Pagination - rows per page changes.
  var auditLogSection = Prime.Document.queryById('system-audit-content');
  auditLogSection.query('.pagination').each(function(element) {
    element.queryFirst('select').addEventListener('change', this._handlePaginationChange);
  }.bind(this));

  new FusionAuth.UI.AdvancedControls(this.form, 'io.fusionauth.auditLog.advancedControls').initialize();

  this.search = this.form.queryFirst('input[name="q"]');
  this.userInput = this.form.queryFirst('input[name="s.user"]');
  if (this.search !== null) {
    this.inProgress = new Prime.Widgets.InProgress(this.search).withMinimumTime(250);
    new FusionAuth.UI.AutoComplete(this.search)
        .withInputAvailableCallback(this._userSearch)
        .withSelectValueCallback(this._handleSelectValue)
        .withClearValueCallback(this._handleClearInput)
        .initialize();
  }
};

FusionAuth.Admin.AuditLogSearch.constructor = FusionAuth.Admin.AuditLogSearch;
FusionAuth.Admin.AuditLogSearch.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleClearInput: function() {
    this.search.setValue('');
    this.userInput.setValue('');
  },

  _handlePaginationChange: function(event) {
    var target = new Prime.Document.Element(event.currentTarget);
    this.numberOfResults.setValue(target.getValue());
    this.form.domElement.submit();
  },

  _handleSelectValue: function(value, display) {
    this.search.setValue(display);
    this.userInput.setValue(value);
  },

  _searchSuccessHandler: function(xhr, callback) {
    var json = JSON.parse(xhr.responseText);
    var html = '';

    if (json.total > 0) {
      for (var i=0; i < json['users'].length; i++) {
        var name = json['users'][i].firstName || '';
        if (name) {
          name += ' ';
        }

        name += json['users'][i].lastName || '';
        if (!name) {
          name += json['users'][i].fullName || '';
        }

        var loginId = json['users'][i].email || '';
        if (loginId) {
          name +=  ' &lt;' + loginId + '&gt;'
        } else {
          loginId = json['users'][i].username || '';
          if (loginId) {
            name += ' &lt;' + loginId + '&gt;'
          }
        }

        html += '<a href="#" data-display="' + name + '" data-value="' + loginId + '">' + name + '</a>';
      }
    } else {
      html += '<a href="#" class="disabled">  No users found  </a>';
    }

    callback(html);
  },

  _searchErrorHandler: function(xhr, callback) {
    callback('<a href="#" class="disabled">  An error occurred, unable to complete search. Status code <em>' + xhr.status + '</em>. </a>')
  },

  _userSearch: function(value, callback) {
    var searchCriteria = {};
    searchCriteria['s.numberOfResults'] = 50;
    searchCriteria['s.startRow'] = 0;
    searchCriteria['s.queryString'] = value;

    new Prime.Ajax.Request('/ajax/user/search.json', 'GET')
        .withData(searchCriteria)
        .withInProgress(this.inProgress)
        .withSuccessHandler(function(xhr) {
          this._searchSuccessHandler(xhr, callback);
        }.bind(this))
        .withErrorHandler(function(xhr) {
          this._searchErrorHandler(xhr, callback);
        }.bind(this))
        .go();
  },
};