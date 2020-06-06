import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/models/_.dart';

abstract class DeviceRepository {
  Future<List<Device>> fetchDevices(String topic, String payload);
  Device putDevice(String topic, String payload);
}

class LocalDeviceRepository extends DeviceRepository {
  @override
  Future<List<Device>> fetchDevices(String topic, String payload) {
    return Future.delayed(Duration(seconds: 1), () {
      final random = Random();

      // Simulate some network error
      if (random.nextBool()) {
        throw NetworkError();
      }

      var noDevices = random.nextInt(10);

      return List.generate(
        noDevices,
        (index) => Device(
          id: 1000 + index,
          position: Position(
            longitude: random.nextDouble() * 0.1 + 106.6,
            latitude: random.nextDouble() * 0.1 + 10.7,
            timestamp: DateTime.now(),
          ),
          status: random.nextBool() ? Power.On : Power.Off,
        ),
      );
    });
  }

  @override
  Device putDevice(String topic, String payload) {}
}

class NetworkError extends Error {}
