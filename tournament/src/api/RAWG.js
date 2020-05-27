const axios = require("axios");
var fs = require("fs");

var totaldata = [];

function runapi(i) {
    axios({
        "method":"GET",
        "url":"https://rawg-video-games-database.p.rapidapi.com/games",
        "headers":{
        "content-type":"application/octet-stream",
        "x-rapidapi-host":"rawg-video-games-database.p.rapidapi.com",
        "x-rapidapi-key":"11d931da08mshfac0a12ea31c4fep18a5a0jsnd94363ca9ef8",
        "useQueryString":true,
        "page":i
        }
        })
        .then((response)=>{
        console.log(response)
        })
        .catch((error)=>{
        console.log(error)
        })
}