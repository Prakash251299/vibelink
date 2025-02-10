import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:vibe_link/controller/local_storing/read_write.dart';
import 'package:vibe_link/controller/store_to_firebase/firebase_call.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/user_info.dart';
import 'package:vibe_link/view/Network/chatting/loading_user_img.dart';
import 'package:vibe_link/view/home/loading.dart';
// import 'package:linkify/controller/store_to_firebase/firebase_call.dart';
// import 'package:linkify/controller/variables/static_store.dart';
// import 'package:linkify/model/user_info.dart';
// import 'package:linkify/view/Network/chatting/loading_user_img.dart';
// import 'package:linkify/view/home/loading.dart';

class ShowmoreSuggestion extends StatefulWidget {
  List<UserInfoMine>? totalUsers;
  String title = "";
  int recommendationIndex=0;
  ShowmoreSuggestion(this.totalUsers, this.title, this.recommendationIndex, {super.key});
  @override
  State<ShowmoreSuggestion> createState() => _ShowmoreSuggestionState();
}

class _ShowmoreSuggestionState extends State<ShowmoreSuggestion> {
  Friends _friends = Friends();

  @override
  Widget build(BuildContext context) {
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("${widget.title}",
            style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
          scrollDirection: Axis.vertical,
          // physics: NeverScrollableScrollPhysics(),
          // itemCount: _recommendedUserInfo!.length<=2?_recommendedUserInfo.length:2,
          itemCount:
              // widget.totalUsers!=null?widget.totalUsers!.length:0,
              widget.totalUsers != null ? widget.totalUsers?.length : 0,
          // itemCount:null,
          itemBuilder: (context, i) {
            return Card(
              color: Colors.black,
              child: Column(children: [
                InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () async {},
                  child: ListTile(
                    leading: Column(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(3),
                          bottomLeft: Radius.circular(3),
                        ),
                        child: widget.totalUsers?[i].imgUrl == null
                            ? Container(
                                width: 55,
                                height: 55,
                                child: const LoadingUserImage(),
                              )
                            : CachedNetworkImage(
                                // imageUrl: user.avatar!,

                                // imageUrl: "${widget._albumTracks?[position].imgUrl}",
                                imageUrl: widget.totalUsers?[i].imgUrl != null
                                    ? widget.totalUsers![i].imgUrl!
                                    : 'https://example.com/default-image.png',
                                // imageUrl: "",

                                width: 55,
                                height: 55,
                                memCacheHeight: (55 * devicePexelRatio).round(),
                                memCacheWidth: (55 * devicePexelRatio).round(),
                                maxHeightDiskCache:
                                    (55 * devicePexelRatio).round(),
                                maxWidthDiskCache:
                                    (55 * devicePexelRatio).round(),
                                progressIndicatorBuilder: (context, url, l) =>
                                    LoadingImage(icon: Icon(LineIcons.user)),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ]),
                    title: Text(
                      // "${widget._albumTracks?[position].name}",
                      "${widget.totalUsers?[i].displayName}",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      "${widget.totalUsers?[i].topArtists}",
                      style: TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                    isThreeLine: true,
                    trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () async {
                              // ReadWrite _readWrite = ReadWrite();
                              // String currentUserEmail = await _readWrite.getEmail();
                              print("friend request sent");
                              // print(widget.totalUsers?[i].email);
                              // print(StaticStore.c);
                              // return;


                              await storeFriendRequest(
                                  widget.totalUsers?[i].email);

                              await _friends
                                  .friendStatusStore(widget.totalUsers?[i].email)
                                  .then((value) {
                                setState(() {
                                  StaticStore.requestStatusValue?[widget.recommendationIndex]?[i] =
                                      widget.totalUsers![i].id.toString();
                                });
                                setState(() {
                                    widget.totalUsers != null
                                        ? StaticStore.requestStatusValue?[widget.recommendationIndex]
                                                ?[i] =
                                            widget.totalUsers![i].id
                                                .toString()
                                        : null;
                                  });
                                print("updated");
                              });
                              print(StaticStore.requestStatusValue?[widget.recommendationIndex]?[i]);
                            },
                            icon: StaticStore.requestStatusValue?[widget.recommendationIndex]?[i] ==
                                        "0" ||
                                    StaticStore.requestStatusValue?[widget.recommendationIndex]?[i] == ""
                                ? Icon(Icons.send, color: Colors.white)
                                : StaticStore.requestStatusValue?[widget.recommendationIndex]?[i] == "1"
                                    ? Icon(
                                        Icons.done_outline,
                                        color: Colors.white,
                                      )
                                    : Icon(Icons.pending, color: Colors.white),
                          )
                        ]),
                  ),
                ),
              ]),
            );
          }),
    );
  }
}
