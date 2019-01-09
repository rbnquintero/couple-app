import 'package:redux/redux.dart';

import 'package:couple/src/redux/actions/user_actions.dart';
import 'package:couple/src/redux/model/user_state.dart';

Reducer<UserState> userReducer = combineReducers<UserState>([
  new TypedReducer<UserState, UserLogin>(userLogIn),
  new TypedReducer<UserState, UserRegister>(userLogIn),
  new TypedReducer<UserState, UserLoggedIn>(userLoggedIn),
  new TypedReducer<UserState, UserLoginOrRegisterError>(
      userLoginOrRegisterError),
  new TypedReducer<UserState, UserUpdated>(userDataLoaded),
  new TypedReducer<UserState, UserInvitedUpdate>(userInviteUpdate),
]);

UserState userLogIn(UserState userOldState, action) {
  UserState userState = UserState(
      authenticated: false,
      state: 1,
      error: null,
      updating: false,
      user: null,
      invitedFrom: null,
      connected: null);
  return userState;
}

UserState userLoggedIn(UserState userOldState, action) {
  UserState userState = UserState(
      authenticated: true,
      state: 2,
      error: null,
      updating: false,
      user: action.user,
      invitedFrom: null,
      connected: null);
  return userState;
}

UserState userLoginOrRegisterError(UserState userOldState, action) {
  UserState userState = UserState(
      authenticated: false,
      state: -1,
      error: action.error,
      updating: false,
      user: userOldState.user,
      invitedFrom: null,
      connected: null);
  return userState;
}

UserState userDataLoaded(UserState userOldState, UserUpdated action) {
  UserState userState = UserState(
      authenticated: true,
      state: action.state,
      error: null,
      updating: false,
      user: action.user,
      invitedFrom: null,
      connected: null);
  return userState;
}

UserState userUpdating(UserState userOldState, UserUpdating action) {
  UserState userState = UserState(
      authenticated: userOldState.authenticated,
      state: userOldState.state,
      error: action.error,
      updating: action.updating,
      user: userOldState.user,
      invitedFrom: null,
      connected: null);
  return userState;
}

UserState userInviteUpdate(UserState userOldState, UserInvitedUpdate action) {
  UserState userState = UserState(
      authenticated: userOldState.authenticated,
      state: 3,
      error: userOldState.error,
      updating: userOldState.updating,
      user: userOldState.user,
      invitedFrom: action.invitedFrom,
      connected: null);
  return userState;
}
