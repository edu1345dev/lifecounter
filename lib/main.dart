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
  final p1Life = LifeControlWidget();
  final p2Life = LifeControlWidget();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffold,
        body: Center(
            child: Stack(alignment: Alignment.center, children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black),
                  child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: RotatedBox(
                        quarterTurns: 2,
                        child: p1Life,
                      )),
                ),
              ),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.black),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: p2Life,
                  ),
                ),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: SizedBox.fromSize(
                  size: Size.fromHeight(2),
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white)),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onLongPress: () {
                    p1Life.reinitLife();
                    p2Life.reinitLife();
                  },
                  child: IconButton(
                    iconSize: 50,
                    onPressed: () {},
                    icon:
                        Image(image: AssetImage('images/reset_white.png')),
                  ),
                ),
              ),
              Expanded(
                child: SizedBox.fromSize(
                  size: Size.fromHeight(2),
                  child: Container(
                      decoration: BoxDecoration(color: Colors.white)),
                ),
              )
            ],
          ),
        ])),
      ),
    );
  }
}
