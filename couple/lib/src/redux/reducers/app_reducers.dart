import 'package:redux/redux.dart';

import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/actions/app_actions.dart';
import 'package:couple/src/redux/reducers/user_reducers.dart';

/*AppState appReducer(AppState appState, dynamic action) {
  if (action is InitApp) {
    return AppState(initialized: true, state: appState.state);
  }
  return appState;
}*/

Reducer<bool> appReducer = combineReducers<bool>([
  new TypedReducer<bool, AppInitialized>(appInitialized),
]);

bool appInitialized(bool initialized, AppInitialized action) {
  return true;
}

AppState appStateReducer(AppState state, action) => new AppState(
    initialized: appReducer(state.initialized, action),
    userState: userReducer(state.userState, action));
