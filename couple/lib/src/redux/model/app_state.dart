import 'package:couple/src/redux/model/user_state.dart';
import 'package:couple/src/redux/model/msg_state.dart';
import 'package:couple/src/redux/model/nav_state.dart';

class AppState {
  bool initialized = false;
  UserState userState;
  NavState navState;
  MessagesState messagesState;

  AppState({this.initialized, this.navState, this.userState, this.messagesState});

  @override
  String toString() {
    return "{init:$initialized, navState:$navState, userState:$userState, messagesState:$messagesState}";
  }
}
