import 'package:redux/redux.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:couple/src/redux/model/app_state.dart';
import 'package:couple/src/redux/model/user_state.dart';
import 'package:couple/src/redux/model/msg_state.dart';
import 'package:couple/src/redux/actions/msg_actions.dart';

import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

final createStoreMsgEpics = combineEpics<AppState>([messagesEpic]);

Stream<dynamic> messagesEpic(
    Stream<dynamic> actions, EpicStore<AppState> store) {
  return Observable(actions)
      .ofType(TypeToken<RequestMessagesDataEventsAction>())
      .flatMap((RequestMessagesDataEventsAction requestAction) {
    return getMessages(requestAction.chatId)
        .map((List<DocumentSnapshot> list) => ProcessMessages(list))
        .takeUntil(actions
            .where((action) => action is CancelMessagesDataEventsAction));
  });
}

Observable<List<DocumentSnapshot>> getMessages(String chatId) {
  return new Observable(Firestore.instance
          .collection("messages")
          .document(chatId)
          .collection(chatId)
          .orderBy('timestamp', descending: true)
          .limit(20)
          .snapshots())
      .map((QuerySnapshot query) => query.documents);
}

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
    User partner = store.state.userState.user.partner;
    User user = store.state.userState.user;

    String groupChatId = "";
    if (user.id.hashCode <= partner.id.hashCode) {
      groupChatId = '${user.id}-${partner.id}';
    } else {
      groupChatId = '${partner.id}-${user.id}';
    }

    store.dispatch(MessagesChatId(groupChatId));

    store.dispatch(RequestMessagesDataEventsAction(groupChatId));

    next(action);
  };
}

Middleware<AppState> _sendMessage() {
  return (Store<AppState> store, action, NextDispatcher next) {
    User partner = store.state.userState.user.partner;
    User user = store.state.userState.user;

    Message message = Message(
      message: action.type == 0 ? action.message : action.image.path,
      to: partner.id,
      from: user.id,
    );
    store.dispatch(PushMessage(message));

    String groupChatId = "";
    if (user.id.hashCode <= partner.id.hashCode) {
      groupChatId = '${user.id}-${partner.id}';
    } else {
      groupChatId = '${partner.id}-${user.id}';
    }

    if (action.type == 1) {
      String fileName =
          user.id + DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference reference =
          FirebaseStorage.instance.ref().child(fileName);
      reference
          .putFile(action.image)
          .onComplete
          .then((StorageTaskSnapshot val) {
        val.ref.getDownloadURL().then((downloadUrl) {
          Firestore.instance
              .collection('messages')
              .document(groupChatId)
              .collection(groupChatId)
              .document(DateTime.now().millisecondsSinceEpoch.toString())
              .setData({
            'idFrom': user.id,
            'idTo': partner.id,
            'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
            'content': downloadUrl,
            'type': action.type,
          }).then((result) {
            message.id = DateTime.now().millisecondsSinceEpoch.toString();
            message.fecha = DateTime.now().millisecondsSinceEpoch.toString();
            store.dispatch(PushMessageUpdated(message));
          }).catchError((error) {
            print("error");
          });
        });
      });
    } else if (action.type == 0) {
      Firestore.instance
          .collection('messages')
          .document(groupChatId)
          .collection(groupChatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString())
          .setData({
        'idFrom': user.id,
        'idTo': partner.id,
        'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
        'content': action.message,
        'type': action.type,
      }).then((result) {
        message.id = DateTime.now().millisecondsSinceEpoch.toString();
        message.fecha = DateTime.now().millisecondsSinceEpoch.toString();
        store.dispatch(PushMessageUpdated(message));
      }).catchError((error) {
        print("error");
      });
    }

    next(action);
  };
}
