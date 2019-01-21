var express = require('express');
var fs = require('fs');
var $stmt;

const sqlite3 = require('better-sqlite3');
const json = JSON.stringify;

module.exports = function(settings) {
  var router = express.Router();
  var Database = new sqlite3(settings.databaseFile);
  
  function postMessage(res, success, message, status) {
    if (status) { res.status(status); }
    res.send(json({
      success: success,
      message: message
    }));
  }
  
  settings.startupQueries.forEach(function(v, i) {
    Database.prepare(v).run();
  });
  
  router.post("/run", function(req, res) {
    if (req.headers["apitoken"] == settings.ApiToken) {
      var bindParameters = [];
      if (req.body.bindparam != null) {
        if (req.body.bindparam instanceof Array) {
          bindParameters = req.body.bindparam;
        }
      }
      if (req.body.query != null) {
        try {
          $stmt = Database.prepare(req.body.query);
          $stmt.bind(...bindParameters);
        
          $stmt.run();
          postMessage(res, true);
        } catch (e) {
          res.status(400);
          res.send(json({
            success: false,
            message: "SQL query failed",
            error: e.message
          }));
        }
      } else {
        postMessage(res, false, "Please specify a query.", 400);
      }
    } else {
      postMessage(res, false, "Unauthorized", 401);
    }
  });
  
  router.post("/get", function(req, res) {
    if (req.headers['apitoken'] == settings.ApiToken) {
      var bindParameters = [];
      if (req.body.bindparam != null) {
        if (req.body.bindparam instanceof Array) {
          bindParameters = req.body.bindparam;
        }
      }
      if (req.body.query != null) {
        try {
          $stmt = Database.prepare(req.body.query);
          $stmt.bind(...bindParameters);
        
          var vals = $stmt.all();
          res.send(json({
            success: true,
            response: vals
          }));
        } catch (e) {
          res.status(400);
          res.send(json({
            success: false,
            message: "SQL query failed",
            error: e.message
          }));
        }
      } else {
        postMessage(res, false, "Please specify a query.", 400);
      }
    } else {
      postMessage(res, false, "Unauthorized", 401);
    }
  });
  
  return router;
}
