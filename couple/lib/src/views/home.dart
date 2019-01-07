import 'package:flutter/material.dart';
//REDUX
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:couple/src/redux/model/app_state.dart';

import 'package:couple/src/views/components/drawer.dart';
import 'package:couple/src/views/chat/chat_view.dart';

class Home extends StatelessWidget {
  static final String route = '/home';

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      builder: (BuildContext context, Store<AppState> store) {
        return Scaffold(
          appBar: AppBar(),
          drawer: CoupleDrawer(),
          body: returnBody(store.state.navState.route),
        );
      },
    );
  }

  Widget returnBody(String route) {
    switch (route) {
      case '/home/chat':
        return ChatHome();
      default:
        return null;
    }
  }
}
