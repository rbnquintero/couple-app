import 'dart:io';

import 'package:couple/src/redux/model/msg_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessagesChatId {
  final String chatId;
  MessagesChatId(this.chatId);
}

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
  final File image;
  final int type; // type: 0 = text, 1 = image, 2 = sticker
  SendMessage(this.message, {this.type = 0, this.image});
}

class PushMessage {
  final Message message;
  PushMessage(this.message);
}

class PushMessageUpdated {
  final Message message;
  PushMessageUpdated(this.message);
}

class RequestMessagesDataEventsAction {
  final String chatId;
  final String lastDataId;
  RequestMessagesDataEventsAction(this.chatId, this.lastDataId);
}

class CancelMessagesDataEventsAction {}

class ProcessMessages {
  final List<DocumentSnapshot> rawMessages;
  ProcessMessages(this.rawMessages);
}
