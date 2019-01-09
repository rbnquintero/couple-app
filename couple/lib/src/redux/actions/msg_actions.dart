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
  final int type; // type: 0 = text, 1 = image, 2 = sticker
  SendMessage(this.message, {this.type = 0});
}

class PushMessage {
  final Message message;
  PushMessage(this.message);
}

class PushMessageUpdated {
  final Message message;
  PushMessageUpdated(this.message);
}
