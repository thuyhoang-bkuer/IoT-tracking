var express = require('express');
var mongoose = require('mongoose');

mongoose.connect(process.env.MONGO_URL);

var app = express();
var port = 3000;
app.get('/', (req, res) => res.send('Hello World'));
app.listen(port, function(){
	console.log('Server listening on port ' + port)
});
