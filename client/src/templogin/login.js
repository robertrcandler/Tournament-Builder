import React from 'react'

function login () {
    
    return (
        <div>
            <form>
            <label for="uname"><b>Username</b></label>
            <input type="text" placeholder="Enter Username" name="uname" required></input>

            <label for="psw"><b>Password</b></label>
            <input type="password" placeholder="Enter Password" name="psw" required></input>

            <button type="submit">Login</button>
            </form>
        </div>
    );
}

export default login;