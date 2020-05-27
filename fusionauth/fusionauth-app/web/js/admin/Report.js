/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Creates a new Report.
 *
 * @constructor
 * @param {Prime.Document.Element} element the container element of the report form
 */
FusionAuth.Admin.Report = function(element, name) {
  Prime.Utils.bindAll(this);

  this.element = element;
  this.name = name;
  this.date = new Date(); // Default to now
  this.form = this.element.queryFirst('form');
  this.intervalSelect = this.form.queryFirst('select[name=interval]');
  this.intervalHidden = this.form.queryFirst('input[name=interval]');
  this.applicationSelect = Prime.Document.queryById('applicationId').addEventListener('change', this._handleChangeEvent);

  this.search = this.form.queryFirst('input[name="q"]');
  this.userIdInput = this.form.queryFirst('input[name="userId"]');
  if (this.search !== null) {
    this.inProgress = new Prime.Widgets.InProgress(this.search).withMinimumTime(250);
    new FusionAuth.UI.AutoComplete(this.search)
        .withInputAvailableCallback(this._userSearch)
        .withSelectValueCallback(this._handleSelectValue)
        .withClearValueCallback(this._handleClearInput)
        .initialize();
  }

  if (this.intervalSelect !== null) {
    this.intervalSelect.addEventListener('change', this._handleChangeEvent);
  }

  this.prevAnchor = Prime.Document.queryFirst('.report-controls a:first-of-type').addEventListener('click', this._handleClickEvent);
  Prime.Document.queryFirst('.report-controls a:last-of-type').addEventListener('click', this._handleClickEvent);
  this.dateSpan = Prime.Document.queryFirst('.report-controls span');

  this.chart = null;

  this._setInitialOptions();
};

FusionAuth.Admin.Report.prototype = {

  initialize: function() {
    this.refresh();
  },

  refresh: function() {
    var data = {
      'applicationId': this.applicationSelect.getSelectedValues()[0],
      'interval': (this.intervalSelect !== null ? this.intervalSelect.getSelectedValues()[0] : this.intervalHidden.getValue()),
      'instant': this.date.getTime()
    };

    if (this.userIdInput !== null && this.userIdInput.getValue() !== '') {
      data.userId = this.userIdInput.getValue();
    }

    new Prime.Ajax.Request(this.form.getAttribute('action'), 'GET')
        .withData(data)
        .withSuccessHandler(this._handleRefreshSuccess)
        .withErrorHandler(this._handleError)
        .go()
  },

  _handleSelectValue: function(value, display) {
    this.userIdInput.setValue(value);
    this.search.setValue(display);
    this.refresh();
  },

  _handleClearInput: function() {
    this.userIdInput.setValue('');
    this.search.setValue('');
    this.refresh();
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

  withLocalStoragePrefix: function(prefix) {
    this.options['localStorageKeyPrefix'] = prefix;
    return this;
  },

  _handleChangeEvent: function(event) {
    this.refresh();
    Prime.Utils.stopEvent(event);
  },

  _handleClickEvent: function(event) {
    var forward = this.prevAnchor.domElement !== event.currentTarget;
    var interval = this.intervalSelect !== null ? this.intervalSelect.getSelectedValues()[0] : this.intervalHidden.getValue();
    if (interval === 'Hourly') {
      Prime.Date.plusDays(this.date, (forward ? 1 : -1));
    } else if (interval === 'Daily') {
      Prime.Date.plusMonths(this.date, (forward ? 1 : -1));
    } else if (interval === 'Monthly') {
      Prime.Date.plusYears(this.date, (forward ? 1 : -1));
    } else if (interval === 'Yearly') {
      Prime.Date.plusYears(this.date, (forward ? 1 : -1));
    }

    this.refresh();
    Prime.Utils.stopEvent(event);
  },

  _handleError: function(xhr) {
    if (xhr.status === 401) {
      location.reload();
    } else {
      alert('Unexpected error. Try refreshing the page');
    }
  },

  _handleRefreshSuccess: function(xhr) {
    var reportData = JSON.parse(xhr.responseText);
    this.dateSpan.setHTML(reportData.dateDisplay);

    var chartData = {
      type: 'bar',
      data: {
        labels: reportData.labels,
        datasets: [
          {
            label: this.name,
            data: reportData.data,
            backgroundColor: FusionAuth.UI.Colors.toRGBA(FusionAuth.UI.Colors.greenMedium, 0.2),
            borderColor: FusionAuth.UI.Colors.toRGBA(FusionAuth.UI.Colors.greenMedium, 1),
            borderWidth: 1
          }
        ]
      },
      options: {
        responsive: true,
        maintainAspectRatio: true
      }
    };

    if (this.chart !== null) {
      this.chart.destroy();
    }

    this.chart = new FusionAuth.UI.Chart(this.element)
        .withLocalStorageKey(this.options['localStoragePrefix'] + 'type')
        .withConfiguration(chartData)
        .initialize();
  },

  _searchErrorHandler: function(xhr, callback) {
    callback('<a href="#" class="disabled">  An error occurred, unable to complete search. Status code <em>' + xhr.status + '</em>. </a>')
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
            name +=  ' &lt;' + loginId + '&gt;';
          } else {
            loginId = json['users'][i].username || '';
            if (loginId) {
              name += ' &lt;' + loginId + '&gt;';
            }
          }

          html += '<a href="#" data-display="' + name + '" data-value="' + json['users'][i].id + '">' + name + '</a>';
        }
      } else {
        html += '<a href="#" class="disabled">  No users found  </a>';
      }

      callback(html);
  },

  _setInitialOptions: function() {
    // Defaults
    this.options = {
      'localStoragePrefix': '_report_'
    };

    var userOptions = Prime.Utils.dataSetToOptions(this.form);
    for (var option in userOptions) {
      if (userOptions.hasOwnProperty(option)) {
        this.options[option] = userOptions[option];
      }
    }
  }
};