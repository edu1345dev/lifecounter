import 'dart:async';

import 'package:rxdart/rxdart.dart';

class LifeControllerBloc {
  int initialLife;

  var _lifeAmount = BehaviorSubject<int>(seedValue: 20);
  var _increment = StreamController<int>();
  var _decrement = StreamController<int>();

  LifeControllerBloc({this.initialLife}) {
    Observable(_increment.stream)
        .debounce(Duration(milliseconds: 500))
        .listen((void _) {
      initialLife = initialLife + 1;
      _lifeAmount.add(initialLife);
    });

    Observable(_decrement.stream)
        .debounce(Duration(milliseconds: 500))
        .listen((void _) {
      initialLife = initialLife - 1;
      _lifeAmount.add(initialLife);
    });
  }

  Sink<void> get increment => _increment.sink;

  Sink<void> get decrement => _decrement.sink;

  Stream<int> get lifeAmount => _lifeAmount;
}
