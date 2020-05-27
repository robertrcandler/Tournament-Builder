/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';
var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles advanced AJAX user search tab.
 *
 * @constructor
 */
FusionAuth.Admin.AdvancedUserSearch = function(form, queryString) {
  Prime.Utils.bindAll(this);
  FusionAuth.Admin.BaseUserSearch.apply(this, [Prime.Document.queryById('advanced-search-results'), FusionAuth.Admin.AdvancedUserSearch.STORAGE_KEY]);

  this.form = form.addEventListener('submit', this._handleFormSubmit);
  this.tenantSelect = this.form.queryFirst('select[name="tenantId"]');
  if (this.tenantSelect !== null) {
    this.tenantSelect.addEventListener('change', this._handleTenantChange);
  }

  this.applicationSelect = this.form.queryFirst('select[name="applicationId"]').addEventListener('change', this._handleApplicationChange);
  this.anyApplicationOption = this.applicationSelect.queryFirst('option').getOuterHTML();

  this.roleSelect = this.form.queryFirst('select[name="role"]');
  this.anyRoleOption = this.roleSelect.queryFirst('option').getOuterHTML();

  this.groupSelect = this.form.queryFirst('select[name="groupId"]');
  if (this.groupSelect !== null) {
    this.anyGroupOption = this.groupSelect.queryFirst('option').getOuterHTML();
  }

  this.rawQueryLabel = this.form.queryFirst('#raw-query label');
  this.rawQueryPre = this.form.queryFirst('#raw-query pre');
  this.input = this.form.queryFirst('input[name="queryString"]');
  this.form.query('a[name="reset"]').addEventListener('click', this._handleResetClick);
  this.selectedRole = null;

  // Reset and set the search query if it was passed in (from the global form at the top of the page)
  if (queryString !== null) {
    this.searchCriteria = {};
    this.searchCriteria['s.queryString'] = queryString;
    this.saveCriteria();
    this.input.setValue(queryString).focus();
  } else {
    this.searchCriteria = Prime.Storage.getSessionObject(FusionAuth.Admin.AdvancedUserSearch.STORAGE_KEY);
    if (this.searchCriteria !== null) {
      if (this.searchCriteria['s.queryString']) {
        this.input.setValue(this.searchCriteria['s.queryString']).focus();
      }
      // See _handleRolesRequestSuccess, set the role so we know it should be selected after we
      // retrieve the applications
      if (this.searchCriteria['role']) {
        this.selectedRole = this.searchCriteria['role'];
      }
      if (this.searchCriteria['applicationId']) {
        this.applicationSelect.setSelectedValues(this.searchCriteria['applicationId']);
        this._handleApplicationChange();
      }
      if (this.searchCriteria['groupId']) {
        this.groupSelect.setSelectedValues(this.searchCriteria['groupId']);
      }
      if (this.searchCriteria['tenantId']) {
        this.tenantSelect.setSelectedValues(this.searchCriteria['tenantId']);
      }
    } else {
      this.setDefaultSort();
    }
  }
};

FusionAuth.Admin.AdvancedUserSearch.STORAGE_KEY = 'io.fusionauth.advancedUserSearch';
FusionAuth.Admin.AdvancedUserSearch.prototype = Object.create(FusionAuth.Admin.BaseUserSearch.prototype);

FusionAuth.Admin.AdvancedUserSearch.prototype._handleApplicationChange = function() {
  var applicationId = this.applicationSelect.getValue();
  if (applicationId === '') {
    this.roleSelect.setHTML(this.anyRoleOption);
    return;
  }

  new Prime.Ajax.Request('/ajax/application/roles/' + this.applicationSelect.getValue() + '?render=options', 'GET')
      .withSuccessHandler(this._handleRolesRequestSuccess)
      .withErrorHandler(this._handleAJAXError)
      .go();
};

FusionAuth.Admin.AdvancedUserSearch.prototype._handleFormSubmit = function(event) {
  Prime.Utils.stopEvent(event);

  this.searchCriteria = {};
  this.searchCriteria['s.queryString'] = this.input.getValue();
  this.searchCriteria['applicationId'] = this.applicationSelect.getSelectedValues()[0];
  this.searchCriteria['role'] = this.roleSelect.getSelectedValues()[0];
  this.searchCriteria['groupId'] = this.groupSelect.getSelectedValues()[0];
  if (this.tenantSelect !== null) {
    this.searchCriteria['tenantId'] = this.tenantSelect.getSelectedValues()[0];
  }

  this.saveCriteria();
  this.search();
};

FusionAuth.Admin.AdvancedUserSearch.prototype._handleResetClick = function(event) {
  Prime.Utils.stopEvent(event);
  this.input.setValue('').focus();
  this.setDefaultSort();
  if (this.tenantSelect !== null) {
    this.tenantSelect.setSelectedValues();
  }
  this.applicationSelect.setSelectedValues();
  this.roleSelect.setSelectedValues();
  this.groupSelect.setSelectedValues();
  this.saveCriteria();
  this.search();
};

FusionAuth.Admin.AdvancedUserSearch.prototype._handleRolesRequestSuccess = function(xhr) {
  // Attempt to preserve the selected application role if it still exists in the AJAX response
  this.selectedRole = this.roleSelect.getSelectedValues()[0] || this.selectedRole;
  this.roleSelect.setHTML(this.anyRoleOption + xhr.responseText);
  if (this.selectedRole !== "") {
    var selected = this.roleSelect.queryFirst('option[value="' + this.selectedRole + '"]');
    if (selected !== null) {
      selected.setAttribute('selected', 'selected');
    }
  }
};

/**
 * When the tenant selector changes, retrieve applications for that tenant.
 * @private
 */
FusionAuth.Admin.AdvancedUserSearch.prototype._handleTenantChange = function() {
  var tenantId = this.tenantSelect.getValue();
  new Prime.Ajax.Request('/ajax/application?tenantId=' + tenantId, 'GET')
      .withSuccessHandler(this._handleApplicationRequestSuccess)
      .withErrorHandler(this._handleAJAXError)
      .go();

  new Prime.Ajax.Request('/ajax/group?tenantId=' + tenantId, 'GET')
      .withSuccessHandler(this._handleGroupRequestSuccess)
      .withErrorHandler(this._handleAJAXError)
      .go();
};

FusionAuth.Admin.AdvancedUserSearch.prototype._handleApplicationRequestSuccess = function(xhr) {
  // Attempt to preserve the selected application if it still exists in the AJAX response
  this.selectedApplication = this.applicationSelect.getSelectedValues()[0];
  this.applicationSelect.setHTML(this.anyApplicationOption + xhr.responseText);
  if (this.selectedApplication !== "") {
    var selected = this.applicationSelect.queryFirst('option[value="' + this.selectedApplication + '"]');
    if (selected != null) {
      selected.setAttribute('selected', 'selected');
    }
  }

  this.applicationSelect.fireEvent('change');
};

FusionAuth.Admin.AdvancedUserSearch.prototype._handleGroupRequestSuccess = function(xhr) {
  // Attempt to preserve the selected groupGroupAction.java if it still exists in the AJAX response
  this.selectedGroup = this.groupSelect.getSelectedValues()[0];
  this.groupSelect.setHTML(this.anyGroupOption + xhr.responseText);
  if (this.selectedGroup !== "") {
    var selected = this.groupSelect.queryFirst('option[value="' + this.selectedGroup + '"]');
    if (selected != null) {
      selected.setAttribute('selected', 'selected');
    }
  }
};