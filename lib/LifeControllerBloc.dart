import 'dart:async';

import 'package:rxdart/rxdart.dart';

class LifeControllerBloc {
  int initialLife;
  List<int> lifeTrackList = new List();

  var incrementer;
  var decrementer;
  final _lifeAmount = BehaviorSubject<int>();
  final _lifeTrack = BehaviorSubject<List<int>>();

  bool repeat = false;

  reset() {
    initialLife = 20;
    _lifeAmount.add(20);
    lifeTrackList.clear();
    _lifeTrack.add(List());
  }

  LifeControllerBloc({this.initialLife}) {
    Function increment = () {
      initialLife = initialLife + 1;
      _lifeAmount.add(initialLife);
    };

    Function incrementList = () {
      if (lifeTrackList.isEmpty) {
        lifeTrackList.insert(0, initialLife);
        _lifeTrack.add(lifeTrackList);
      } else if (lifeTrackList[0] != initialLife) {
        lifeTrackList.insert(0, initialLife);
        _lifeTrack.add(lifeTrackList);
      }
    };

    Function decrement = () {
      initialLife = initialLife - 1;
      _lifeAmount.add(initialLife);
    };

    incrementer = LifeActor(initialLife, _lifeAmount, increment, incrementList);
    decrementer = LifeActor(initialLife, _lifeAmount, decrement, incrementList);
  }

  Sink<void> get increment => incrementer._singleAction.sink;

  Sink<void> get incrementList => incrementer._singleListAction.sink;

  Sink<void> get incrementLong => incrementer._multipleAction.sink;

  Sink<void> get incrementLongStop => incrementer._multipleActionStop.sink;

  Sink<void> get decrement => decrementer._singleAction.sink;

  Sink<void> get decrementLong => decrementer._multipleAction.sink;

  Sink<void> get decrementLongStop => decrementer._multipleActionStop.sink;

  Stream<int> get lifeAmount => _lifeAmount;

  Stream<List<int>> get lifeTrack => _lifeTrack;
}

class LifeActor {
  bool repeat = false;
  int initialLife;
  Function action;
  Function listAction;
  final _lifeAmount;
  final _singleAction = StreamController<int>();
  final _singleListAction = StreamController<int>();
  final _multipleAction = StreamController<int>();
  final _multipleActionStop = StreamController<int>();

  LifeActor(this.initialLife, this._lifeAmount, this.action, this.listAction) {
    Observable(_singleListAction.stream)
        .debounce(Duration(milliseconds: 1000))
        .listen((void _) {
      listAction();
    });

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
      await Future.delayed(Duration(milliseconds: 100));
    }

    await Future.delayed(Duration(milliseconds: 1000));
    listAction();
  }
}
