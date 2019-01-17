import 'package:redux/redux.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/actions/user_actions.dart';
import 'package:couple/src/redux/model/user_state.dart';
import 'package:couple/src/utils/repository.dart';
import 'package:couple/src/redux/actions/app_actions.dart';
import 'package:couple/src/redux/actions/msg_actions.dart';

List<Middleware<AppState>> createStoreUserMiddleware() {
  final createUser = _createUser();
  final loginUser = _loginUser();
  final loadUser = _loadUser();
  final loadUserFromApi = _loadUserFromApi();
  final sendInvite = _sendInvite();
  final checkInvite = _checkInvite();
  final acceptInvite = _acceptInvite();
  final logOut = _logOut();
  return [
    TypedMiddleware<AppState, UserRegister>(createUser),
    TypedMiddleware<AppState, UserLogin>(loginUser),
    TypedMiddleware<AppState, UserLoad>(loadUser),
    TypedMiddleware<AppState, UserLoadFromApi>(loadUserFromApi),
    TypedMiddleware<AppState, UserCheckInvite>(checkInvite),
    TypedMiddleware<AppState, UserSendInvite>(sendInvite),
    TypedMiddleware<AppState, UserAcceptInvite>(acceptInvite),
    TypedMiddleware<AppState, UserLogOut>(logOut),
  ];
}

Middleware<AppState> _createUser() {
  return (Store<AppState> store, action, NextDispatcher next) {
    User user = action.user;

    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth
        .createUserWithEmailAndPassword(
            email: user.email, password: user.password)
        .then((result) {
      user.id = result.uid;
      Firestore.instance
          .collection('users')
          .document(user.id)
          .setData({'name': user.name, 'id': user.id, 'email': user.email});
      store.dispatch(UserLoggedIn(user));
      action.callback();
      store.dispatch(UserLoadFromApi(user, action.context));
    }).catchError((error) {
      print(error);
    });

    next(action);
  };
}

Middleware<AppState> _loginUser() {
  return (Store<AppState> store, action, NextDispatcher next) {
    User user = action.user;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    _auth
        .signInWithEmailAndPassword(email: user.email, password: user.password)
        .then((result) {
      user.id = result.uid;
      store.dispatch(UserLoggedIn(user));
      action.callback();
      store.dispatch(UserLoadFromApi(user, action.context));

      final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
      _firebaseMessaging.getToken().then((token) {
        print(token);
        Firestore.instance
            .collection('users')
            .document(user.id)
            .updateData({'token': token});
      });
    }).catchError((error) {
      if (error.code == 'Error 17011') {
        // Load Sign Up page
        store.dispatch(UserLoginOrRegisterError("USUARIO_NO_REGISTRADO"));
        action.callback();
      } else {
        print(error);
        store.dispatch(UserLoginOrRegisterError("ERROR_EN_EL_SERVICIO"));
        action.callback();
      }
    });

    next(action);
  };
}

Middleware<AppState> _loadUser() {
  return (Store<AppState> store, action, NextDispatcher next) {
    LocalRepository.getPerfil().then((Map<String, dynamic> perfilMap) {
      // We take the profile from the storage
      if (perfilMap == null) {
        store.dispatch(AppInitialized(action.context));
      } else {
        User user = User.fromJson(perfilMap['user']);
        store.dispatch(UserLoggedIn(user));
        store.dispatch(UserLoadFromApi(user, action.context));
      }
    });
    next(action);
  };
}

