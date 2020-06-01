import React from 'react';
import { Link } from 'react-router-dom';
import { Nav, Navbar } from 'react-bootstrap';
import styled from 'styled-components';

const Styles = styled.div`
  .navbar {
    background-color: #222;
  }
  a, .navbar-brand, .navbar-nav .nav-link {
    color: #bbb;

    &:hover {
      color: white;
    }
  }
`;

export const NavigationBar = () => (
  <Styles>
    <Navbar expand="lg">
      <Navbar.Brand href="/">TournaFinder</Navbar.Brand>
      <Navbar.Toggle aria-controls="basic-navbar-nav" />
      <Navbar.Collapse id="basic-navbar-nav">
        <Nav className="ml-auto">
          <Nav.Item componentclass='span'>
            
              <Link to="/">Home</Link>
            
          </Nav.Item>

          |
          |
          |
          |

          <Nav.Item componentclass='span'>
            
              <Link to="/games">Games</Link>
            
          </Nav.Item>

          |
          |
          |
          |

          <Nav.Item componentclass='span'>
            
              <Link to="/contact">Contact</Link>
            
          </Nav.Item>

          
          |
          |
          |
          |

          <Nav.Item componentclass='span'>
            
              <Link to="/login">Login</Link>
            
          </Nav.Item>
        </Nav>
      </Navbar.Collapse>
    </Navbar>
  </Styles >
)
