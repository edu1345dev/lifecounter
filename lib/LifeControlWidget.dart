import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'LifeControllerBloc.dart';
import 'bloc_provider.dart';

class LifeControlWidget extends StatelessWidget {
  final bloc = LifeControllerBloc(initialLife: 20);

  @override
  Widget build(BuildContext context) {
    return LifeBlocProvider(
        bloc: bloc,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IncreasingButton(),
              StreamBuilder(
                stream: bloc.lifeAmount,
                builder: (context, snapshot) => snapshot.hasData
                    ? AnimatedTextWidget(snapshot.data.toString())
                    : CircularProgressIndicator(),
              ),
              DecreasingButton(),
            ],
          ),
        ));
  }
}

class DecreasingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = LifeBlocProvider.of(context);

    return GestureDetector(
        onLongPressStart: (details) {
          bloc.decrementLong.add(null);
        },
        onLongPressEnd: (details) {
          bloc.decrementLongStop.add(null);
        },
        child: IconButton(
          iconSize: 60,
          onPressed: () {
            bloc.decrement.add(null);
          },
          icon: Image(image: AssetImage('images/minus_white.png')),
        ));
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
      reverseDuration: Duration(milliseconds: 350),
      vsync: this,
      duration: Duration(milliseconds: 150),
      lowerBound: 0.0,
      upperBound: 0.5,
    )..addListener(() {
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


