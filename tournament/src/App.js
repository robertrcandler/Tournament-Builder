import React from 'react';
import './App.css';
// import '../node_modules/uikit/css/uikit.css'

function App() {
  return (
    <div className="App">
      <header className="App-header">
      <nav className="uk-navbar-container uk-navbar-transparent" uk-navbar="mode: click">
      {/* <!-- Logo --> */}
      <div className="uk-navbar-left">
        <a className="logo-text uk-navbar-item uk-logo" href="/">Tournament Finder</a>
      </div>
      {/* <!-- Menu --> */}
      <div className="uk-navbar-right">
        {/* <!-- Menu for desktop size screens --> */}
        <ul className="desktopMenu-toggle uk-navbar-nav">
          <li><a className="nav-link" href="/resources">Home</a></li>
          <li><a className="nav-link" href="#">Game Search</a></li>
          <div className="uk-navbar-item">
            <a href="/login"><button className="uk-button uk-button-default" id="login">Log in</button></a>
          </div>
        </ul>
        {/* <!-- Menu for mobile size screens --> */}
        <ul className="mobileMenu-toggle uk-navbar-nav">
          <li className="mobile-menu">
            <div className="menu-icon uk-flex uk-flex-center" uk-icon="icon: menu"></div>
            <div className="uk-navbar-dropdown">
              <ul className="uk-nav uk-navbar-dropdown-nav">
                <li><a href="/resources">Home</a></li>
                <li><a href="#">Game Search</a></li>
                <li className="uk-nav-divider"></li>
                <li><a className="logoutLink" href="/login">Log in</a></li>
              </ul>
            </div>
          </li>
        </ul>
      </div>
    </nav>
  </header>
    </div>
  );
}

export default App;
