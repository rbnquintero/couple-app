import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import 'package:couple/src/utils/elements.dart';
import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/model/user_state.dart';
import 'package:couple/src/redux/actions/user_actions.dart';

class PairScreen extends StatelessWidget {
  static final String route = '/pair';

  @override
  Widget build(BuildContext context) {
    //return Scaffold(body: WaitingPartnerWidget());
    return StoreBuilder<AppState>(
        builder: (BuildContext context, Store<AppState> store) {
      User user = store.state.userState.user;
      Widget homeWidget;
      if (user.name == null) {
        homeWidget = SetNameWidget(store);
      } else if (user.partner != null) {
        homeWidget = Container();
      } else if (user.invite != null) {
        homeWidget = WaitingPartnerWidget(store);
      } else if (store.state.userState.invitedFrom != null) {
        homeWidget = PendingInvitationWidget(store);
      } else {
        homeWidget = AddPartnerWidget(store);
      }
      return Scaffold(body: homeWidget);
    });
  }
}

class SetNameWidget extends StatefulWidget {
  final Store<AppState> store;
  SetNameWidget(this.store);

  @override
  State<StatefulWidget> createState() {
    return SetNameWidgetState();
  }
}

class SetNameWidgetState extends State<SetNameWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
    'name': null,
  };

  changeName() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    String name = _formData['name'];
    User user = widget.store.state.userState.user;
    //widget.store.dispatch(UserUpdateName(user, name));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.5),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Please provide us with your name"),
              NameTextInput((String value) => _formData['name'] = value),
              SizedBox(height: 10),
              MainButton("Update", changeName, color: Colors.blueGrey),
            ],
          ),
        ),
      ),
    );
  }
}

class PendingInvitationWidget extends StatelessWidget {
  final Store<AppState> store;
  PendingInvitationWidget(this.store);

  acceptInvite(BuildContext context) {
    store.dispatch(UserAcceptInvite(context));
  }

  @override
  Widget build(BuildContext context) {
    User invitedFrom = store.state.userState.invitedFrom;
    return Center(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.5),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Pending invitation",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
                "You have an invitation to be a couple from ${invitedFrom.name} (${invitedFrom.email})"),
            FlatButton(
              child: Text("Accept invitation"),
              onPressed: () => acceptInvite(context),
            ),
          ],
        ),
      ),
    );
  }
}

class WaitingPartnerWidget extends StatelessWidget {
  final Store<AppState> store;
  WaitingPartnerWidget(this.store);

  cancelInvite() {
    store.dispatch(UserSendInvite(store.state.userState.user, null));
  }

  @override
  Widget build(BuildContext context) {
    String invite = store.state.userState.user.invite;
    return Center(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.5),
            borderRadius: BorderRadius.circular(5)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Waiting for $invite to accept your invite",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            MainButton("Cancel invite", cancelInvite, color: Colors.blueGrey),
          ],
        ),
      ),
    );
  }
}

class AddPartnerWidget extends StatefulWidget {
  final Store<AppState> store;
  AddPartnerWidget(this.store);

  @override
  State<StatefulWidget> createState() {
    return AddPartnerWidgetState();
  }
}

class AddPartnerWidgetState extends State<AddPartnerWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
    'email': null,
  };

  sendInvite() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    String email = _formData['email'];
    User user = widget.store.state.userState.user;
    widget.store.dispatch(UserSendInvite(user, email));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        key: _formKey,
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 20.0),
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
              color: Color.fromRGBO(255, 255, 255, 0.5),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text("Invite your partner by adding their email"),
              EmailTextInput((String value) => _formData['email'] = value),
              SizedBox(height: 10),
              MainButton("Invite", sendInvite, color: Colors.blueGrey),
            ],
          ),
        ),
      ),
    );
  }
}
