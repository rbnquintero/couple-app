class MessagesState {
  final bool fetching;
  final String error;
  final List<Message> messages;
  final String chatId;
  MessagesState({
    this.fetching = false,
    this.error,
    this.messages,
    this.chatId,
  });

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
  final int type;
  Message(
      {this.id, this.message, this.from, this.to, this.fecha, this.type = 0});

  @override
  bool operator ==(o) => o is Message && o.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return "id:$id, message:$message, from:$from";
  }
}
