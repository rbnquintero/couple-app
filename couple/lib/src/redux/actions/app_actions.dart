import 'package:flutter/material.dart';

class InitApp {
  final BuildContext context;
  InitApp(this.context);
}

enum AppInit { started, success, error }

class AppInitialized {
  final BuildContext context;
  AppInitialized(this.context);
}
