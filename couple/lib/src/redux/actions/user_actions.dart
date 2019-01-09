import 'package:flutter/material.dart';
import 'package:couple/src/redux/model/user_state.dart';

class UserRegister {
  final User user;
  final Function callback;
  final BuildContext context;
  UserRegister(this.user, this.callback, this.context);
}

class UserLogin {
  final User user;
  final Function callback;
  final BuildContext context;
  UserLogin(this.user, this.callback, this.context);
}

class UserLoginOrRegisterError {
  final String error;
  UserLoginOrRegisterError(this.error);
}

class UserLoggedIn {
  final User user;
  UserLoggedIn(this.user);
}

class UserLoad {
  final BuildContext context;
  UserLoad(this.context);
}

class UserLoadFromApi {
  final User user;
  final BuildContext context;
  UserLoadFromApi(this.user, this.context);
}

class UserCheckInvite {
  final User user;
  final BuildContext context;
  UserCheckInvite(this.user, this.context);
}

class UserUpdated {
  final User user;
  final int state;
  UserUpdated(this.user, {this.state = 3});
}

class UserSendInvite {
  final User user;
  final String invite;
  UserSendInvite(this.user, this.invite);
}

class UserUpdating {
  final String error;
  final bool updating;
  UserUpdating({this.error, this.updating = false});
}

class UserInvitedUpdate {
  final User invitedFrom;
  UserInvitedUpdate(this.invitedFrom);
}

class UserAcceptInvite {
  final BuildContext context;
  UserAcceptInvite(this.context);
}