import 'package:redux/redux.dart';

import 'package:couple/src/redux/actions/msg_actions.dart';
import 'package:couple/src/redux/model/msg_state.dart';

Reducer<MessagesState> messagesReducer = combineReducers<MessagesState>([
  new TypedReducer<MessagesState, MessagesFetching>(messagesReceiving),
  new TypedReducer<MessagesState, MessagesFetchingError>(
      messagesReceivingError),
  new TypedReducer<MessagesState, MessagesFetch>(messagesReceived),
  new TypedReducer<MessagesState, PushMessage>(pushMessage),
  new TypedReducer<MessagesState, PushMessageUpdated>(pushMessageUpdate),
]);

MessagesState messagesReceiving(
    MessagesState msgOldState, MessagesFetching action) {
  return MessagesState(
      fetching: true, error: null, messages: msgOldState.messages);
}

MessagesState messagesReceivingError(
    MessagesState msgOldState, MessagesFetchingError action) {
  return MessagesState(
      fetching: false, error: action.error, messages: msgOldState.messages);
}

MessagesState messagesReceived(
    MessagesState msgOldState, MessagesFetch action) {
  return MessagesState(fetching: false, error: null, messages: action.messages);
}

MessagesState pushMessage(MessagesState msgOldState, PushMessage action) {
  List<Message> messages = msgOldState.messages;
  messages.insert(0, action.message);
  return MessagesState(fetching: false, error: null, messages: messages);
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
  return MessagesState(fetching: false, error: null, messages: messages);
}
