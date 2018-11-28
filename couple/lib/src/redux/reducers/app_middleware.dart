import 'package:redux/redux.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/actions/app_actions.dart';
import 'package:couple/src/views/login.dart';

List<Middleware<AppState>> createStoreAppMiddleware() {
  final loadState = _createLoadState();
  return [
    TypedMiddleware<AppState, InitApp>(loadState),
  ];
}

Middleware<AppState> _createLoadState() {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(AppInitialized());

    Timer(
        Duration(seconds: 1),
        () => Navigator.of(action.context)
            .pushReplacementNamed(LoginScreen.route));
    next(action);
  };
}
