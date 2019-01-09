import 'package:flutter/material.dart';
import 'dart:math';

/** MISC */
class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 5.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

/** BUTTONS */
class MainButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color color;

  MainButton(this.text, this.onPressed, {this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(horizontal: 35),
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
      textColor: Colors.white,
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class SmallButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  SmallButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      color: Color.fromRGBO(0, 0, 0, 0.6),
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
      child: Text(
        text,
        style:
            TextStyle(fontWeight: FontWeight.bold, height: 0.8, fontSize: 11),
      ),
    );
  }
}

class IconLeftButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final IconData icon;

  IconLeftButton(this.text, this.onPressed, {this.icon = Icons.looks_one});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: Colors.white,
      onPressed: onPressed,
      child: Row(
        children: <Widget>[
          Icon(Icons.keyboard_arrow_left),
          SizedBox(
            width: 5,
          ),
          Text(text)
        ],
      ),
    );
  }
}

/** INPUTS */
class NameTextInput extends StatelessWidget {
  final Function onSaved;
  final String initialValue;
  NameTextInput(this.onSaved, {this.initialValue = ""});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      keyboardType: TextInputType.emailAddress,
      initialValue: initialValue,
      validator: (String value) {
        if (value.isEmpty || value.length < 2) {
          return 'Name invalid';
        }
      },
      onSaved: onSaved,
    );
  }
}

class PasswordTextInput extends StatelessWidget {
  final Function onSaved;
  final String initialValue;
  PasswordTextInput(this.onSaved, {this.initialValue = ""});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      initialValue: initialValue,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Password invalid';
        }
      },
      onSaved: onSaved,
    );
  }
}

class EmailTextInput extends StatelessWidget {
  final Function onSaved;
  final String initialValue;
  EmailTextInput(this.onSaved, {this.initialValue = ""});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      keyboardType: TextInputType.emailAddress,
      initialValue: initialValue,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email';
        }
      },
      onSaved: onSaved,
    );
  }
}
