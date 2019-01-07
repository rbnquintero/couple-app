import 'package:redux/redux.dart';

import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/actions/app_actions.dart';
import 'package:couple/src/redux/reducers/user_reducers.dart';
import 'package:couple/src/redux/reducers/nav_reducers.dart';
import 'package:couple/src/redux/reducers/msg_reducers.dart';

Reducer<bool> appReducer = combineReducers<bool>([
  new TypedReducer<bool, AppInitialized>(appInitialized),
]);

bool appInitialized(bool initialized, AppInitialized action) {
  return true;
}

AppState appStateReducer(AppState state, action) => new AppState(
    initialized: appReducer(state.initialized, action),
    navState: navReducer(state.navState, action),
    userState: userReducer(state.userState, action),
    messagesState: messagesReducer(state.messagesState, action));
