/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
'use strict';
var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Base class for search objects.
 *
 * @constructor
 */
FusionAuth.Admin.BaseUserSearch = function(container, storageKey) {
  this.container = container;
  this.storageKey = storageKey;
  this.errorDialog = new Prime.Widgets.HTMLDialog(Prime.Document.queryById('error-dialog')).initialize();
  this.inProgress = new Prime.Widgets.InProgress(this.container.queryUp('.panel')).withMinimumTime(250);
};

FusionAuth.Admin.BaseUserSearch.prototype = {
  /**
   * Saves the current search criteria.
   */
  saveCriteria: function() {
    Prime.Storage.setSessionObject(this.storageKey, this.searchCriteria);
  },

  /**
   * Executes the search using the current search criteria in local storage.
   */
  search: function() {
    Prime.Document.queryFirst('.bulk-actions').hide();
    Prime.Document.queryFirst('[data-number-selected]').hide();

    new Prime.Ajax.Request('/ajax/user/search', 'GET')
        .withData(this.searchCriteria)
        .withInProgress(this.inProgress)
        .withSuccessHandler(this._handleAJAXFormSuccess)
        .withErrorHandler(this._handleAJAXError)
        .go();
  },

  /**
   * Sets the default sort (first column ascending).
   */
  setDefaultSort: function() {
    this.searchCriteria = {
      's.sortFields[0].name': 'login',
      's.sortFields[0].order': 'asc',
      's.sortFields[1].name': 'fullName',
      's.sortFields[1].order': 'asc'
    };
  },

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleAJAXError: function(xhr) {
    if (xhr.status === 503 || xhr.status === 401) {
      location.reload();
    } else {
      this._handleAJAXFormSuccess(xhr);

      var dialog = Prime.Document.queryById('search-errors');
      if (dialog !== null) {
        // Render the page as normal and show the dialog
        new Prime.Widgets.HTMLDialog(dialog)
            .initialize()
            .open();
      } else {
        // Show a dialog
        this.errorDialog.open();
      }
    }
  },

  _handleAJAXFormSuccess: function(xhr) {
    // Try to keep the current scroll position after an AJAX load.
    var scrollTop = document.body.scrollTop;
    this.container.setHTML(xhr.responseText);

    if (this.rawQueryPre) {
      var rawQuery = this.container.queryFirst('input[type="hidden"]')
                         .getValue().replace('<', '&lt;').replace('>', '&gt;');
      var isJson = false;
      try {
        JSON.parse(rawQuery);
        isJson = true;
      } catch (error) {}
      this.rawQueryLabel.setHTML(isJson ? this.rawQueryLabel.getDataAttribute('labelJson') : this.rawQueryLabel.getDataAttribute('labelString'));
      this.rawQueryPre.setHTML(rawQuery);
    }

    // The minimal delay allows us to keep the scroll position.
    setTimeout(function() {
      document.body.scrollTop = scrollTop;
    }, 0);

    // Setup the listing
    this.table = this.container.queryFirst('table');
    new FusionAuth.UI.Listing(this.table)
        .withCheckEventCallback(this._handleCheckEventCallback)
        .initialize();

    // Pagination
    this.container.query('.pagination').each((function(pagination) {
      pagination.query('a').addEventListener('click', this._handlePaginationClicks);
      pagination.queryFirst('select').addEventListener('change', this._handlePaginationChange);
    }).bind(this));

    // Sort
    this.table.query('[data-sort]').addEventListener('click', this._handleColumnClick);

    // Handle cell click to select checkbox
    this.table.addEventListener('click', this._handleTableClick);
  },

  _handleCheckEventCallback: function(state) {
    var bulkActions = Prime.Document.queryFirst('.bulk-actions');
    var numberSelected = Prime.Document.queryFirst('[data-number-selected]');

    if (state.checkedCount === 0) {
      bulkActions.query('a').addClass('disabled');
      this.table.removeClass('checkboxes');
      numberSelected.hide();
    } else {
      bulkActions.show().setStyle('display', 'inline-block');
      bulkActions.query('a').removeClass('disabled');
      this.table.addClass('checkboxes');
      numberSelected.show().queryFirst('em').setHTML(state.checkedCount);
    }
  },

  _handleColumnClick: function(event) {
    var target = new Prime.Document.Element(event.target);
    // may be a select all checkbox, let it pass.
    if (!target.is('th, a')) {
      return;
    }

    Prime.Utils.stopEvent(event);
    var th = new Prime.Document.Element(event.currentTarget);

    // Toggle Ascending / Descending if we're clicking on the same sort field column
    var sortFields = th.getDataAttribute('sort').split(',');
    var sortOrder = 'asc';
    if (this.searchCriteria['s.sortFields[0].name'] === sortFields[0]) {
      if (this.searchCriteria['s.sortFields[0].order'] === 'asc') {
        sortOrder = 'desc';
      }
    }

    this.searchCriteria['s.sortFields[0].name'] = sortFields[0];
    this.searchCriteria['s.sortFields[0].order'] = sortOrder;
    this.searchCriteria['s.sortFields[1].name'] = sortFields[1];
    this.searchCriteria['s.sortFields[1].order'] = sortOrder;

    this.saveCriteria();
    this.search();
  },

  _handlePaginationChange: function() {
    var target = new Prime.Document.Element(event.currentTarget);
    this.searchCriteria['s.numberOfResults'] = target.getSelectedValues()[0];
    this.searchCriteria['s.startRow'] = 0;
    this.saveCriteria();
    this.search();
  },

  _handlePaginationClicks: function(event) {
    Prime.Utils.stopEvent(event);

    var target = new Prime.Document.Element(event.currentTarget);
    var url = target.getAttribute('href').substr(1);
    var index = url.indexOf('=');
    var key = url.substr(0, index);
    this.searchCriteria[key] = url.substr(index + 1);
    this.saveCriteria();
    this.search();
  },

  _handleTableClick: function(event) {
    var target = new Prime.Document.Element(event.target);
    if (target.is('td.icon')) {
      target.queryFirst('input[type="checkbox"]').fireEvent('click');
    }
  }
};
