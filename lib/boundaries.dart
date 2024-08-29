import 'package:flutter_flame_test/shapes/shapes.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Boundaries extends BodyComponent {
  Boundaries() : super(renderBody: false);

  List<FixtureDef> _createFixtureDefs() {
    final topWall = EdgeShape()
      ..set(
        Vector2(54, -104),
        Vector2(-54, -104),
      );

    final topLeftCurve = BezierCurveShape(
      controlPoints: [
        topWall.vertex2,
        Vector2(-104, -100),
        Vector2(-112, -40),
      ],
    );

    final leftWall = EdgeShape()
      ..set(
        topLeftCurve.vertices.last,
        Vector2(-112, 68),
      );

    final bottomLeftCurve = BezierCurveShape(
      controlPoints: [
        leftWall.vertex2,
        Vector2(-108, 124),
        Vector2(-44, 129),
      ],
    );

    final bottomWall = EdgeShape()
      ..set(
        bottomLeftCurve.vertices.last,
        Vector2(44, 129),
      );

    final bottomRightCurve = BezierCurveShape(
      controlPoints: [
        bottomWall.vertex2,
        Vector2(108, 124),
        Vector2(112, 68),
      ],
    );

    final rightWall = EdgeShape()
      ..set(
        bottomRightCurve.vertices.last,
        Vector2(112, -40),
      );

    final topRightCurve = BezierCurveShape(
      controlPoints: [
        rightWall.vertex2,
        Vector2(104, -100),
        Vector2(53, -104),
      ],
    );

    final chainShape = ChainShape();
    List<Vector2> chain = [];
    chain.addAll(topWall.vertices);
    chain.addAll(topLeftCurve.vertices..removeAt(0));
    chain.addAll(leftWall.vertices..removeAt(0));
    chain.addAll(bottomLeftCurve.vertices..removeAt(0));
    chain.addAll(bottomWall.vertices..removeAt(0));
    chain.addAll(bottomRightCurve.vertices..removeAt(0));
    chain.addAll(rightWall.vertices..removeAt(0));
    chain.addAll(topRightCurve.vertices..removeAt(0));
    chainShape.createChain(chain);

    return [FixtureDef(chainShape, friction: 1, userData: "boundaries")];
  }

  @override
  Body createBody() {
    final bodyDef = BodyDef()..position = Vector2(0, 82);
    final body = world.createBody(bodyDef);
    _createFixtureDefs().forEach(body.createFixture);

    return body;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(_OuterBoundarySpriteComponent());
  }
}

class _OuterBoundarySpriteComponent extends SpriteComponent {
  _OuterBoundarySpriteComponent()
      : super(
          anchor: Anchor.center,
          position: Vector2(0, -7.8),
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final sprite = await Sprite.load("game_bottle.png");
    this.sprite = sprite;
    size = Vector2(255, 308);
  }
}

extension on EdgeShape {
  List<Vector2> get vertices {
    return [vertex1, vertex2];
  }
}
