import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:couple/src/utils/environment.dart';
import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/actions/user_actions.dart';
import 'package:couple/src/views/home.dart';
import 'package:couple/src/redux/model/user_state.dart';

List<Middleware<AppState>> createStoreUserMiddleware() {
  final createUser = _createUser();
  final loginUser = _loginUser();
  return [
    TypedMiddleware<AppState, UserRegister>(createUser),
    TypedMiddleware<AppState, UserLogin>(loginUser),
  ];
}

Middleware<AppState> _createUser() {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UserRegisterSteps.begin);
    User user = action.user;

    String url = Environment.parseUrl + Environment.uriUser;
    http
        .post(url,
            headers: Environment.parseHeaders, body: json.encode(user.toJson()))
        .then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 201) {
        store.dispatch(UserRegisterSteps.success);

        Map<String, dynamic> responseMap = json.decode(response.body);
        user.id = responseMap['objectId'];
        action.success(user);
      } else {
        store.dispatch(UserRegisterSteps.error);
      }
    });

    next(action);
  };
}

Middleware<AppState> _loginUser() {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UserLoginSteps.begin);
    User user = action.user;

    String url = Environment.parseUrl +
        Environment.uriLogin +
        "?username=${user.email}&password=${user.password}";
    http.get(url, headers: Environment.parseHeaders).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        store.dispatch(UserLoginSteps.success);

        Map<String, dynamic> responseMap = json.decode(response.body);
        String sessionId = responseMap['sessionToken'];
        store.dispatch(UserLoggedIn(User.fromJson(responseMap), sessionId));
        Navigator.of(action.context).pushReplacementNamed(HomeScreen.route);
      } else {
        store.dispatch(UserLoginSteps.error);
      }
    });
    next(action);
  };
}
