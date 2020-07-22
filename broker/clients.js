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

function generateGPS(deviceId) {
	gps[deviceId] = gps[deviceId].map((p, i) => p + target[deviceId][i] * (Math.random() - 0.2) * 0.007);
	return gps[deviceId];
}


const master = mqtt.connect(TCP_URL, options)
const device_0 = mqtt.connect(TCP_URL, options)
const device_1 = mqtt.connect(TCP_URL, options)


var timer_0;
var timer_1;
var gps = [
	[10.822456, 106.6382113], // Airport
	[10.77062, 106.655525] // BK Campus 1
];

var dst = [
	[10.7759925, 106.6941289], // Walking Park
	[10.87695, 106.7847747] // BK Campus 2
]

var target = [
	[10.7759925 - 10.822456, 106.6941289 - 106.6382113],
	[10.87695 - 10.77062, 106.7847747 - 106.655525]
]

// // after connect
// master.on('connect', () => {
// 	console.log('[Master] Connected to', TCP_URL)

// 	master.subscribe(gpsTopic, (err) => {
// 		console.log(err || '[Master] Subscribe Success')
// 	})
// })

device_0.on('connect', () => {
	console.log('[Device 0] Connected to', TCP_URL)

	device_0.subscribe(gpsTopic, (err) => {
		console.log(err || '[Device 0] Subscribe Success')
	})


	timer_0 = setInterval(() => {
		const res = {
			action: 'response/device/gps',
			device_id: 'GPS1000',
			name: 'GPS 0',
			values: generateGPS(0)
		}
		device_0.publish(gpsTopic, JSON.stringify(res), {
			qos: 1,
			rein: false
		}, (error) => {
			console.log(error || `[Device 0] publish Success`)
			console.log(res)
		})
	}, 12000)

})

device_1.on('connect', () => {
	console.log('[Device 1] Connected to', TCP_URL)

	device_1.subscribe(gpsTopic, (err) => {
		console.log(err || '[Device 1] Subscribe Success')
	})

	timer_1 = setInterval(() => {
		const res = {
			action: 'response/device/gps',
			device_id: 'GPS1001',
			values: generateGPS(1)
		}
		device_1.publish(gpsTopic, JSON.stringify(res), {
			qos: 1,
			rein: false
		}, (error) => {
			console.log(error || `[Device 1] publish Success`)
			console.log(res)
		})
	}, 10000)
})



// handle message event
// master.on('message', (topic, message) => {
// 	console.log('Received form', topic, ':', message.toString('utf-8'))

// 	const req = JSON.parse(message.toString());

// 	if (topic === gpsTopic) {
// 		if (req.action === 'request/device/list') {
// 			const res = {
// 				action: 'response/device/list',
// 				data: [{
// 						id: '1000',
// 						name: 'GPS-1'
// 					},
// 					{
// 						id: '1001',
// 						name: 'GPS-2'
// 					}
// 				]
// 			}

// 			master.publish(gpsTopic, JSON.stringify(res), {
// 				qos: 1,
// 				rein: false
// 			}, (error) => {
// 				console.log(error || `${req.action} - publish Success`)
// 			})
// 		}
// 	}
// })

// device_0.on('message', (topic, message) => {
// 	console.log('Received form', topic, ':', message.toString())

// 	const req = JSON.parse(message.toString());

// 	if (topic === gpsTopic) {
// 		timer_0 = setInterval(() => {
// 			const res = {
// 				action: 'response/device/gps',
// 				device_id: 'GPS1000',
// 				values: generateGPS(0)
// 			}
// 			device_0.publish(gpsTopic, JSON.stringify(res), {
// 				qos: 1,
// 				rein: false
// 			}, (error) => {
// 				console.log(error || `[Device 0]${req.action} - publish Success`)
// 			})
// 		}, 5000)
// 	}
// })

// device_1.on('message', (topic, message) => {
// 	console.log('Received form', topic, ':', message.toString())

// 	const req = JSON.parse(message.toString());

// 	if (topic === gpsTopic) {
// 		timer_1 = setInterval(() => {
// 			const res = {
// 				action: 'response/device/gps',
// 				device_id: 'GPS1001',
// 				values: generateGPS(1)
// 			}
// 			device_1.publish(gpsTopic, JSON.stringify(res), {
// 				qos: 1,
// 				rein: false
// 			}, (error) => {
// 				console.log(error || `[Device 1]${req.action} - publish Success`)
// 			})
// 		}, 4000)
// 	}
// })