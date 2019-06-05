
import 'dart:async';

import 'package:rxdart/rxdart.dart';

class LifeControllerBloc{

  int initialLife;

  final _lifeAmount = BehaviorSubject<int>(seedValue: 20);
  final _increment = StreamController<void>();
  final _decrement = StreamController<void>();

  LifeControllerBloc({this.initialLife}){
    _increment.stream.listen((void _){
        initialLife = initialLife + 1;
        Observable obs = _lifeAmount.debounce(Duration(milliseconds: 500));

        _lifeAmount.add(initialLife);
    });

    _decrement.stream.listen((void _){
      initialLife = initialLife -1;
      _lifeAmount.add(initialLife);
    });
  }

  Sink<void> get increment => _increment.sink;

  Sink<void> get decrement => _decrement.sink;

  Stream<int> get lifeAmount => _lifeAmount.stream;
}