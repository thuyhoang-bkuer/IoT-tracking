// import MQTT.js
var mqtt = require('mqtt');
// WebSocket connect url
const WebSocket_URL = 'ws://52.148.117.13:8083/mqtt'

// TCP/TLS connect url
const TCP_URL = 'mqtt://52.148.117.13:1883'
const TCP_TLS_URL = 'mqtts://52.148.117.13:8883'
//import polygon check 
var polygonCheck = require('./polygonCheck')
//import mongoose
var mongoose = require('mongoose');
mongoose.connect(process.env.DB_CONNECTION, {useUnifiedTopology: true, useNewUrlParser: true, useCreateIndex: true });
mongoose.connection.once("open", () => console.log("Connected")).on("error", error => {
    console.log("Ur error ", error)
});
//import model
const Policy = require('../models/PrivacyPolicy');
const Place = require('../models/Place');
//option for connecting mqtt
const options = {
      connectTimeout: 4000,

      // Authentication
      clientId: 'emqx1',
      // username: 'emqx',
      // password: 'emqx',

      keepalive: 60,
      clean: true,
}
var deviceId = 1000; //current device, nen de device nay co policy o quan 10
const client = mqtt.connect(TCP_URL, options)
// after connect
client.on('connect', () => {
  console.log('Connected to', TCP_URL)

  client.subscribe('GPS', (err) => {
    console.log(err || 'Subscribe to GPS')
  })

  client.subscribe('LightD', (err) => {
    console.log(err || 'Subscribe to Light')
  })
})

client.on('message', (topic, message) => {
  if(topic == 'GPS'){
    var location = JSON.parse(message.toString()).values;    
    location[0] = parseFloat(location[0])
    location[1] = parseFloat(location[1])
    console.log(location)
    const policy = Policy.findOne({'deviceId': deviceId});
    const listPoints = policy.listPoints;
    var policyCheck = polygonCheck(listPoints,listPoints.length,location)
    if(policyCheck){
      var msg = {"device_id": "LightD", "values": ["0","0"]}
      client.publish('LightD', JSON.stringify(msg), (err) => {
        console.log(err || 'Light is off')
      })
    }else{
      var msg = {"device_id": "LightD", "values": ["1","100"]}
      client.publish('LightD', JSON.stringify(msg), (err) => {
        console.log(err || 'Light is on')
      })
    }
    
    
  }
})



// handle message event
// client.on('message', (topic, message) => {
//   console.log('Received from', topic, ':', message.toString())

// })