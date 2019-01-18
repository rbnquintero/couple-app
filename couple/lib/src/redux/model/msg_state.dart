class MessagesState {
  final bool fetching;
  final String error;
  final List<Message> messages;
  final String chatId;
  MessagesState({this.fetching = false, this.error, this.messages, this.chatId});

  @override
  String toString() {
    return "{fetching:$fetching, error:$error, messages:$messages}";
  }
}

class Message {
  String id;
  final String message;
  final String from;
  final String to;
  String fecha;
  Message({this.id, this.message, this.from, this.to, this.fecha});

  @override
  String toString() {
    return "id:$id, message:$message, from:$from";
  }

/*
  static Message fromMap(String id, Map<String, dynamic> rawMessage) {
    return Message(
        id: rawMessage['objectId'],
        message: rawMessage['message'],
        fecha: rawMessage['createdAt'] != null ? rawMessage['createdAt'] : null,
        from: rawMessage['from'] != null
            ? User.fromJson(rawMessage['from'])
            : null,
        to: rawMessage['to'] != null ? User.fromJson(rawMessage['to']) : null);
  }

  Map<String, dynamic> toJsonForApi() => {
        'message': message,
        'from': User.userToPointer(from),
        'to': User.userToPointer(to)
      };*/
}
