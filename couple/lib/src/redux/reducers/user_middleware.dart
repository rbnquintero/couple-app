import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:couple/src/utils/environment.dart';
import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/actions/user_actions.dart';
import 'package:couple/src/redux/model/user_state.dart';
import 'package:couple/src/utils/repository.dart';
import 'package:couple/src/redux/actions/app_actions.dart';
import 'package:couple/src/redux/actions/msg_actions.dart';
import 'package:couple/src/views/login.dart';

List<Middleware<AppState>> createStoreUserMiddleware() {
  final createUser = _createUser();
  final loginUser = _loginUser();
  final loadUser = _loadUser();
  final loadUserFromApi = _loadUserFromServer();
  final sendInvite = _sendInvite();
  final checkInvite = _checkInvite();
  final acceptInvite = _acceptInvite();
  return [
    TypedMiddleware<AppState, UserRegister>(createUser),
    TypedMiddleware<AppState, UserLogin>(loginUser),
    TypedMiddleware<AppState, UserLoad>(loadUser),
    TypedMiddleware<AppState, UserLoadFromApi>(loadUserFromApi),
    TypedMiddleware<AppState, UserSendInvite>(sendInvite),
    TypedMiddleware<AppState, UserCheckInvite>(checkInvite),
    TypedMiddleware<AppState, UserAcceptInvite>(acceptInvite),
  ];
}

Middleware<AppState> _loadUser() {
  return (Store<AppState> store, action, NextDispatcher next) {
    LocalRepository.getPerfil().then((Map<String, dynamic> perfilMap) {
      // We take the profile from the storage
      if (perfilMap == null) {
        Navigator.of(action.context).pushReplacementNamed(LoginScreen.route);
      } else {
        String sessionId = perfilMap['sessionId'];
        User user = User.fromJson(perfilMap['user']);
        store.dispatch(UserLoggedIn(user, sessionId));
        store.dispatch(UserLoadFromApi(user, action.context));
      }
    });
  };
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

        // Creating the object to send to the store
        Map<String, dynamic> responseMap = json.decode(response.body);
        String sessionId = responseMap['sessionToken'];
        User user = User.fromJson(responseMap);
        store.dispatch(UserLoggedIn(user, sessionId));
        if (user.partner == null) {
          store.dispatch(UserCheckInvite(user, action.context));
        } else {
          store.dispatch(AppInitialized(action.context));
        }

        // We save it locally
        Map<String, dynamic> profileStorage = Map();
        profileStorage["sessionId"] = sessionId;
        profileStorage["user"] = user.toJson();
        LocalRepository.setPerfil(profileStorage);
      } else {
        store.dispatch(UserLoginSteps.error);
      }
    });
    next(action);
  };
}

Middleware<AppState> _loadUserFromServer() {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UserApiLoadSteps.begin);
    User user = action.user;

    String url = Environment.parseUrl +
        Environment.uriUser +
        "/${user.id}?include=partner";
    http.get(url, headers: Environment.parseHeaders).then((response) {
      print("#########");
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        store.dispatch(UserApiLoadSteps.success);

        Map<String, dynamic> responseMap = json.decode(response.body);
        User user = User.fromJson(responseMap);
        String sessionId = store.state.userState.sessionId;
        store.dispatch(UserLoggedIn(user, sessionId));

        // We save it locally
        Map<String, dynamic> profileStorage = Map();
        profileStorage["sessionId"] = sessionId;
        profileStorage["user"] = user.toJson();
        LocalRepository.setPerfil(profileStorage);

        if (user.partner == null) {
          store.dispatch(UserCheckInvite(user, action.context));
        } else {
          store.dispatch(MessagesFetching());
          store.dispatch(AppInitialized(action.context));
        }
      } else {
        store.dispatch(UserApiLoadSteps.error);
      }
    });

    next(action);
  };
}

Middleware<AppState> _sendInvite() {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UserSendingInvite.begin);
    User user = action.user.cloneUser();
    user.invite = action.invite;

    String url = Environment.parseUrl + Environment.uriUser + "/${user.id}";
    Map<String, String> headers = Environment.parseHeaders;
    headers["X-Parse-Session-Token"] = store.state.userState.sessionId;
    http
        .put(url, headers: headers, body: json.encode(user.toJsonForApi()))
        .then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        store.dispatch(UserSendingInvite.success);
        store.dispatch(UserUpdate(user));
      } else {
        store.dispatch(UserSendingInvite.error);
      }
    }).catchError((error) {
      print(error);
    });

    next(action);
  };
}

Middleware<AppState> _checkInvite() {
  return (Store<AppState> store, action, NextDispatcher next) {
    User user = store.state.userState.user;
    var email = user.email;
    String url = Environment.parseUrl +
        Environment.uriUserQuery +
        "?where={\"\$or\":[{\"invite\": \"$email\"}, {\"partner\": { \"__type\": \"Pointer\", \"className\": \"_User\", \"objectId\": \"${store.state.userState.user.id}\" }}]}&include=partner";
    http.get(url, headers: Environment.parseHeaders).then((response) {
      if (response.statusCode == 200 && response.body != null) {
        Map<String, dynamic> responseRaw = json.decode(response.body);
        if (responseRaw['results'] != null &&
            responseRaw['results'].length > 0) {
          User partner = User.fromJson(responseRaw['results'][0]);
          if (partner.partner != null) {
            // Ya aceptó la invitación, hay que igualar las cuentas
            store.dispatch(UserInvitedUpdate(partner, true));

            if (user.invite != null) {
              user.invite = null;
              user.partner = partner;

              String url =
                  Environment.parseUrl + Environment.uriUser + "/${user.id}";
              Map<String, String> headers = Environment.parseHeaders;
              headers["X-Parse-Session-Token"] =
                  store.state.userState.sessionId;
              print(json.encode(user.toJsonForApi()));
              http.put(url,
                  headers: headers, body: json.encode(user.toJsonForApi()));
            }
          } else {
            store.dispatch(UserInvitedUpdate(partner, false));
          }
        }
      }
      store.dispatch(AppInitialized(action.context));
    }).catchError((error) {
      print(error);
    });

    next(action);
  };
}

Middleware<AppState> _acceptInvite() {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UserSendingInvite.begin);
    User user = store.state.userState.user.cloneUser();
    user.partner = store.state.userState.invitedFrom;

    String url = Environment.parseUrl + Environment.uriUser + "/${user.id}";
    Map<String, String> headers = Environment.parseHeaders;
    headers["X-Parse-Session-Token"] = store.state.userState.sessionId;
    print(json.encode(user.toJsonForApi()));
    http
        .put(url, headers: headers, body: json.encode(user.toJsonForApi()))
        .then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        store.dispatch(UserSendingInvite.success);
        store.dispatch(UserUpdate(user));
      } else {
        store.dispatch(UserSendingInvite.error);
      }
    }).catchError((error) {
      print(error);
    });

    next(action);
  };
}
