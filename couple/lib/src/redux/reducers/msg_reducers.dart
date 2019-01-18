import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:couple/src/redux/actions/msg_actions.dart';
import 'package:couple/src/redux/model/msg_state.dart';

Reducer<MessagesState> messagesReducer = combineReducers<MessagesState>([
  new TypedReducer<MessagesState, MessagesChatId>(messagesChatId),
  new TypedReducer<MessagesState, MessagesFetching>(messagesReceiving),
  new TypedReducer<MessagesState, MessagesFetchingError>(
      messagesReceivingError),
  new TypedReducer<MessagesState, MessagesFetch>(messagesReceived),
  new TypedReducer<MessagesState, PushMessage>(pushMessage),
  new TypedReducer<MessagesState, PushMessageUpdated>(pushMessageUpdate),
  new TypedReducer<MessagesState, ProcessMessages>(processMessages),
  new TypedReducer<MessagesState, CancelMessagesDataEventsAction>(cleanSlate),
]);

MessagesState messagesChatId(MessagesState msgOldState, MessagesChatId action) {
  return MessagesState(
    fetching: msgOldState.fetching,
    error: msgOldState.error,
    messages: msgOldState.messages,
    chatId: action.chatId,
  );
}

MessagesState messagesReceiving(
    MessagesState msgOldState, MessagesFetching action) {
  return MessagesState(
    fetching: true,
    error: null,
    messages: msgOldState.messages,
    chatId: msgOldState.chatId,
  );
}

MessagesState messagesReceivingError(
    MessagesState msgOldState, MessagesFetchingError action) {
  return MessagesState(
    fetching: false,
    error: action.error,
    messages: msgOldState.messages,
    chatId: msgOldState.chatId,
  );
}

MessagesState messagesReceived(
    MessagesState msgOldState, MessagesFetch action) {
  return MessagesState(
    fetching: false,
    error: null,
    messages: action.messages,
    chatId: msgOldState.chatId,
  );
}

MessagesState pushMessage(MessagesState msgOldState, PushMessage action) {
  List<Message> messages = msgOldState.messages;
  messages.insert(0, action.message);
  return MessagesState(
    fetching: false,
    error: null,
    messages: messages,
    chatId: msgOldState.chatId,
  );
}

MessagesState pushMessageUpdate(
    MessagesState msgOldState, PushMessageUpdated action) {
  List<Message> messages = msgOldState.messages;
  Iterator<dynamic> it = messages.iterator;
  while (it.moveNext()) {
    Message message = it.current;
    if (message.message == action.message.message) {
      message.fecha = action.message.fecha;
      message.id = action.message.id;
      break;
    }
  }
  return MessagesState(
    fetching: false,
    error: null,
    messages: messages,
    chatId: msgOldState.chatId,
  );
}

MessagesState processMessages(
    MessagesState msgOldState, ProcessMessages action) {
  List<Message> messages = List();
  Iterator<DocumentSnapshot> it = action.rawMessages.iterator;
  String lastDay;
  DateFormat formatter = DateFormat('dd MMMM');
  while (it.moveNext()) {
    DocumentSnapshot rawMessage = it.current;
    try {
      String day = formatter.format(DateTime.now());
      if (lastDay == null) {
        lastDay = formatter.format(DateTime.fromMillisecondsSinceEpoch(
            int.tryParse(rawMessage.data['timestamp'])));
      } else if (day != lastDay) {
        Message message = Message(
          id: "-1",
          fecha: day,
        );
        messages.add(message);
      }
    } catch (err) {
      print(err);
    }
    Message message = Message(
      id: rawMessage.documentID,
      to: rawMessage.data['idTo'],
      from: rawMessage.data['idFrom'],
      message: rawMessage.data['content'],
      fecha: rawMessage.data['timestamp'],
    );
    messages.add(message);
  }

  Message message = Message(
    id: "-1",
    fecha: lastDay,
  );
  messages.add(message);
  return MessagesState(
    fetching: false,
    error: null,
    messages: messages,
    chatId: msgOldState.chatId,
  );
}

MessagesState cleanSlate(
    MessagesState msgOldState, CancelMessagesDataEventsAction action) {
  return MessagesState(
    fetching: false,
    error: null,
    messages: [],
    chatId: null,
  );
}
