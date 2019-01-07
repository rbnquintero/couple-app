import 'package:couple/src/redux/model/user_state.dart';

class MessagesState {
  final bool fetching;
  final String error;
  final List<Message> messages;
  MessagesState({this.fetching = false, this.error, this.messages});

  @override
  String toString() {
    return "{fetching:$fetching, error:$error, messages:$messages}";
  }
}

class Message {
  String id;
  final String message;
  final User from;
  final User to;
  String fecha;
  Message({this.id, this.message, this.from, this.to, this.fecha});

  @override
  String toString() {
    return "id:$id, message:$message, from:$from";
  }

  static Message fromMap(Map<String, dynamic> rawMessage) {
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
      };
}
