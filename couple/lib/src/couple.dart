import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/views/login.dart';
import 'package:couple/src/views/home.dart';
import 'package:couple/src/redux/actions/app_actions.dart';

class Couple extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: Colors.blueGrey,
      ),
      title: 'Couple app',
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case "/":
            return CustomRoute(
                builder: (_) => InitScreen(), settings: settings);
          case "/login":
            return CustomRoute(
                builder: (_) => LoginScreen(), settings: settings);
          case "/home":
            return CustomRoute(
                builder: (_) => HomeScreen(), settings: settings);
        }
        assert(false);
      },
      /*routes: {
        InitScreen.route: (context) => InitScreen(),
        LoginScreen.route: (context) => LoginScreen(),
      },*/
    );
  }
}

class InitScreen extends StatelessWidget {
  static final String route = '/';

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      onInit: (Store<AppState> store) => store.dispatch(InitApp(context)),
      builder: (BuildContext context, Store<AppState> store) {
        return Scaffold(
          body: Center(
            child: Text('App'),
          ),
        );
      },
    );
  }
}

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    return FadeTransition(opacity: animation, child: child);
  }
}
