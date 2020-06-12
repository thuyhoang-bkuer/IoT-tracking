import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart';
import 'package:tracking_app/models/_.dart';

abstract class DeviceRepository {
  // Publish messages into IoT server

  // Retrive from database
  Future<List<Device>> fetchDevices();
  Future<History> fetchHistory(String deviceId);
  Future<void> postPosition(String deviceId, Position position);

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
          id: (1000 + index).toString(),
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
  Future<History> fetchHistory(String deviceId) async {
    final jsonData = await rootBundle.loadString('assets/storage/history.json');
    final jsonMap = json.decode(jsonData);

    final history = History.fromJson(jsonMap);

    return Future.delayed(Duration(seconds: 3), () {
      // final random = Random();
      // // Simulate some network error
      // if (random.nextBool()) {
      //   throw NetworkError();
      // }

      return history;
    });
  }

  @override
  Future<void> postPosition(String deviceId, Position position) {
    throw UnimplementedError();
  }
}

class NetworkError extends Error {}

class SemiRemoteDeviceRepository extends DeviceRepository {
  final String baseUrl = 'http://192.168.1.68:3000/';
  @override
  Future<List<Device>> fetchDevices() async {
    final jsonData = await rootBundle.loadString('assets/storage/devices.json');
    final jsonMap = json.decode(jsonData);

    return Future.delayed(Duration(seconds: 1), () {
      return Device.fromMaps(jsonMap['devices']);
    });
  }

  @override
  Future<History> fetchHistory(String deviceId) async {
  
    final url = baseUrl + 'location/$deviceId';
    final headers = {"Content-type": "application/json"};
    final response = await get(url, headers: headers);

    try {
      if (response.statusCode == 200) {
        return History.fromJson(json.decode(response.body));
      }
      else throw NetworkError();
    }
    on Error {
      throw Error;
    }
  }

  @override
  Future<void> postPosition(String deviceId, Position position) async {
    final url = baseUrl + 'location/';
    final headers = {"Content-type": "application/json"};
    post(
      url,
      headers: headers,
      body: json.encode(position.toJson()..addAll({'deviceId': deviceId})),
    );
  }
}
