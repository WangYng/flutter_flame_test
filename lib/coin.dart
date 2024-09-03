import 'dart:async';
import 'dart:math';

import 'package:flutter_flame_test/canvas/canvas.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'behaviors/contact_behavior.dart';

class Coin extends BodyComponent with ZIndex {
  // 币的大小
  static final Vector2 size = Vector2.all(2.8);

  // 开始的位置 和 结束的位置
  final Vector2 begin;
  final Vector2 end;
  double t = 0;

  // 类型
  final BodyType type;

  // 假装放入瓶中
  final bool isFake;

  /// 创建在瓶子中的币
  Coin()
      : begin = Vector2.zero(),
        end = Vector2.zero(),
        type = BodyType.dynamic,
        isFake = false,
        super(renderBody: false, children: [CoinSpriteComponent(), CoinBehavior()]) {
    zIndex = Random().nextInt(100);
  }

  /// 币有进入瓶子的动画
  Coin.animation({
    required this.begin,
  })  : end = Vector2.zero(),
        type = BodyType.static,
        isFake = false,
        super(renderBody: false, children: [CoinSpriteComponent(), CoinBehavior()]) {
    zIndex = Random().nextInt(100);
  }

  /// 只有进入的动画，没有真的装进去
  Coin.fake({
    required this.begin,
  })  : end = Vector2.zero(),
        type = BodyType.static,
        isFake = true,
        super(renderBody: false, children: [CoinSpriteComponent(), CoinBehavior()]) {
    zIndex = Random().nextInt(100);
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = size.x / 2;

    Vector2 begin = this.begin;
    if (type == BodyType.dynamic) {
      final x = Random().nextDouble() * 16.0 - 8.0;
      final y = Random().nextDouble() * 16.0;

      begin = Vector2(x, y);
    }

    final bodyDef = BodyDef(position: begin, type: type);
    bodyDef.linearDamping = 0.001;
    bodyDef.angularDamping = 1;
    final body = world.createBody(bodyDef);
    body.createFixture(FixtureDef(shape, friction: 1, restitution: 0, density: 7.9 * 1000, userData: "coin"));
    return body;
  }

  @override
  void update(double dt) {
    // 执行动画。动画结束时，把静态物体改为动态物体
    if (body.bodyType == BodyType.static) {
      t = (t + 0.02).clamp(0.0, 1.0);

      if (t == 1) {
        if (isFake == true) {
          removeFromParent();
        } else {
          body.setType(BodyType.dynamic);
        }
      }

      final x = begin.x + (end.x - begin.x) * Curves.linear.transform(t);
      final y = begin.y + (end.y - begin.y) * Curves.easeInBack.transform(t);

      body.setTransform(Vector2(x, y), 0);
    }

    super.update(dt);
  }
}

class CoinSpriteComponent extends SpriteComponent with HasGameRef {
  CoinSpriteComponent() : super(anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await Sprite.load("game_coin.png");
    this.sprite = sprite;
    size = Vector2(4.0, 4.0);
  }
}

class CoinBehavior extends ContactBehavior<Coin> {
  Completer? completer;

  CoinBehavior() : super() {
    applyTo(["coin", "boundaries"]);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);

    // 只和玻璃瓶碰撞
    if (other != "boundaries") {
      return;
    }

    // 距离上次碰撞时间太短
    if (completer?.isCompleted == false) {
      return;
    }

    // 碰撞速度限制
    final velocity = parent.body.linearVelocity;
    if (velocity.x.abs() < 5.0 && velocity.y.abs() < 5.0) {
      return;
    }

    HapticFeedback.lightImpact();

    Future.delayed(const Duration(milliseconds: 400), () {
      if (completer?.isCompleted == false) {
        completer?.complete();
      }
    });
  }
}
