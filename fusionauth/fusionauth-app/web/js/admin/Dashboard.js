/*
 * Copyright (c) 2018-2019, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.Admin = FusionAuth.Admin || {};

/**
 * Handles the dashboard.
 *
 * @constructor
 */
FusionAuth.Admin.Dashboard = function(labels, data) {
  Prime.Utils.bindAll(this);

  this.element = document.getElementById('login-chart');

  this.loginChartData = {
    type: 'line',
    data: {
      labels: labels,
      datasets: [{
        label: '# of Logins',
        data: data,
        backgroundColor: FusionAuth.UI.Colors.toRGBA(FusionAuth.UI.Colors.greenMedium, 0.2),
        borderColor: FusionAuth.UI.Colors.toRGBA(FusionAuth.UI.Colors.greenMedium, 1),
        borderWidth: 1
      }]
    },
    options: {
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        yAxes: [{
          ticks: {
            beginAtZero: true
          }
        }]
      }
    }
  };


  var panel = Prime.Document.queryById('hourly-logins');
  this.loginChart = new  FusionAuth.UI.Chart(panel)
      .withLocalStorageKey('dashboard.login-chart')
      .withConfiguration(this.loginChartData)
      .initialize();

  // Setup the proxy report callback
  this.proxyReportPanel = Prime.Document.queryById('proxy-report-result');
  Prime.Window.addEventListener('message', this._handleProxyReportResult);
};

FusionAuth.Admin.Dashboard.constructor = FusionAuth.Admin.Dashboard;
FusionAuth.Admin.Dashboard.prototype = {
  _handleProxyReportResult: function(event) {
    this.proxyReportPanel.setHTML(event.data);
  }
};
