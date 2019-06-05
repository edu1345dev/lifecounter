import 'package:flutter/widgets.dart';

import 'LifeControllerBloc.dart';

class LifeBlocProvider extends InheritedWidget {
  final LifeControllerBloc bloc;

  LifeBlocProvider({Key key, this.bloc, child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LifeControllerBloc of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(LifeBlocProvider)
              as LifeBlocProvider)
          .bloc;
}
