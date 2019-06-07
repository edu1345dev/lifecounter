import 'package:flutter/material.dart';
import 'package:lifecounter/second_screen.dart';

import 'LifeControllerBloc.dart';
import 'bloc_provider.dart';

void main() {
  final bloc = LifeControllerBloc(initialLife: 20);
  runApp(MyApp(bloc));
}

class MyApp extends StatelessWidget {
  final LifeControllerBloc bloc;

  MyApp(this.bloc);

  @override
  Widget build(BuildContext context) {
    return LifeBlocProvider(
      bloc: bloc,
      child: MaterialApp(
        title: 'Magic Lifecounter',
        theme: ThemeData(),
        home: MyHomePage(title: 'Magic Lifecounter'),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  GlobalKey<ScaffoldState> _scaffold = GlobalKey();

  final String title;

  @override
  Widget build(BuildContext context) {
    final bloc = LifeBlocProvider.of(context);

    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder(
              stream: bloc.lifeAmount,
              builder: (context, snapshot) => snapshot.hasData
                  ? Text('${snapshot.data}')
                  : CircularProgressIndicator(),
            ),
            IncreasingButton(_scaffold),
            DecreasingButton(),
            FlatButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SecondScreen(_scaffold)));
                },
                child: Text('Second Screen'))
          ],
        ),
      ),
    );
  }
}

class DecreasingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = LifeBlocProvider.of(context);

    return GestureDetector(
      onLongPressStart: (details) {
        bloc.incrementLong.add(null);
      },
      onLongPressEnd: (details) {
        bloc.incrementLongStop.add(null);
      },
      child: FlatButton(
          onPressed: () {
            bloc.decrement.add(null);
          },
          child: Text("Tirar vida")),
    );
  }
}

class IncreasingButton extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffold;

  IncreasingButton(this.scaffold);

  @override
  Widget build(BuildContext context) {
    final bloc = LifeBlocProvider.of(context);

    return FlatButton(
        onPressed: () {
          scaffold.currentState.showSnackBar(SnackBar(content: Text('Snackbar Teste')));
          bloc.increment.add(null);
        },
        child: Text("Adicionar vida"));
  }
}
