import 'package:flutter/material.dart';

import 'LifeControlWidget.dart';
import 'bloc_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Magic Lifecounter',
      theme: ThemeData(),
      home: MyHomePage(title: 'Magic Lifecounter'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffold,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.black, Colors.white])),
              child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: LifeControlWidget(),
                  )),
            ),
          ),
          Container(
            child: SizedBox(
              height: 4,
              width: 1000,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.white, ),
              ),
            ),
          ),
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.white, Colors.black])),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: LifeControlWidget(),
              ),
            ),
          )
        ],
      )),
    );
  }
}
