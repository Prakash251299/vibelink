import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibe_link/controller/home/front_page_data/recommendations.dart';
import 'package:vibe_link/controller/variables/loading_enum.dart';
import 'package:vibe_link/model/home/first_page_categories.dart';
import 'package:vibe_link/view/Network/chatting/modal/mes_info.dart';
// import 'package:linkify/model/home/first_page_categories.dart';
// import 'package:linkify/controller/home/front_page_data/recommendations.dart';
// import '../../../controller/variables/loading_enum.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState.initial());
  void messageFetcher(messageId) {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(messageId)
        .collection("messages")
        .orderBy("timestamp", descending: true)
        .limit(30)
        .snapshots()
        .listen((snapshot) {
          List<Map<String, dynamic>> newMessages = [];

    for (var change in snapshot.docChanges) {
      if (change.type == DocumentChangeType.added) {
        if(change.doc.data()!=null){
          var newMsg = change.doc.data()!;
          newMessages.add(newMsg);
        }
      }
    }

    if (newMessages.isNotEmpty) {
      emit(state.copyWith(
        message: [...state.message, ...newMessages.reversed], // display oldest to newest
        // message: [newMessages],
        status: LoadPage.loaded,
      ));
    }
      // for (var change in snapshot.docChanges) {
      //   if (change.type == DocumentChangeType.added) {
      //     print("new messages");
      //     // print(change.doc.data().runtimeType);
      //     // Map<String,dynamic> newMsg = MesInfo.fromJson(change.doc.data()!);
      //     var newMsg = change.doc.data();
      //     // Map<String,dynamic> newMsg = MesInfo.fromJson(messageData?["message"],messageData?["timestamp"],messageData?[""],messageData?[""],messageData?[""]);
      //     emit(state.copyWith(
      //       message: [...state.message.reversed,newMsg], // add on top
      //       status: LoadPage.loaded,
      //     ));
      //   }
      // }
    });
  }

  Future<void> getMessages(messageId) async {
    try {
      emit(state.copyWith(status: LoadPage.loading));
      messageFetcher(messageId);
    //   FirebaseFirestore.instance
    //     .collection('chats')
    //     .doc(messageId)
    //     .collection("messages")
    //     .orderBy("timestamp", descending: false)
    //     // .limit(30)
    //     .snapshots()
    //     .listen((snapshot) {
    //   for (var change in snapshot.docChanges) {
    //     if (change.type == DocumentChangeType.added) {
    //       print("new messages");
    //       // print(change.doc.data().runtimeType);
    //       // Map<String,dynamic> newMsg = MesInfo.fromJson(change.doc.data()!);
    //       var newMsg = change.doc.data();
    //       // Map<String,dynamic> newMsg = MesInfo.fromJson(messageData?["message"],messageData?["timestamp"],messageData?[""],messageData?[""],messageData?[""]);
    //       emit(state.copyWith(
    //         message: [...state.message,newMsg], // add on top
    //         status: LoadPage.loaded,
    //       ));
    //     }
    //   }
    // });
    } catch (e) {
      print(e.toString());
      print("Error happened at homecubit getalbums function");
      emit(state.copyWith(status: LoadPage.error));
    }
  }
}
