/*
 * Copyright (c) 2020, FusionAuth, All Rights Reserved
 */
'use strict';

var FusionAuth = FusionAuth || {};
FusionAuth.UI = FusionAuth.UI || {};

FusionAuth.UI.Main = {
  initialize: function() {
    // Delegate tooltip initialization, we could also move all of this into the ToolTip widget.
    Prime.Document.addDelegatedEventListener('mouseover', '[data-tooltip]', function(event, target) {
      if (typeof (target.toolTipObject) === 'undefined') {
        target.toolTipObject = new Prime.Widgets.Tooltip(target).withClassName('tooltip').initialize();
      }
    });

    // Debounce all toggles to keep them from going cray-cray.
    Prime.Document.query('label.toggle').each(function(e) {
      e.addEventListener('click', function() {
        // Debounce the switch yo!
        e.setStyle('pointer-events', 'none');
        setTimeout(function() {
          e.setStyle('pointer-events', null);
        }, 700);
      });
    });

    Prime.Document.query('[data-slide-open]').each(function(e) {
      e.addEventListener('change', function() {
        var dataSet = e.getDataSet();
        var element = Prime.Document.queryById(dataSet.slideOpen);
        if (typeof (element.slideOpenObject) === 'undefined') {
          element.slideOpenObject = new Prime.Effects.SlideOpen(element);
        }

        if (dataSet.slideOpenValue) {
          if (e.getValue() === dataSet.slideOpenValue) {
            element.slideOpenObject.open();
          } else {
            element.slideOpenObject.close();
          }
        } else {
          element.slideOpenObject.toggle();
        }

        // Allow two separate sections, one to be opened, and the other to be closed in unison
        if (dataSet.slideClosed) {
          var slideClosed = Prime.Document.queryById(dataSet.slideClosed);
          if (typeof (element.slideClosedObject) === 'undefined') {
            element.slideClosedObject = new Prime.Effects.SlideOpen(slideClosed);
          }

          element.slideClosedObject.toggle();
        }
      });
    });

    Prime.Document.query('.multiple-select').each(function(e) {
      new Prime.Widgets.MultipleSelect(e)
          .withCustomAddEnabled(true)
          .withErrorClassHandling('error')
          .withRemoveIcon('')
          .initialize();
    });

    Prime.Document.query('.alert').each(function(e) {
      var dismissButton = e.queryFirst('a.dismiss-button');
      if (dismissButton !== null) {
        new Prime.Widgets.Dismissable(e, dismissButton).initialize();
      }
    });

    // For example if this is a clean install, no need to show them what is new, but if it is an upgrade we could show them what is new since they installed?
    Prime.Document.query('.what-is-new').each(function(e) {
      var dismissButton = e.queryFirst('a.dismiss');
      if (dismissButton !== null) {
        new Prime.Widgets.Dismissable(e, dismissButton).initialize();
        dismissButton.addEventListener('click', function() {

          var checkbox = e.queryFirst('input[type="checkbox"]');
          if (checkbox !== null && checkbox.isChecked()) {
            // Expecting this cookie to always exist, but it is possible the initial page render won't go through the /admin/ path due to a
            // save request. On initial load, grab the current version of the what is new cookie.
            var initialVersionCookie = ("; " + document.cookie).split('; fusionauth.wn=').pop().split(";").shift();
            var whatsNew = initialVersionCookie === '' ? {} : JSON.parse(atob(initialVersionCookie));
            whatsNew.hide = whatsNew.hide || [];

            var versions = e.getDataAttribute('versions').split(",");
            for (var i = 0; i < versions.length; i++) {
              whatsNew.hide.push(versions[i]);
            }

            // Using the same age as we set in the backend using Java Max Int (2^31 -1)
            document.cookie = 'fusionauth.wn=' + btoa(JSON.stringify(whatsNew)) + '; path=/; Max-Age=' + (Math.pow(2, 31) -1) + ';';
          }
        });
      }
    });

    var sideBar = Prime.Document.queryFirst('.app-sidebar-toggle');
    if (sideBar !== null) {
      new FusionAuth.Admin.UserSearchBar();
      new Prime.Widgets.SideMenu(Prime.Document.queryFirst('.app-sidebar-toggle'), Prime.Document.queryFirst('.app-sidebar'))
          .withOptions({
            'closedClass': 'app-sidebar-closed',
            'openClass': 'app-sidebar-open'
          })
          .initialize();

      new Prime.Widgets.TreeView(Prime.Document.queryFirst('.treeview')).withFolderToggleClassName('folder-toggle').initialize();
    }

    // Handle the focus for widgets
    Prime.Document.query('input').each(function(input) {
      input.addEventListener('focus', function(event) {
        new Prime.Document.Element(event.target).getParent().addClass('focus');
      }).addEventListener('blur', function(event) {
        new Prime.Document.Element(event.target).getParent().removeClass('focus');
      });
    });

    // Handle vertical scroll so we can preserve the page header, especially on long moderation queues
    var header = Prime.Document.queryFirst('header.page-header');

    function _handlePageScroll() {
      if (window.pageYOffset >= stickyHeight) {
        header.addClass('sticky');
      } else {
        header.removeClass('sticky');
      }
    }

    if (header !== null) {
      window.onscroll = _handlePageScroll;
      // app header height is 45
      var stickyHeight = header.getOffsetTop() - 45;
    }

    // Wire up SplitButtons
    Prime.Document.query('.split-button').each(function(sb) {
      new Prime.Widgets.SplitButton(sb).initialize();
    });
  }
};

Prime.Document.onReady(FusionAuth.UI.Main.initialize);
