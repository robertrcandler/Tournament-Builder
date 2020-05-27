/*
 * Copyright (c) 2018, FusionAuth, All Rights Reserved
 */
var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};
'use strict';

/**
 * Defines an expandable table. The table element must be passed in. The table element must have 2 data attributes:
 *
 * data-add-button - this defines the ID of the add button that is used to add rows to the table
 * data-template - this defines the ID of the Handlebars template script tag used to add the new rows
 *
 * @param {Object} table The table element.
 * @constructor
 */
FusionAuth.UI.ExpandableTable = function(table) {
  Prime.Utils.bindAll(this);

  this.table = table;
  this.addCallback = null;
  this.addCallbackContext = null;
  this.deleteCallback = null;
  this.deleteCallbackContext = null;

  // Get the table body and add button
  this.tableBody = this.table.queryFirst('tbody');
  var addButtonId = this.table.getDataAttribute('addButton');
  if (addButtonId !== null) {
    this.addButton = Prime.Document.queryById(addButtonId);
    if (this.addButton === null) {
      throw 'Invalid data-add-button attribute on the <table> element. A button with an id of [' + addButtonId + '] doesn\'t exist';
    }
    this.addButton.addEventListener('click', this._handleAddClickEvent);
  } else {
    this.addButton = null;
  }

  // Get the template
  var templateId = this.table.getDataAttribute('template');
  if (templateId === null) {
    throw 'Missing data-template attribute on the <table> element';
  }
  var templateElement = Prime.Document.queryById(templateId);
  if (templateElement === null) {
    throw 'Invalid data-template attribute on the <table> element';
  }
  this.template = Handlebars.compile(templateElement.getHTML());

  // Get the empty row
  this.emptyRow = this.table.queryFirst('.empty-row');
  if (this.emptyRow === null) {
    throw 'Missing an empty-row <tr>';
  }

  // Delete buttons
  Prime.Document.query('a.delete-button', this.tableBody).each(function(e) {
    e.addEventListener('click', this._handleDeleteClickEvent);
  }.bind(this));

  // Empty row
  this.rowCount = Prime.Document.query('tbody > tr', this.tableBody).length - 1;
  if (this.rowCount > 0) {
    this.emptyRow.hide();
  }

  this._registerHelpers();
};

FusionAuth.UI.ExpandableTable.constructor = FusionAuth.UI.ExpandableTable;
FusionAuth.UI.ExpandableTable.prototype = {
  /**
   * Adds a new row using the Handlebars template for the table.
   *
   * @return {Prime.Document.Element} The newly added row.
   */
  addRow: function() {
    var data = {};

    // Add the table data
    var tableDataSet = this.table.getDataSet();
    for (var key in tableDataSet) {
      if (tableDataSet.hasOwnProperty(key)) {
        data[key] = tableDataSet[key];
      }
    }

    // Add the row index
    data.index = this.rowCount++;

    // Assume any extra data passed in comes from a single object argument
    if (arguments.length === 1) {
      for (var arg in arguments[0]) {
        if (arguments[0].hasOwnProperty(arg)) {
          data[arg] = arguments[0][arg];
        }
      }
    }

    var newRowHTML = this.template(data);
    this.tableBody.appendHTML(newRowHTML);
    this.emptyRow.hide();

    var rows = this.tableBody.getChildren('tr');
    var row = rows[rows.length - 1];
    var input = row.queryFirst('input');
    if (input !== null) {
      input.focus();
    }

    var deleteButton = row.queryFirst('a.delete-button');
    if (deleteButton !== null) {
      deleteButton.addEventListener('click', this._handleDeleteClickEvent);
    }

    if (this.addCallback !== null) {
      this.addCallback(row);
    }

    return row;
  },

  /**
   * Deletes the given row.
   *
   * @param row {Prime.Document.Element} The element.
   * @return {FusionAuth.UI.ExpandableTable} This.
   */
  deleteRow: function(row) {
    if (this.deleteCallback !== null) {
      this.deleteCallback(row);
    }

    row.removeFromDOM();
    if (Prime.Document.query('tbody > tr', this.tableBody).length === 1) {
      this.emptyRow.show();
    }

    return this;
  },

  /**
   * @param callback {Function} The callback function that is called when a row is added. This function is passed the
   * row as Prime.Document.Element.
   * @return {FusionAuth.UI.ExpandableTable} This.
   */
  withAddCallback: function(callback) {
    this.addCallback = callback;
    return this;
  },

  /**
   * @param callback {Function} The callback function that is called when a row is deleted. This function is passed the
   * row as Prime.Document.Element.
   * @return {FusionAuth.UI.ExpandableTable} This.
   */
  withDeleteCallback: function(callback) {
    this.deleteCallback = callback;
    return this;
  },

  /**
   * Handles the click event on the add button.
   *
   * @private
   */
  _handleAddClickEvent: function(event) {
    this.addRow();
    Prime.Utils.stopEvent(event);
  },

  /**
   * Handles the click event on the delete button.
   *
   * @param event The event.
   * @private
   */
  _handleDeleteClickEvent: function(event) {
    var row = Prime.Document.queryUp('tr', event.currentTarget);
    this.deleteRow(row);
    Prime.Utils.stopEvent(event);
  },

  _registerHelpers: function() {
    // Empty string, null, etc --> &hellip;
    Handlebars.registerHelper('default_if_empty', function(value) {
      if (value === null || value.length === 0) {
        return new Handlebars.SafeString("&ndash;");
      }

      if (Array.isArray(value)) {
        return value.join(", ");
      } else {
        return value;
      }
    });
  }
};
