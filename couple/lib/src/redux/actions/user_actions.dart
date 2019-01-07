import 'package:flutter/material.dart';
import 'package:couple/src/redux/model/user_state.dart';

class UserRegister {
  final Function success;
  final User user;
  UserRegister(this.success, this.user);
}

class UserLogin {
  final BuildContext context;
  final User user;
  UserLogin(this.context, this.user);
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

class UserSendInvite {
  final User user;
  final String invite;
  UserSendInvite(this.user, this.invite);
}

enum UserLoadSteps { begin, success, error }
enum UserRegisterSteps { begin, success, error }
enum UserLoginSteps { begin, success, error }
enum UserApiLoadSteps { begin, success, error }
enum UserSendingInvite { begin, success, error }

class UserLoggedIn {
  final User user;
  final String sessionId;
  UserLoggedIn(this.user, this.sessionId);
}

class UserCheckInvite {
  final User user;
  final BuildContext context;
  UserCheckInvite(this.user, this.context);
}

class UserUpdate {
  final User user;
  UserUpdate(this.user);
}

class UserInvitedUpdate {
  final User invitedFrom;
  final bool connected;
  UserInvitedUpdate(this.invitedFrom, this.connected);
}

class UserAcceptInvite {}
