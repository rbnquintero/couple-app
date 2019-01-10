import 'package:flutter/material.dart';

import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/actions/user_actions.dart';

class CoupleDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      builder: (BuildContext context, Store<AppState> store) {
        return Drawer(
          child: Column(
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: Text('Couple'),
                ),
              ),
              FlatButton(
                child: Text("Sign out"),
                onPressed: () => store.dispatch(UserLogOut(context)),
              ),
            ],
          ),
        );
      },
    );
  }
}
