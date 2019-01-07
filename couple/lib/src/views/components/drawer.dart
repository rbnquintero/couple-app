import 'package:flutter/material.dart';

class CoupleDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Text('Couple'),
            ),
          ),
        ],
      ),
    );
  }
}
