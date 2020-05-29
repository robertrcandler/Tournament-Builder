//this file is used for messaging between client and server
//instructions below
//https://fusionauth.io/blog/2020/03/10/securely-implement-oauth-in-react
module.exports = {
    // OAuth info (copied from the FusionAuth admin panel)
    clientID: '85a03867-dccf-4882-adde-1a79aeec50df',
    clientSecret: 'JNlTw3c9B5NrVhF-cz3m0fp_YiBg-70hcDoiQ2Ot30I',
    redirectURI: 'http://localhost:9000/oauth-callback',
    applicationID: '85a03867-dccf-4882-adde-1a79aeec50df',
  
    // our FusionAuth api key
    apiKey: 'o9WngMh2AAp3zH7gvMYtML9sGG31A9xVY1bi3Oui-_Y',
  
    // ports
    clientPort: 8080,
    serverPort: 9000,
    fusionAuthPort: 9011
  };