var mqtt = require('mqtt');

// WebSocket connect url
const WebSocket_URL = 'ws://localhost:8083/mqtt'

// TCP/TLS connect url
const TCP_URL = 'mqtt://localhost:1883'
const TCP_TLS_URL = 'mqtts://localhost:8883'

// Topics
const mobileTopic = 'Topic/GPS'
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
	gps[deviceId] = gps[deviceId].map(item => item + (Math.random() - 0.5) * 0.007);
	return gps[deviceId];
}


const master = mqtt.connect(TCP_URL, options)
const device_0 = mqtt.connect(TCP_URL, options)
const device_1 = mqtt.connect(TCP_URL, options)


var timer_0;
var timer_1;
var gps = [
	[10.7, 106.6],
	[10.75, 106.5]
];

// after connect
master.on('connect', () => {
	console.log('[Master] Connected to', TCP_URL)

	master.subscribe(mobileTopic, (err) => {
		console.log(err || '[Master] Subscribe Success')
	})
})

device_0.on('connect', () => {
	console.log('[Device 0] Connected to', TCP_URL)

	device_0.subscribe(mobileTopic, (err) => {
		console.log(err || '[Device 0] Subscribe Success')
	})
})

device_1.on('connect', () => {
	console.log('[Device 1] Connected to', TCP_URL)

	device_1.subscribe(mobileTopic, (err) => {
		console.log(err || '[Device 1] Subscribe Success')
	})
})



// handle message event
master.on('message', (topic, message) => {
	console.log('Received form', topic, ':', message.toString('utf-8'))

	const req = JSON.parse(message.toString());

	if (topic === mobileTopic) {
		if (req.action === 'request/device/list') {
			const res = {
				action: 'response/device/list',
				data: [{
						id: '1000',
						name: 'GPS-1'
					},
					{
						id: '1001',
						name: 'GPS-2'
					}
				]
			}

			master.publish(mobileTopic, JSON.stringify(res), {
				qos: 1,
				rein: false
			}, (error) => {
				console.log(error || `${req.action} - publish Success`)
			})
		}
	}
})

device_0.on('message', (topic, message) => {
	console.log('Received form', topic, ':', message.toString())

	const req = JSON.parse(message.toString());

	if (topic === mobileTopic) {
		if (req.action === 'request/device/gps') {
			timer_0 = setInterval(() => {
				const res = {
					action: 'response/device/gps',
					id: '1000',
					data: generateGPS(0)
				}
				master.publish(mobileTopic, JSON.stringify(res), {
					qos: 1,
					rein: false
				}, (error) => {
					console.log(error || `[Device 0]${req.action} - publish Success`)
				})
			}, 5000)
		}
		else if (req.action === 'request/disconnect') {
			clearInterval(timer_0)
		}
	}
})

device_1.on('message', (topic, message) => {
	console.log('Received form', topic, ':', message.toString())

	const req = JSON.parse(message.toString());

	if (topic === mobileTopic) {
		if (req.action === 'request/device/gps') {
		
			timer_1 = setInterval(() => {
				const res = {
					action: 'response/device/gps',
					id: '1001',
					data: generateGPS(1)
				}
				master.publish(mobileTopic, JSON.stringify(res), {
					qos: 1,
					rein: false
				}, (error) => {
					console.log(error || `[Device 1]${req.action} - publish Success`)
				})
			}, 4000)
		}
		else if (req.action === 'request/disconnect') {
			clearInterval(timer_1)
		}
	}
})