(function(){
   
const useMultiServer = false;

if (useMultiServer) {
   require("multiServer.js");
   return ""; // Stop further execution
}

const PORT = process.env.PORT; // I highly recommend against port 80 if you are hosting this under your own VPS (or other machine as such)

const databaseFile = './.data/rbx-sqlite3-db011.db'; // If you need to reset EVERYTHING, you can change this.


const ApiToken = "USE A PASSWORD GENERATOR"; // Highly recommended: https://www.grc.com/passwords.htm

const startupQueries = [
   // ex: "CREATE TABLE IF NOT EXISTS banned_users (username VARCHAR(50) PRIMARY KEY, userid INT NOT NULL, reason VARCHAR(50) NOT NULL)"
]
/*
  SETTINGS ABOVE
*/

const expressMod = require("./expressModule.js");

var express = require('express');
var bodyParser = require('body-parser');
var app = express();
app.use(bodyParser.json());

app.use("/", expressMod({ // ability to store several databases on the same url
  databaseFile: databaseFile,
  ApiToken: ApiToken,
  startupQueries: startupQueries
}));

app.all("/", function(req, res) {
  res.send("Well, hello there Wanderer!");
});

var list = app.listen(PORT, function() {
  console.log('Server Online, Port ' + list.address().port);
});
   
})();
