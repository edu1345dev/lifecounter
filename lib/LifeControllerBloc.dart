import 'dart:async';

import 'package:rxdart/rxdart.dart';

class LifeControllerBloc {
  int initialLife;
  var incrementer;
  var decrementer;
  final _lifeAmount = BehaviorSubject<int>();
  bool repeat = false;

  LifeControllerBloc({this.initialLife}) {
    Function increment = () {
    initialLife = initialLife + 1;
    _lifeAmount.add(initialLife);
  };

    Function decrement = () {
      initialLife = initialLife - 1;
      _lifeAmount.add(initialLife);
    };

    incrementer = LifeActor(initialLife, _lifeAmount, increment);
    decrementer = LifeActor(initialLife, _lifeAmount, decrement);
  }

  Sink<void> get increment => incrementer._singleAction.sink;

  Sink<void> get incrementLong => incrementer._multipleAction.sink;

  Sink<void> get incrementLongStop => incrementer._multipleActionStop.sink;

  Sink<void> get decrement => decrementer._singleAction.sink;

  Sink<void> get decrementLong => decrementer._multipleAction.sink;

  Sink<void> get decrementLongStop => decrementer._multipleActionStop.sink;

  Stream<int> get lifeAmount => _lifeAmount;
}

class LifeActor {
  bool repeat = false;
  int initialLife;
  Function action;
  final _lifeAmount;
  final _singleAction = StreamController<int>();
  final _multipleAction = StreamController<int>();
  final _multipleActionStop = StreamController<int>();

  LifeActor(this.initialLife, this._lifeAmount, this.action) {
    Observable(_singleAction.stream)
        .debounce(Duration(milliseconds: 0))
        .startWith(initialLife)
        .listen((void _) {
      action();
    });

    Observable(_multipleAction.stream).startWith(initialLife).listen((void _) {
      doMultipleAction();
    });

    Observable(_multipleActionStop.stream).startWith(initialLife).listen((_) {
      repeat = false;
    });
  }

  void doMultipleAction() async {
    repeat = true;
    while (repeat) {
      action();
      await Future.delayed(Duration(milliseconds: 150));
    }
  }
}
