var sys = require('sys')
var exec = require('child_process').exec;
var spawn = require('child_process').spawn;
var fs = require('fs');
var io = require('socket.io').listen(8000, { log: false });
var express = require('express');

var filePath = "scratch.js"

var onConnection = function (socket) {
  var d8CB = function(srr, stdout, stderr){
    socket.emit('new_code', { code: stdout });
  };
  var onMessage = function(data){
    fs.writeFileSync(filePath, data.code);
    exec("./d8 --code-comments --print-code " + filePath, d8CB);
  };
  socket.on("new_source", onMessage);
};

io.sockets.on('connection', onConnection);

var app = express();

app.get('/', function(req, res){
  res.sendfile("./index.html");
});

app.use(express.static('client'));
app.listen(3000);
