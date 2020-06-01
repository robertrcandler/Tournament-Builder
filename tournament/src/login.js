import React from 'react'


// Get the modal
var modal = document.getElementById('id01');

// When the user clicks anywhere outside of the modal, close it
window.onclick = function(event) {
    if (event.target == modal) {
        modal.style.display = "none";
    }
}

export const login = () => (
  <div>
        <h2>Login</h2>
        <button onclick="document.getElementById('login').style.display='block'" style="width:auto;">Login</button>

        <div id="login" class="modal">
    
            <form class="modal-content animate" action="/action_page.php" method="post">
                <div class="container">
                    <label for="uname"><b>Username</b></label>
                    <input type="text" placeholder="Enter Username" name="uname" required>

                    <label for="psw"><b>Password</b></label>
                    <input type="password" placeholder="Enter Password" name="psw" required>
                    
                    <button type="submit">Login</button>
                </div>
            </form>
        </div>
  </div>
)
