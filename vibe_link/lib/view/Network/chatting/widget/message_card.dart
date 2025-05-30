// import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/user_info.dart';
import 'package:vibe_link/view/Network/chatting/modal/mes_info.dart';


class MessageCard extends StatelessWidget {
  // MessageCard({super.key});
  MesInfo _mesInfo;
  UserInfoMine _receiverInfo;
  String time;
  MessageCard(this._mesInfo,this._receiverInfo, this.time, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

// class MessageCard extends StatefulWidget {
  
//   // final Message message;
//   // final ChatUser user;
//   // final String message;
//   MesInfo _mesInfo;
//   UserInfoMine _receiverInfo;
//   String time;
//   MessageCard(this._mesInfo,this._receiverInfo, this.time, {super.key});
//   // const MessageCard({super.key,required this.message,required this.user,});
//   @override
//   State<MessageCard> createState() => _MessageCardState();
// }
// // var from = 'prakashpratapsingh2512@gmail.com';
// // var from = 'prakashpratapsingh6@gmail.com';
// class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    // print("MessageState: ${_mesInfo.timestamp.runtimeType}");
    // DateTime dateTime = _mesInfo.timestamp;
    // var date = DateTime.fromMillisecondsSinceEpoch(_mesInfo.timestamp!);
    // String time = time;
    // if(time[0]=='0'){
    //   time = time.substring(1);
    // }
    // print("Date: ${DateFormat('hh:mm a').format(date)}");
    // print("Date: ${DateFormat('dd MMM yyyy').format(date)}");


    return 
    Column(
      children: [
        _mesInfo.sender==_mesInfo.receiver?greenMess(time,context):_mesInfo.sender==StaticStore.currentUserEmail?greenMess(time,context):blueMess(time,context),
      ],
    );
  }

  Widget greenMess(time,context){
    var mq = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment:MainAxisAlignment.spaceBetween,
      children:[
        Row(children:[
          SizedBox(width:mq.width*.04),
          Icon(Icons.done_all_rounded, color: Colors.blue, size: 20),
        ]),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding:EdgeInsets.all(mq.width*.04),
              margin:EdgeInsets.symmetric(horizontal: mq.width*.04,vertical: mq.height*0.01),
              decoration:BoxDecoration(
                color: Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color:Colors.lightBlue),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )
                // borderRadius: BorderRadius.only(
                //   topRight: Radius.circular(30),
                //   topLeft: Radius.circular(30),
                //   bottomLeft: Radius.circular(30),
                // )
              ),
            
              child:_mesInfo.type=="video"?Text("video data",style:TextStyle(fontSize:13,color:Colors.black54),):_mesInfo.type=="image"?Text("image data",style:TextStyle(fontSize:13,color:Colors.black54),):Text("${_mesInfo.message}",style:TextStyle(fontSize:13,color:Colors.black54),),
            
              // child: _mesInfo.message!=""?Text("${_mesInfo.message}",style:TextStyle(fontSize:13,color:Colors.black54),):Text("${_mesInfo.type} data",style:TextStyle(fontSize:13,color:Colors.black54),),
            
              
              // child: Text("${_mesInfo.message}",style:TextStyle(fontSize: 15,color:Colors.black87)),
            ),
            // Row(
            //         mainAxisAlignment: MainAxisAlignment.end,
            //         children:[
            Padding(
              padding:EdgeInsets.only(right:mq.width*.05),
              child: Text("${time}",style: TextStyle(fontSize: 10),),
            ),
                    // ]),
            SizedBox(height: 20,)
          ],
        ),
      ),
      // Text(message.sent,style: TextStyle(fontSize: 13,color:Colors.black54),),
      // SizedBox(height: 5,width:2)
    ]);
  }
  Widget blueMess(time,context){
    var mq = MediaQuery.of(context).size;
    return Row(children:[
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:EdgeInsets.all(mq.width*.04),
              margin:EdgeInsets.symmetric(horizontal: mq.width*.04,vertical: mq.height*0.01),
              decoration:BoxDecoration(
                color: Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color:Colors.lightBlue),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )
              ),
              // child: Text("${_mesInfo.message}",style:TextStyle(fontSize: 15,color:Colors.black87)),
              // child: _mesInfo.message!=""?Text("${_mesInfo.message}",style:TextStyle(fontSize:13,color:Colors.black54),):Text("${_mesInfo.type} data",style:TextStyle(fontSize:13,color:Colors.black54),),
              child:_mesInfo.type=="video"?Text("video data",style:TextStyle(fontSize:13,color:Colors.black54),):_mesInfo.type=="image"?Text("image data",style:TextStyle(fontSize:13,color:Colors.black54),):Text("${_mesInfo.message}",style:TextStyle(fontSize:13,color:Colors.black54),),
            ),
            // Text("${time}",style: TextStyle(fontSize: 10),),
            Padding(
              padding:EdgeInsets.only(left:mq.width*.05),
              child: Text("${time}",style: TextStyle(fontSize: 10),),
            ),
          ],
        ),
      ),
      SizedBox(height: 20,)
    ]);
    
  }
}