import 'package:redux/redux.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:couple/src/utils/environment.dart';
import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/model/msg_state.dart';
import 'package:couple/src/redux/actions/msg_actions.dart';

List<Middleware<AppState>> createStoreMsgMiddleware() {
  final fetchMessages = _fetchMessages();
  final sendMessage = _sendMessage();
  return [
    TypedMiddleware<AppState, MessagesFetching>(fetchMessages),
    TypedMiddleware<AppState, SendMessage>(sendMessage),
  ];
}

Middleware<AppState> _fetchMessages() {
  return (Store<AppState> store, action, NextDispatcher next) {
    String url = Environment.parseUrl +
        Environment.uriMessagesQuery +
        "?include=from&include=to&order=createdAt";

    http.get(url, headers: Environment.parseHeaders).then((response) {
      if (response.statusCode == 200) {
        Map<String, dynamic> responseMap = json.decode(response.body);
        List<dynamic> results = responseMap['results'];
        List<Message> messages = List();
        Iterator<dynamic> it = results.reversed.iterator;
        while (it.moveNext()) {
          Map<String, dynamic> rawMessage = it.current;
          Message message = Message.fromMap(rawMessage);
          messages.add(message);
        }
        store.dispatch(MessagesFetch(messages));
      } else {
        store.dispatch(MessagesFetchingError("Error al obtener los mensajes"));
      }
    });
    next(action);
  };
}

Middleware<AppState> _sendMessage() {
  return (Store<AppState> store, action, NextDispatcher next) {
    String url = Environment.parseUrl + Environment.uriMessagesQuery;

    Message message = Message(
      message: action.message,
      to: store.state.userState.user.partner,
      from: store.state.userState.user,
    );
    store.dispatch(PushMessage(message));

    http
        .post(url,
            headers: Environment.parseHeaders,
            body: json.encode(message.toJsonForApi()))
        .then((response) {
      if (response.statusCode == 201) {
        print(response.body);
        Map<String, dynamic> responseMap = json.decode(response.body);
        message.id = responseMap['objectId'];
        message.fecha = responseMap['createdAt'];
        store.dispatch(PushMessageUpdated(message));
      }
    });
    next(action);
  };
}
