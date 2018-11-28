import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:couple/src/redux/reducers/app_reducers.dart';
import 'package:couple/src/redux/reducers/app_middleware.dart';
import 'package:couple/src/redux/reducers/user_middleware.dart';
import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/model/user_state.dart';
import 'package:couple/src/couple.dart';

void main() {
  final store = Store<AppState>(
    appStateReducer,
    initialState: AppState(initialized: false, userState: UserState()),
    middleware: [thunkMiddleware]
      ..addAll(createStoreAppMiddleware())
      ..addAll(createStoreUserMiddleware())
      ..addAll([new LoggingMiddleware.printer()]),
  );

  runApp(CoupleApp(store));
}

class CoupleApp extends StatelessWidget {
  final Store<AppState> store;
  CoupleApp(this.store);

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: Couple(),
    );
  }
}
