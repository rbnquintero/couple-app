import 'package:couple/src/redux/model/user_state.dart';

class AppState {
  bool initialized = false;
  UserState userState;

  AppState({this.initialized, this.userState});

  @override
  String toString() {
    return "{init:$initialized, userState:$userState}";
  }
}
