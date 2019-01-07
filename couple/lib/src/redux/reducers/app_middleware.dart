import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/actions/app_actions.dart';
import 'package:couple/src/redux/actions/user_actions.dart';
import 'package:couple/src/redux/actions/nav_actions.dart';

import 'package:couple/src/views/pair.dart';
import 'package:couple/src/views/home.dart';

import 'package:couple/src/views/chat/chat_view.dart';

List<Middleware<AppState>> createStoreAppMiddleware() {
  final loadState = _createLoadState();
  final appInitialized = _appInitialized();
  return [
    TypedMiddleware<AppState, InitApp>(loadState),
    TypedMiddleware<AppState, AppInitialized>(appInitialized),
  ];
}

Middleware<AppState> _createLoadState() {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(AppInit.started);

    // We start loading the profile
    store.dispatch(UserLoad(action.context));
    next(action);
  };
}

Middleware<AppState> _appInitialized() {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (store.state.userState.authenticated &&
        store.state.userState.user.partner != null) {
      store.dispatch(
          NavUpdateRoute(newRoute: ChatHome.route, newTitle: ChatHome.title));
      Navigator.of(action.context).pushReplacementNamed(Home.route);
    } else if (store.state.userState.authenticated) {
      Navigator.of(action.context).pushReplacementNamed(PairScreen.route);
    }
    next(action);
  };
}
