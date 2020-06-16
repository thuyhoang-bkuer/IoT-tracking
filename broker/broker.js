// MQTT Broker
var mosca = require('mosca');

const config = {
	port: 1883
}

const broker = mosca.Server(config);

broker.on('ready', () => {
	console.log(`Broker is listening on ${JSON.stringify(config)}`);
});

broker.on('clientConnected', (client) => {
	console.log(`Client ${client.id} connected!`);
});

broker.on('published', function(packet, client) {
  console.log('Published', packet.payload.toString());
});