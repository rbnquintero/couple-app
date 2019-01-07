import 'package:couple/src/redux/model/msg_state.dart';

class MessagesFetching {}

class MessagesFetchingError {
  final String error;
  MessagesFetchingError(this.error);
}

class MessagesFetch {
  final List<Message> messages;
  MessagesFetch(this.messages);
}

class SendMessage {
  final String message;
  SendMessage(this.message);
}

class PushMessage {
  final Message message;
  PushMessage(this.message);
}

class PushMessageUpdated {
  final Message message;
  PushMessageUpdated(this.message);
}
