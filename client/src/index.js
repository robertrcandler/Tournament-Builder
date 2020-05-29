import React from 'react';
import ReactDOM from 'react-dom';
import './index.css';

const config = require('../../config');

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
    };
  }

  render() {
    return (
      <div id='App'>
        <header>
          <h1>FusionAuth Example: React</h1>
        </header>
      </div>
    );
  }
}

ReactDOM.render(<App/>, document.querySelector('#Container'));

// ...

import Greeting from './components/Greeting.js';

class App extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      email: 'dinesh@fusionauth.io'
    };
  }

  render() {
    return (
      <div id='App'>
        <header>
          <h1>FusionAuth Example: React</h1>
          <Greeting email={this.state.email}/>
        </header>
      </div>
    );
  }
}

// ...

this.state = {
  // email: 'dinesh@fusionauth.io'
};

// ...

constructor(props) {
  super(props);
  this.state = {
    body: {} // this is the body from /user
  };
}

render() {
  return (
    <div id='App'>
      <header>
        <h1>FusionAuth Example: React</h1>
        <Greeting body={this.state.body}/>
      </header>
    </div>
  );
}

// ...
