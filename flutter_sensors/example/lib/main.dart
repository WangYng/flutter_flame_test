import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FlutterSensors.accelerometerEventStream.listen((event) {
      print(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(children: [
            TextButton(
              onPressed: () {
                FlutterSensors.register();
              },
              child: Text("注册"),
            ),
            TextButton(
              onPressed: () {
                FlutterSensors.unregister();
              },
              child: Text("取消注册"),
            ),
          ]),
        ),
      ),
    );
  }
}
