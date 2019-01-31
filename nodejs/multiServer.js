// If you do not specify these options, the variables below will be used. //
var default_ApiToken = "";
var default_DefaultQueries = [];



const expressMod = require("./expressModule.js");

var express = require('express');
var bodyParser = require('body-parser');
var app = express();
app.use(bodyParser.json());

app.all("/", function(req, res) {
  res.send("Well, hello there Wanderer!");
});





var list = app.listen(PORT, function() {
  console.log('Server Online, Port ' + list.address().port);
});
