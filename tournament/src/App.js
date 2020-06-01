import React, { Component } from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import  Home  from './Home';
import  Games  from './Games';
import login from './login';
import { Contact } from './Contact';
import { NoMatch } from './NoMatch';
import { Layout } from './components/Layout';
import { NavigationBar } from './components/NavigationBar';
import { Jumbotron } from './components/Jumbotron';

class App extends Component {
  render() {
    return (
      
      <React.Fragment>
        <Router>
          <NavigationBar />
          <Jumbotron />
          <Layout>
            <Switch>
              
              <Route exact path="/" component={Home} />
              <Route path="/games" component={Games} />
              <Route path="/contact" component={Contact} />
              <Route path="/Login" component={login} />
              <Route component={NoMatch} />
            </Switch>
          </Layout>
        </Router>
      </React.Fragment>
    );
  }
}

export default App;
