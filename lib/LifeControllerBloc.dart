import 'dart:async';

import 'package:rxdart/rxdart.dart';

class LifeControllerBloc {
  int initialLife;

  final _lifeAmount = BehaviorSubject<int>();
  final _increment = StreamController<int>();
  final _incrementLong = StreamController<int>();
  final _incrementLongStop = StreamController<int>();
  final _decrement = StreamController<int>();
  bool repeat = false;

  LifeControllerBloc({this.initialLife}) {
    Observable(_increment.stream)
        .debounce(Duration(milliseconds: 0))
        .startWith(initialLife)
        .listen((void _) {
      initialLife = initialLife + 1;
      _lifeAmount.add(initialLife);
    });

    Observable(_decrement.stream)
        .debounce(Duration(milliseconds: 0))
        .startWith(initialLife)
        .listen((void _) {
      initialLife = initialLife - 1;
      _lifeAmount.add(initialLife);
    });

    Observable(_incrementLong.stream).startWith(initialLife).listen((void _) {
      onLong();
    });

    Observable(_incrementLongStop.stream).startWith(initialLife).listen((_) {
      repeat = false;
    });
  }

  void onLong() async{
    repeat = true;
    while (repeat) {
      initialLife = initialLife + 1;
      _lifeAmount.add(initialLife);
    
      await Future.delayed(Duration(milliseconds: 200));
    }
  }

  Sink<void> get increment => _increment.sink;

  Sink<void> get incrementLong => _incrementLong.sink;
  Sink<void> get incrementLongStop => _incrementLongStop.sink;

  Sink<void> get decrement => _decrement.sink;

  Stream<int> get lifeAmount => _lifeAmount;
}
