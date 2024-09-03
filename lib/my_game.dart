import 'dart:async';

import 'package:flutter_flame_test/boundaries.dart';
import 'package:flutter_flame_test/coin.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/forge2d_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';

import 'canvas/canvas.dart';

class InitCoinEvent {
  final int count;

  InitCoinEvent(this.count);
}

class AddCoinEvent {
  final String tag;

  AddCoinEvent(this.tag);
}

EventBus gameEventBus = EventBus();

class MyGame extends Forge2DGame {
  StreamSubscription? accelerometerSubscription;

  // 初始币，添加币
  StreamSubscription? initCoinSubscription;
  StreamSubscription? addCoinSubscription;

  ZCanvasComponent zCanvasComponent = ZCanvasComponent();

  List<Coin> coinList = [];
  final maxCount = 50;

  @override
  Future<void> onLoad() async {
    await world.addAll([
      Boundaries(),
      zCanvasComponent,
    ]);

    accelerometerSubscription = FlutterSensors.accelerometerEventStream.listen((AccelerometerEvent event) {
      final x = event.x.clamp(-5, 5);
      final y = event.y.clamp(-5, 5);
      world.gravity = Vector2(x * -20, y * 20);
    });

    initCoinSubscription = gameEventBus.on<InitCoinEvent>().listen((event) {
      for (int i = 0; i < event.count && i < maxCount; i++) {
        final coin = Coin();
        coinList.add(coin);
        zCanvasComponent.add(coin);
      }
    });

    addCoinSubscription = gameEventBus.on<AddCoinEvent>().listen((event) {
      Vector2 vector2 = Vector2.zero();


      if (event.tag == "1") {
        vector2 = Vector2(-13.8, -13.5);
      } else if (event.tag == "2") {
        vector2 = Vector2(0, -19.3);
      } else if (event.tag == "3") {
        vector2 = Vector2(6.9, -16.6);
      }

      if (coinList.length < maxCount) {
        final coin = Coin.animation(begin: vector2);
        coinList.add(coin);
        zCanvasComponent.add(coin);
      } else {
        zCanvasComponent.add(Coin.fake(begin: vector2));
      }
    });

    camera.viewfinder.zoom = 10;

    FlutterSensors.register();

    await super.onLoad();
  }

  @override
  void pauseEngine() {
    super.pauseEngine();

    FlutterSensors.unregister();
  }

  @override
  void resumeEngine() {
    super.resumeEngine();

    FlutterSensors.register();
  }

  @override
  void onRemove() {
    accelerometerSubscription?.cancel();
    initCoinSubscription?.cancel();
    addCoinSubscription?.cancel();

    FlutterSensors.unregister();

    super.onRemove();
  }

  @override
  Color backgroundColor() {
    return Colors.transparent;
  }
}
