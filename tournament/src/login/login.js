// import React, { useState } from "react";
// import { Link, Redirect } from 'react-router-dom';
// import axios from 'axios';
// import { useAuth } from "./Auth";

// function Login(props) {
//     const [isLoggedIn, setLoggedIn] = useState(false);
//     const [isError, setIsError] = useState(false);
//     const [userName, setUserName] = useState("");
//     const [password, setPassword] = useState("");
//     const { setAuthTokens } = useAuth();

//     const referer = props.location.state ? props.location.state.referer : '/';

//     function postLogin() {
//         axios.post("https://myapi.com/login.php", {
//             userName,
//             password
//         }).then(result => {
//             if (result.status === 200) {
//                 setAuthTokens(result.data);
//                 setLoggedIn(true);
//                 console.log(result.data);
//             } else {
//                 setIsError(true);
//             }
//         }).catch(e => {
//             setIsError(true);
//             console.log(e);
//         });
//     }

//     if (isLoggedIn) {
//         return <Redirect to={referer} />;
//     }
//     return (
//         <input type="username" value={userName} onChange={e=>{ setUserName(e.target.value); }} placeholder="username"
//              />
//         <input type="password" value={password} onChange={e=>{ setPassword(e.target.value); }} placeholder="password"
//              />
//         <input type="submit" onClick={postLogin}>Sign In</Button>
//         { isError&& <div>The username or password provider were incorrect.</div>}
//  );
// }

// export default Login;