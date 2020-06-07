import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:tracking_app/models/_.dart';

abstract class DeviceRepository {
  // Publish messages into IoT server

  // Retrive from database
  Future<List<Device>> fetchDevices();
  // Future<List<Position>> fetchHistory(int deviceId);

  // // Store app's state into database
  // Future<void> putDevice(String topic, String payload);
  // Future<void> putPosition(Device device, Position position);
}

class LocalDeviceRepository extends DeviceRepository {
  @override
  Future<List<Device>> fetchDevices() {
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

  Future<List<Position>> fetchHistory(int deviceId) {
    return Future.delayed(Duration(seconds: 1), () {
      final random = Random();

      // Simulate some network error
      if (random.nextBool()) {
        throw NetworkError();
      }

      var noDevices = random.nextInt(10);
      return List.generate(
        noDevices,
        (index) => Position(
          longitude: random.nextDouble() * 0.001 + 106.6,
          latitude: random.nextDouble() * 0.001 + 10.7,
          timestamp: DateTime.now(),
        ),
      );
    });
  }
}

class NetworkError extends Error {}
