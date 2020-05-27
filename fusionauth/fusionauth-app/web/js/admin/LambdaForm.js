/*
 * Copyright (c) 2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the lambda form by setting up an ExpandableTable for the headers.
 *
 * @constructor
 */
FusionAuth.Admin.LambdaForm = function(element) {
  Prime.Utils.bindAll(this);

  this.element = Prime.Document.Element.wrap(element);

  // Setup the type select box
  this.currentType = null;
  this.typeSelect = Prime.Document.queryFirst('select[name="lambda.type"]');
  if (this.typeSelect !== null) {
    this.typeSelect.addEventListener('change', this._handleTypeChange);
    this.currentType = this.typeSelect.getSelectedValues()[0];
  }

  // Setup the editor
  this.bodyTextarea = element.queryFirst('textarea[name="lambda.body"]');
  this.bodyEditor = new FusionAuth.UI.TextEditor(this.bodyTextarea)
      .withOptions({
        'gutters': ['CodeMirror-lint-markers'],
        'lint': true,
        'lineWrapping': true,
        'mode': 'text/javascript',
        'tabSize': 2
      })
      .render();

  this._handleTypeChange();
};

FusionAuth.Admin.LambdaForm.constructor = FusionAuth.Admin.LambdaForm;
FusionAuth.Admin.LambdaForm.prototype = {

  /* ===================================================================================================================
   * Private methods
   * ===================================================================================================================*/

  _handleTypeChange: function() {
    this.bodyEditor.sync();

    if (this.currentType !== null) {
      // Determine if the user has changed the value of the lambda body
      var oldExampleText = Prime.Document.queryById(this.currentType).getHTML().replace(/\s*/g, '');
      var value = this.bodyTextarea.getValue().replace(/\s*/g, '');

      this.currentType = this.typeSelect.getSelectedValues()[0];
      if (value === '' || value === oldExampleText) {
        var newExampleText = Prime.Document.queryById(this.currentType).getHTML();
        this.bodyEditor.setValue(newExampleText);
      }
    }
  }
};