Middleware<AppState> _loadUserFromApi() {
  return (Store<AppState> store, action, NextDispatcher next) {
    User user = store.state.userState.user;
    Firestore.instance
        .collection('users')
        .where('id', isEqualTo: user.id)
        .getDocuments()
        .then((result) {
      if (result.documents.length > 0) {
        // Has extra info
        DocumentSnapshot documentSnapshot = result.documents[0];
        user.name = documentSnapshot.data["name"];
        if (documentSnapshot.data["partner"] == null) {
          // Check for other user's invites
          store.dispatch(UserUpdated(user, state: store.state.userState.state));
          store.dispatch(UserCheckInvite(user, action.context));

          // We save it locally
          Map<String, dynamic> profileStorage = Map();
          profileStorage["user"] = user.toJson();
          LocalRepository.setPerfil(profileStorage);
        } else {
          // Already has partner
          Firestore.instance
              .collection('users')
              .where('id', isEqualTo: documentSnapshot.data['partner'])
              .getDocuments()
              .then((result) {
            DocumentSnapshot partnerDoc = result.documents[0];
            User partner = User(
              id: partnerDoc.data['id'],
              email: partnerDoc.data['email'],
              name: partnerDoc.data['name'],
            );
            user.partner = partner;
            store.dispatch(UserUpdated(user));
            store.dispatch(AppInitialized(action.context));

            store.dispatch(MessagesFetching());

            // We save it locally
            Map<String, dynamic> profileStorage = Map();
            profileStorage["user"] = user.toJson();
            LocalRepository.setPerfil(profileStorage);
          }).catchError((error) {
            print("error");
          });
        }
      } else {
        // Has no extra info
        store.dispatch(UserCheckInvite(user, action.context));
      }
    });
    next(action);
  };
}

Middleware<AppState> _sendInvite() {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UserUpdating(updating: true));
    User user = store.state.userState.user;

    Firestore.instance
        .collection('users')
        .document(user.id)
        .updateData({'invite': action.invite}).then((result) {
      store.dispatch(UserUpdating(updating: false));
      user.invite = action.invite;
      store.dispatch(UserUpdated(user));
    }).catchError((error) {
      store.dispatch(UserUpdating(
          updating: false, error: "Error al obtener la info del usuario"));
    });

    next(action);
  };
}

Middleware<AppState> _checkInvite() {
  return (Store<AppState> store, action, NextDispatcher next) {
    User user = store.state.userState.user;
    Firestore.instance
        .collection('users')
        .where('invite', isEqualTo: user.email)
        .getDocuments()
        .then((result) {
      if (result.documents.length > 0) {
        // Has an invitation
        DocumentSnapshot partnerDoc = result.documents[0];
        User user = User(
          id: partnerDoc.data['id'],
          email: partnerDoc.data['email'],
          name: partnerDoc.data['name'],
        );
        store.dispatch(UserInvitedUpdate(user));
        store.dispatch(AppInitialized(action.context));
      } else {
        // Doesn't have invitation
        store.dispatch(UserUpdated(user));
        store.dispatch(AppInitialized(action.context));
      }
    });
    next(action);
  };
}

Middleware<AppState> _acceptInvite() {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UserUpdating(updating: true));
    User user = store.state.userState.user;
    User partner = store.state.userState.invitedFrom;

    Firestore.instance
        .collection('users')
        .document(user.id)
        .updateData({'partner': partner.id, 'invite': null}).then((result) {
      user.partner = partner;
      store.dispatch(UserUpdating(updating: false));
      store.dispatch(UserInvitedUpdate(null));
      store.dispatch(UserUpdated(user));

      // Accept the account on the partner's side
      Firestore.instance
          .collection('users')
          .document(partner.id)
          .updateData({'partner': user.id, 'invite': null});

      store.dispatch(MessagesFetching());
      store.dispatch(AppInitialized(action.context));

      // We save it locally
      Map<String, dynamic> profileStorage = Map();
      profileStorage["user"] = user.toJson();
      LocalRepository.setPerfil(profileStorage);
    }).catchError((error) {
      store.dispatch(UserUpdating(
          updating: false, error: "Error al actualizar la info del usuario"));
    });

    next(action);
  };
}

Middleware<AppState> _logOut() {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(CancelMessagesDataEventsAction());

    LocalRepository.setPerfil(null);
    store.dispatch(InitApp(action.context));
    next(action);
  };
}
