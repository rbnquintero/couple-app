import 'dart:io';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/services.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:couple/src/redux/reducers/app_reducers.dart';
import 'package:couple/src/redux/reducers/app_middleware.dart';
import 'package:couple/src/redux/reducers/user_middleware.dart';
import 'package:couple/src/redux/reducers/msg_middleware.dart';
import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/model/nav_state.dart';
import 'package:couple/src/redux/model/user_state.dart';
import 'package:couple/src/redux/model/msg_state.dart';
import 'package:couple/src/couple.dart';

void main() {
  final store = Store<AppState>(
    appStateReducer,
    initialState: AppState(
        initialized: false,
        navState: NavState(),
        userState: UserState(),
        messagesState: MessagesState(messages: List())),
    middleware: [thunkMiddleware, EpicMiddleware(createStoreMsgEpics)]
      ..addAll(createStoreAppMiddleware())
      ..addAll(createStoreUserMiddleware())
      ..addAll(createStoreMsgMiddleware())
      ..addAll([new LoggingMiddleware.printer()]),
  );

  runApp(CoupleApp(store));
}

class CoupleApp extends StatefulWidget {
  final Store<AppState> store;
  CoupleApp(this.store);
  @override
  State<StatefulWidget> createState() {
    return CoupleAppState();
  }
}

class CoupleAppState extends State<CoupleApp> with WidgetsBindingObserver {
  static const platform =
      const MethodChannel('flutter.rbnquintero.com.channel');
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    firebaseCloudMessagingListeners();

    /*_firebaseMessaging.requestNotificationPermissions();
    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print("#########################");
      print(message);
      print("#########################");
    });*/
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();

    _firebaseMessaging.getToken().then((token) {
      print(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("changed!");
      //widget.store.dispatch(MessagesFetching());
    }
  }

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "notification":
        debugPrint(call.arguments);
        //widget.store.dispatch(MessagesFetching());
        return new Future.value("");
    }
  }

  @override
  Widget build(BuildContext context) {
    platform.setMethodCallHandler(_handleMethod);

    return StoreProvider<AppState>(
      store: widget.store,
      child: Couple(),
    );
  }
}
