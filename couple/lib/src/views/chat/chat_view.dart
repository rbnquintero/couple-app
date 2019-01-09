import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:core';

//REDUX
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/model/user_state.dart';
import 'package:couple/src/redux/model/msg_state.dart';
import 'package:couple/src/redux/actions/msg_actions.dart';

class ChatHome extends StatelessWidget {
  static final String route = '/home/chat';
  static final String title = null;

  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(
      builder: (BuildContext context, Store<AppState> store) {
        return new Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                padding: new EdgeInsets.all(8),
                reverse: true,
                itemBuilder: (_, int index) {
                  return MessageCard(store.state.messagesState.messages[index],
                      store.state.userState.user);
                },
                itemCount: store.state.messagesState.messages.length,
              ),
            ),
            MessageForm(store),
          ],
        );
      },
    );
  }
}

class MessageCard extends StatelessWidget {
  final Message message;
  final User user;
  MessageCard(this.message, this.user);
  @override
  Widget build(BuildContext context) {
    String date = "-";
    CrossAxisAlignment align = CrossAxisAlignment.start;
    Radius r = Radius.circular(10);
    BorderRadius radius =
        BorderRadius.only(topLeft: r, topRight: r, bottomRight: r);
    if (message.from.id == user.id) {
      align = CrossAxisAlignment.end;
      radius = BorderRadius.only(topLeft: r, topRight: r, bottomLeft: r);
    }
    if (message.fecha != null) {
      DateFormat formatter = DateFormat('h:mm a');
      DateTime time = DateTime.fromMicrosecondsSinceEpoch(int.tryParse(message.fecha));
      date = formatter.format(time);
    }
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 2),
          padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
          decoration: BoxDecoration(color: Colors.white, borderRadius: radius),
          child: Column(
            crossAxisAlignment: align,
            children: <Widget>[
              Text(message.message),
              SizedBox(height: 5),
              date == '-'
                  ? Icon(
                      Icons.access_time,
                      size: 11,
                    )
                  : Text(
                      date,
                      style: TextStyle(fontSize: 11),
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class MessageForm extends StatefulWidget {
  final Store<AppState> store;
  MessageForm(this.store);

  @override
  State<StatefulWidget> createState() {
    return MessageFormState();
  }
}

class MessageFormState extends State<MessageForm> {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    widget.store.dispatch(SendMessage(text));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextField(
                maxLines: null,
                controller: _textController,
                onChanged: (String text) {
                  setState(() {
                    _isComposing = text.length > 0;
                  });
                },
                onSubmitted: _handleSubmitted,
                decoration:
                    InputDecoration.collapsed(hintText: 'Send a message'),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 4.0),
            child: IconButton(
              icon: Icon(Icons.send),
              onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
