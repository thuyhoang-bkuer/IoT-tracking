// import MQTT.js

// <script src="https://unpkg.com/mqtt/dist/mqtt.min.js"></script>
// const mqtt = require('mqtt')
var mqtt = require("mqtt");
const { stringify } = require("querystring");
// WebSocket connect url
// const WebSocket_URL = "ws://52.148.117.13:8083/mqtt";

// TCP/TLS connect url
const TCP_URL = "mqtt://52.148.117.13:1883";
// const TCP_TLS_URL = "mqtts://52.148.117.13:8883";

const options = {
    connectTimeout: 4000,

    // Authentication
    clientId: "emqx",
    // username: 'emqx',
    // password: 'emqx',

    keepalive: 60,
    clean: true,
};

//publish function

const client = mqtt.connect(TCP_URL, options);
var message = [
    { device_id: "GPS", values: ["10.773137", "106.659903"] },
    { device_id: "GPS", values: ["10.783847", "106.659300"] },
];
var i = 0;

//publish function
function publish(topic, msg) {
    console.log("publishing", msg);
    if (client.connected == true) {
        client.publish(topic, msg, (err) => {
            console.log(`Published to topic: ${topic}`);
            console.log(err || "Send GPS");
        });
        if (i) i = 0;
        else i = 1;
    }
}

// after connect
client.on("connect", () => {
    console.log("Connected to", TCP_URL);

    //  publish('Topic/GPS',JSON.stringify(message[i]));
    var timer_id = setInterval(function () {
        publish("Topic/GPS", JSON.stringify(message[i]), options);
    }, 10000);
});
