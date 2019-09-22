import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'LifeControllerBloc.dart';
import 'bloc_provider.dart';

class LifeControlWidget extends StatefulWidget {

  var bloc;

  var initialLife;

  reinitLife() {
    bloc.reset();
  }

  @override
  _LifeControlWidgetState createState() => _LifeControlWidgetState();

  LifeControlWidget({this.initialLife: 20}){
    bloc = LifeControllerBloc(initialLife: initialLife);
  }
}

class _LifeControlWidgetState extends State<LifeControlWidget> {
  @override
  Widget build(BuildContext context) {
    return LifeBlocProvider(
        bloc: widget.bloc,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    DecreasingButton(),
                    StreamBuilder(
                      stream: widget.bloc.lifeAmount,
                      builder: (context, snapshot) =>
                      snapshot.hasData
                          ? AnimatedTextWidget(snapshot.data.toString())
                          : CircularProgressIndicator(),
                    ),
                    IncreasingButton(),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: StreamBuilder(
                    stream: widget.bloc.lifeTrack,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData)
                        return Text('Loading...');
                      else
                        return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) =>
                                buildText(snapshot, index));
                    }),
              ),
            ],
          ),
        ));
  }

  Text buildText(AsyncSnapshot snapshot, int index) {
    return (index == 0) ?

    Text(snapshot.data[index].toString()+"  ",
      style: TextStyle(color: Colors.white, decorationStyle: TextDecorationStyle.wavy, fontSize: 30 )):
    Text(
        snapshot.data[index].toString()+ ((index != snapshot.data.length-1)?"•":""),
      style: TextStyle(color: Colors.white, fontSize: 20));
  }
}

class DecreasingButton extends StatefulWidget {
  @override
  _DecreasingButtonState createState() => _DecreasingButtonState();
}

class _DecreasingButtonState extends State<DecreasingButton>
    with SingleTickerProviderStateMixin {
  double _scale;
  Animation<double> animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      reverseDuration: Duration(milliseconds: 150),
      vsync: this,
      duration: Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.3,
    )
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LifeBlocProvider.of(context);
    _scale = 1 + _controller.value;

    return GestureDetector(
      onTapDown: (details) {
        _controller.forward();
      },
      onTapUp: (details) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      onLongPressStart: (details) {
        bloc.decrementLong.add(null);
        _controller.forward();
      },
      onLongPressEnd: (details) {
        bloc.decrementLongStop.add(null);
        _controller.reverse();
      },
      child: Transform.scale(
        scale: _scale,
        child: IconButton(
          iconSize: 60,
          onPressed: () {
            bloc.decrement.add(null);
            bloc.incrementList.add(null);
            setState(() {});
          },
          icon: Image(image: AssetImage('images/minus_white.png')),
        ),
      ),
    );
  }
}

class IncreasingButton extends StatefulWidget {
  @override
  _IncreasingButtonState createState() => _IncreasingButtonState();
}

class _IncreasingButtonState extends State<IncreasingButton>
    with SingleTickerProviderStateMixin {
  double _scale;
  Animation<double> animation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      reverseDuration: Duration(milliseconds: 150),
      vsync: this,
      duration: Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.3,
    )
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = LifeBlocProvider.of(context);
    _scale = 1 + _controller.value;

    return GestureDetector(
      onTapDown: (details) {
        _controller.forward();
      },
      onTapUp: (details) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.reverse();
      },
      onLongPressStart: (details) {
        bloc.incrementLong.add(null);
        _controller.forward();
      },
      onLongPressEnd: (details) {
        bloc.incrementLongStop.add(null);
        _controller.reverse();
      },
      child: Transform.scale(
        scale: _scale,
        child: IconButton(
          iconSize: 60,
          onPressed: () {
            bloc.increment.add(null);
            bloc.incrementList.add(null);
            setState(() {});
          },
          icon: Image(image: AssetImage('images/plus_white.png')),
        ),
      ),
    );
  }
}

class AnimatedTextWidget extends StatefulWidget {
  String _text;

  AnimatedTextWidget(this._text);

  @override
  _AnimatedTextWidgetState createState() => _AnimatedTextWidgetState();
}

class _AnimatedTextWidgetState extends State<AnimatedTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Center(
            child: AutoSizeText(
              '${widget._text}',
              style: TextStyle(fontSize: 112, color: Colors.white),
              maxLines: 1,
            )));
  }
}
