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

  Future<List<dynamic>> getAllMessages(messageId)async{
    DocumentSnapshot<Map<String, dynamic>> data = await FirebaseFirestore.instance
            .collection('chats')
            .doc(messageId).get();
    List<dynamic> currentMessageList = data.data()?['messageInfo'];
    return currentMessageList;
  }

  Future<void> getMessages(messageId) async {
    try {
      emit(state.copyWith(status: LoadPage.loading));

      emit(state.copyWith(
        message: await getAllMessages(messageId),
        status: LoadPage.loaded,
      ));
    } catch (e) {
      print(e.toString());
      print("Error happened at homecubit getalbums function");
      emit(state.copyWith(status: LoadPage.error));
    }
  }
}