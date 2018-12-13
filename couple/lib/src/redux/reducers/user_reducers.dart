import 'package:redux/redux.dart';

import 'package:couple/src/redux/actions/user_actions.dart';
import 'package:couple/src/redux/model/user_state.dart';

Reducer<UserState> userReducer = combineReducers<UserState>([
  new TypedReducer<UserState, UserLoggedIn>(userLoggedIn),
  new TypedReducer<UserState, UserLoginSteps>(userLogInState),
  new TypedReducer<UserState, UserUpdate>(userUpdated),
]);

UserState userLogInState(UserState userState, UserLoginSteps step) {
  if (step == UserLoginSteps.begin) {
    return UserState(
        authenticated: false, state: 1, sessionId: null, user: null);
  } else if (step == UserLoginSteps.success) {
    return UserState(
        authenticated: userState.authenticated,
        state: 2,
        sessionId: userState.sessionId,
        user: userState.user);
  } else if (step == UserLoginSteps.error) {
    return UserState(
        authenticated: false, state: 3, sessionId: null, user: null);
  }
  return userState;
}

UserState userLoggedIn(UserState userState, UserLoggedIn action) {
  UserState userState = UserState(
      authenticated: true, sessionId: action.sessionId, user: action.user);
  return userState;
}

UserState userUpdated(UserState userOldState, UserUpdate action) {
  UserState userState = UserState(
      authenticated: userOldState.authenticated,
      sessionId: userOldState.sessionId,
      user: action.user);
  return userState;
}
