var mqtt = require('mqtt');

// WebSocket connect url
const WebSocket_URL = 'ws://52.148.117.13:8083/mqtt'

// TCP/TLS connect url
const TCP_URL = 'mqtt://52.148.117.13:1883'
const TCP_TLS_URL = 'mqtts://52.148.117.13:8883'

// Topics
const gpsTopic = 'Topic/GPS'
const deviceTopic = 'Topic/Device'


const options = {
	connectTimeout: 60000,
	// Authentication
	// clientId: 'iot-testing',
	// username: 'emqx',
	// password: 'emqx',
	keepalive: 60,
	clean: true,
}

const device_0 = mqtt.connect(TCP_URL, options)

let tanbinh = [106.6655463,10.8008899]
let phunhuan = [106.6892523,10.7988019]
let quan1 = [106.6953704,10.7770401]
let quan3 = [106.677016,10.7821841]
let quan10 = [106.6596598,10.7745797]

let tour = [tanbinh, phunhuan, quan1, quan3, quan10]
let idx = 0

let generateGPS = () => [tour[idx % 5][0].toString(), tour[idx++ % 5][1].toString()]

let timer_0 = setInterval(() => {
    const res = {
        action: 'response/device/gps',
        device_id: 'Circle',
        name: 'Flyweight',
        values: generateGPS()
    }
    device_0.publish(gpsTopic, JSON.stringify(res), {
        qos: 1,
        rein: false
    }, (error) => {
        console.log(error || `[Device 0] publish Success`)
        console.log(res)
    })
    console.log(res)
}, 5000)