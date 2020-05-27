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
        // console.log(response.data.results);
        totaldata.push(response.data.results);
        // console.log(totaldata);
        //make new file with info
        fs.writeFile("GameDatabase200.json", JSON.stringify(totaldata), function(
            err
          ) {
            if (err) {
              return console.log(err);
            }
            console.log(i);
          });
        })
        .catch((error)=>{
        console.log(error)
        })
}

//make loop for pagination
for (var j = 0; j < 200; j++) {
    runapi(j);
  }
