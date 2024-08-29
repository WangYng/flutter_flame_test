import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame_test/my_game.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final game = MyGame();

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 1), () {
      initCoin();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              color: Colors.green,
              margin: const EdgeInsets.only(top: 150),
              constraints: const BoxConstraints.tightFor(width: 343, height: 457),
              child: Stack(
                children: [
                  Positioned.fill(child: GameWidget(game: game)),
                  Positioned(
                    top: 62,
                    left: 0,
                    width: 65,
                    height: 65,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(12.5),
                      onPressed: () => addCoin("1"),
                      child: Image.asset("assets/images/game_coin.png"),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    left: 138,
                    width: 65,
                    height: 65,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(12.5),
                      onPressed: () => addCoin("2"),
                      child: Image.asset("assets/images/game_coin.png"),
                    ),
                  ),
                  Positioned(
                    top: 31,
                    left: 207,
                    width: 65,
                    height: 65,
                    child: CupertinoButton(
                      padding: const EdgeInsets.all(12.5),
                      onPressed: () => addCoin("3"),
                      child: Image.asset("assets/images/game_coin.png"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void initCoin() {
    gameEventBus.fire(InitCoinEvent(10));
  }

  void addCoin(String tag) async {
    for (int i = 0; i < 5; i++) {
      gameEventBus.fire(AddCoinEvent(tag));
      await Future.delayed(const Duration(milliseconds: 150));
    }
  }
}
