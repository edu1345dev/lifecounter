import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'bloc_provider.dart';
import 'main.dart';

class SecondScreen extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffold;
  SecondScreen(this.scaffold);

  @override
  Widget build(BuildContext context) {
    final bloc = LifeBlocProvider.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
                stream: bloc.lifeAmount,
                builder: (context, snapshot) => snapshot.hasData
                    ? Text(snapshot.data.toString())
                    : Text('No Data')),
            IncreasingButton(scaffold),
            DecreasingButton(),
          ],
        ),
      ),
    );
  }
}
