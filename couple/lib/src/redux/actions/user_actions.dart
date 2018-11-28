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

enum UserRegisterSteps { begin, success, error }

enum UserLoginSteps { begin, success, error }

class UserLoggedIn {
  final User user;
  final String sessionId;
  UserLoggedIn(this.user, this.sessionId);
}
