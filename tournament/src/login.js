import React from 'react';

function login() {
    // Name and Password from the register-form
    var nm = document.getElementById('nm');
    var pw = document.getElementById('pw');
    
    // storing input from register-form
    function store() {
        localStorage.setItem('nm', nm.value);
        localStorage.setItem('pw', pw.value);
    }

    // check if stored data from register-form is equal to entered data in the   login-form
    function check() {

        // stored data from the register-form
        var storedName = localStorage.getItem('nm');
        var storedPw = localStorage.getItem('pw');

        // entered data from the login-form
        var userName = document.getElementById('userName');
        var userPw = document.getElementById('userPw');

        // check if stored data from register-form is equal to data from login form
        if(userName.value == storedName && userPw.value == storedPw) {
            alert('You are logged in.');
        }else {
            alert('ERROR.');
        }
    }


  return (
    <div>
        <form id="register-form"> 
            <input id="nm" type="text" placeholder="Name" value=""/>
            <input id="pw" type="password" placeholder="Password" value=""/>
            <input id="rgstr_btn" type="submit" value="get Account" onClick="store()"/> 
        </form>

        <form id="login-form"> 
            <input id="userName" type="text" placeholder="Enter Username" value=""/>
            <input id="userPw" type="password" placeholder="Enter Password" value=""/>
            <input id="login_btn" type="submit" value="Login" onClick="check()"/> 
       </form>

    </div>
  );
}

export default login;
