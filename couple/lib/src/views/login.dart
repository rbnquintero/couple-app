import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import 'package:couple/src/utils/elements.dart';
import 'package:couple/src/redux/model/user_state.dart';
import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/actions/user_actions.dart';

class LoginScreen extends StatelessWidget {
  static final String route = '/login';

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      builder: (BuildContext context, Store<AppState> store) {
        return LoginWidget(store);
      },
    );
  }
}

class LoginWidget extends StatefulWidget {
  final Store<AppState> store;
  LoginWidget(this.store);

  @override
  State<StatefulWidget> createState() {
    return LoginWidgetState();
  }
}

typedef LoginOrRegisterCallback = Function(User user);
enum LoginStage { init, signin, signup }

class LoginWidgetState extends State<LoginWidget> {
  final PageController _controller = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> _formData = {
    'email': '',
    'password': '',
    'name': ''
  };
  LoginStage loginStage = LoginStage.init;

  Widget _buildPage({int index, Color color}) {
    return Container(
      alignment: AlignmentDirectional.center,
      color: color,
      child: Text(
        '$index',
        style: TextStyle(fontSize: 132.0, color: Colors.white),
      ),
    );
  }

  void changeLogin(LoginStage newLoginStage) {
    setState(() {
      loginStage = newLoginStage;
    });
  }

  Widget _buildPageView() {
    return PageView(
      controller: _controller,
      children: [
        _buildPage(index: 1),
        _buildPage(index: 2),
        _buildPage(index: 3),
        _buildPage(index: 4),
      ],
    );
  }

  Widget _buildInitButtons() {
    return SizedBox.expand(
      child: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("App"),
            Text("App for"),
            Expanded(flex: 1, child: Container()),
            DotsIndicator(
              itemCount: 4,
              controller: _controller,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  MainButton(
                    "Sign up",
                    () => changeLogin(LoginStage.signup),
                    color: Colors.blue,
                  ),
                  MainButton("Sign in", () => changeLogin(LoginStage.signin)),
                ],
              ),
            ),
            SmallButton("Privacy policy", () => print("Privacy policy"))
          ],
        ),
      ),
    );
  }

  void submit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();

    if (loginStage == LoginStage.signup) {
      widget.store.dispatch(
        UserRegister(
          User(
            id: null,
            email: _formData['email'],
            name: _formData['name'],
            password: _formData['password'],
          ),
          _registerSuccessOrError,
          context,
        ),
      );
    } else {
      widget.store.dispatch(
        UserLogin(
          User(
            email: _formData['email'],
            password: _formData['password'],
          ),
          _loginSuccessOrError,
          context,
        ),
      );
    }
  }

  void _loginSuccessOrError() {
    print("LOGIN");
    UserState userState = widget.store.state.userState;
    if (!userState.authenticated && userState.state == -1) {
      if (userState.error == 'USUARIO_NO_REGISTRADO') {
        changeLogin(LoginStage.signup);
      }
    }
  }

  void _registerSuccessOrError() {
    print("REGISTER");
  }

  Widget signUpOrSignInMessage() {
    String message = "";
    String error = widget.store.state.userState.error;
    if (error != null) {
      if (error == "USUARIO_NO_REGISTRADO")
        message =
            "User not registered. Insert your name to create an account for you.";
    }
    if (message.length > 0) {
      return Container(
        padding: EdgeInsets.only(top: 20),
        child: Text(message),
      );
    }
    return Container();
  }

  Widget _buildSignupOrSignInButtons() {
    return Center(
      child: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          decoration: BoxDecoration(color: Color.fromRGBO(255, 255, 255, 0.5)),
          child: Column(
            children: <Widget>[
              signUpOrSignInMessage(),
              loginStage == LoginStage.signup
                  ? NameTextInput(
                      (String value) => _formData['name'] = value,
                      initialValue: _formData['name'],
                    )
                  : Container(),
              EmailTextInput(
                (String value) => _formData['email'] = value,
                initialValue: _formData['email'],
              ),
              PasswordTextInput(
                (String value) => _formData['password'] = value,
                initialValue: _formData['password'],
              ),
              SizedBox(
                height: 10.0,
              ),
              MainButton(
                loginStage == LoginStage.signup ? "Register" : "Login",
                submit,
                color: Colors.blueGrey,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _loading() {
    return Text("Loading ${_formData['email']}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: loginStage == LoginStage.init
          ? null
          : AppBar(
              actions: <Widget>[
                IconButton(
                  icon: new Icon(Icons.close),
                  onPressed: () => changeLogin(LoginStage.init),
                ),
              ],
              backgroundColor: Colors.blueGrey,
            ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            _buildPageView(),
            loginStage == LoginStage.init
                ? _buildInitButtons()
                : widget.store.state.userState.state <= 0
                    ? _buildSignupOrSignInButtons()
                    : _loading(),
          ],
        ),
      ),
    );
  }
}
