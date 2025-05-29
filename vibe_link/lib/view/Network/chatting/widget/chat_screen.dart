import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
// import 'package:get/get.dart';
import 'package:vibe_link/controller/firebase/firebase_call.dart';
import 'package:vibe_link/controller/variables/loading_enum.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/user_info.dart';
// import 'package:vibe_link/model/user_info.dart';
import 'package:vibe_link/view/Network/chatting/controller/image_video_picker.dart';
import 'package:vibe_link/view/Network/chatting/loading_user_img.dart';
import 'package:vibe_link/view/Network/chatting/modal/mes_info.dart';
import 'package:vibe_link/view/Network/chatting/widget/cubit_state/chat_cubit.dart';
import 'package:vibe_link/view/Network/chatting/widget/message_card.dart';

// class ChatScreen extends StatefulWidget {
//   UserInfoMine receiverInfo;
//   String messageId;
//   ChatScreen(this.receiverInfo, this.messageId, {super.key});

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

class ChatScreen extends StatelessWidget {
  // ChatScreen({super.key});
  UserInfoMine receiverInfo;
  String messageId;
  ChatScreen(this.receiverInfo, this.messageId, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

// class _ChatScreenState extends State<ChatScreen> {

  final ScrollController _scrollController = ScrollController();

  TextEditingController _textController = TextEditingController();
  FirebaseCall _firebaseCall = FirebaseCall();

  @override
  void initState() {
    // TODO: implement initState
  }

  Widget chatScreenWidget() {
    String prevDate = "1 Jan 1999";
    return BlocProvider(
        create: (context) => ChatCubit()..getMessages(messageId),
        child: BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
          print("chat homescreen");
          
          if (state.status == LoadPage.loading) {
            
            return Container(
                height: 50, child: Center(child: CircularProgressIndicator()));
          }
          if (state.status == LoadPage.loaded) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollToBottom();
            });
            //   return Text("hgjk");
            // }

            // print(data.data());
            List<dynamic> currentMessageList = state.message;
            print(
                "Latest messages: ${currentMessageList[currentMessageList.length - 1]}");
            // if(_scrollController.position!=_scrollController.position.maxScrollExtent){}
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // if (_scrollController.hasClients) {
              double maxScroll = _scrollController.position.maxScrollExtent;
              double currentScroll = _scrollController.position.pixels;
              // const threshold = 0.0; // You can adjust this
              print("currScroll: $currentScroll");
              print("Max scroll: $maxScroll");

              if (currentScroll+150 >= maxScroll) {
                _scrollToBottom();
              }
              // if ((maxScroll - currentScroll).abs() < threshold) {
              //   _scrollToBottom();
              // }
              // }
              // _scrollToBottom();
            });
            if (currentMessageList.isNotEmpty) {
              return ListView.builder(
                  // reverse: true,
                  // shrinkWrap: true,
                  controller: _scrollController,
                  scrollDirection: Axis.vertical,
                  itemCount: currentMessageList.length + 1,
                  // physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    int addDate=0;
                    if (index == currentMessageList.length) {
                      return SizedBox(
                        height: 0,
                      );
                    }
                    var dateTime = DateTime.fromMillisecondsSinceEpoch(
                        currentMessageList[index]["timestamp"]);
                    String time = DateFormat('hh:mm a').format(dateTime);
                    String date = DateFormat('dd MMM yyyy').format(dateTime);
                    if(date!=prevDate){
                      prevDate = date;
                      addDate = 1;
                    }
                    if (time[0] == '0') {
                      time = time.substring(1);
                    }
                    MesInfo mesInfo =
                        MesInfo.fromJson(currentMessageList[index]);
                    // print("MessageList ${currentMessageList[index]["timestamp"]}");
                    // print("MessageList ${currentMessageList[index]}");
                    // if(currentMessageList[index]){

                    // }
                    print("Total messages: ${currentMessageList.length}");
                    return Column(
                      children: [
                        addDate==1?Container(child: Text("$date")):SizedBox(),
                        MessageCard(
                            // MesInfo.fromJson(currentMessageList[index]),
                            mesInfo,
                            receiverInfo,
                            time),
                      ],
                    );
                  });
            } else {
              return Center(
                child: Text("Say Hello!", style: TextStyle(fontSize: 20)),
              );
            }
          } else {}

          return Center(
            child: Text("Hello there!", style: TextStyle(fontSize: 20)),
          );

          // return Text("Something went wrong please report in the issue box at home screen");
        }));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 12, left: 5, right: 5, bottom: 5),
        child: Scaffold(
            // backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(context),
            ),
            body: Column(
              children: [
                Expanded(
                  child: chatScreenWidget(),
                ),
                _chatInp(context),
              ],
            )),
      ),
    );
  }

  Widget _appBar(context) {
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
          // BorderRadius.only(
          //   topLeft: Radius.circular(3),
          //   bottomLeft: Radius.circular(3),
          // ),
          child:
              // StaticStore.currentSongImg==""?
              // CachedNetworkImage(imageUrl: ""),
              receiverInfo.imgUrl == null
                  ? Container(
                      width: 55,
                      height: 55,
                      child: const LoadingUserImage(),
                    )

                  /* For user's friends image */
                  : CachedNetworkImage(
                      // imageUrl: user.avatar!,

                      imageUrl: "${receiverInfo.imgUrl}",

                      width: 55,
                      height: 55,
                      memCacheHeight: (55 * devicePexelRatio).round(),
                      memCacheWidth: (55 * devicePexelRatio).round(),
                      maxHeightDiskCache: (55 * devicePexelRatio).round(),
                      maxWidthDiskCache: (55 * devicePexelRatio).round(),
                      // progressIndicatorBuilder:
                      //     (context, url, l) {
                      //           return const LoadingImage();
                      //     },
                      fit: BoxFit.cover,
                    ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${receiverInfo.displayName}",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Text(
                "Last seen",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w100),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _scrollToBottom() {
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 3),
      curve: Curves.easeOutCirc,
    );
  }

  Widget _chatInp(context){
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: MediaQuery.of(context).size.height * 0.01),
      child:
          // Column(children: [
          Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.emoji_emotions, color: Colors.blueAccent),
                  ),
                  Expanded(
                    child: TextField(
                      // focusNode: ,
                      keyboardType: TextInputType.multiline,
                      controller: _textController,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Input...",
                        hintStyle: TextStyle(color: Colors.blueAccent),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      await imageVideoPicker(
                          context, receiverInfo, messageId);
                    },
                    icon: Icon(Icons.image, color: Colors.blueAccent),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt_rounded,
                        color: Colors.blueAccent),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      // print("message send option clicked");
                      // print("Current user: ${FirebaseAuth.instance.currentUser?.email}");
                      

                      if (_textController.text.isNotEmpty) {
                        // print(_textController.text);
                        // Timestamp t;
                        // var t = DateTime.fromMillisecondsSinceEpoch(1713196304253);
                        int t = DateTime.now().millisecondsSinceEpoch;
                        var mes = {
                          "message": _textController.text,
                          "timestamp": t,
                          // "timestamp": Timestamp.fromMillisecondsSinceEpoch(t),
                          // "timestamp": Timestamp.now(),
                          "sender": StaticStore.currentUserEmail,
                          "receiver": receiverInfo.email,
                          "status": "sent",
                          "type": "text"
                        };
                        // var k = MesInfo.fromJson(mes);
                        // print(k.timestamp);
                        // List<String?> s = [StaticStore.currentUserId,receiverInfo.id];
                        // s.sort();
                        // String messageId = "${s[0]}_${s[1]}";
                        // print("MessageToSend $mes");
                        await _firebaseCall.storeChats(messageId, mes);
                        _textController.text = '';
                      }
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      //   _scrollToBottom();
                      // });
                    },
                    padding: EdgeInsets.only(
                        top: 10, left: 10, right: 5, bottom: 10),
                    shape: const CircleBorder(),
                    color: Colors.green,
                    child: Icon(Icons.send, color: Colors.white, size: 15),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}