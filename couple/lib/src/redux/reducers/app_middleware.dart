import 'package:redux/redux.dart';

import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/actions/app_actions.dart';
import 'package:couple/src/redux/actions/user_actions.dart';

List<Middleware<AppState>> createStoreAppMiddleware() {
  final loadState = _createLoadState();
  return [
    TypedMiddleware<AppState, InitApp>(loadState),
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
