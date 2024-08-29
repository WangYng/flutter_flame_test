import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sensors/flutter_sensors_api.dart';

class AccelerometerEvent {
  final double x;
  final double y;
  final double z;

  AccelerometerEvent(this.x, this.y, this.z);
}

class FlutterSensors {
  static Stream<AccelerometerEvent> accelerometerEventStream = FlutterSensorsApi.accelerometerEventStream.map((event) {
    double x = event["x"];
    double y = event["y"];
    double z = event["z"];
    return AccelerometerEvent(x, y, z);
  });

  static Future<void> register() async {
    return FlutterSensorsApi.register();
  }

  static Future<void> unregister() async {
    return FlutterSensorsApi.unregister();
  }
}
