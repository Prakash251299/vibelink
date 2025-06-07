import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vibe_link/controller/firebase/firebase_call.dart';
import 'package:vibe_link/controller/local_storing/read_write.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/view/Network/chatting/loading_user_img.dart';
import 'package:vibe_link/view/Network/chatting/widget/chat_screen.dart';
import 'package:vibe_link/view/sticky/sticky_widgets.dart';
// import 'package:linkify/controller/store_to_firebase/firebase_call.dart';
// import 'package:linkify/controller/notification/notification_functions.dart';
// import 'package:linkify/view/Network/chatting/widget/chat_screen.dart';
// import 'package:linkify/controller/variables/static_store.dart';
// import 'package:linkify/model/user_info.dart';
// import 'package:linkify/view/Network/chatting/loading_user_img.dart';
// import 'package:linkify/view/sticky/sticky_widgets.dart';

class NetworkUser extends StatefulWidget {
  String title;
  NetworkUser(this.title, {super.key});

  @override
  State<NetworkUser> createState() => _NetworkUserState();
}

class _NetworkUserState extends State<NetworkUser> {
  @override
  void initState() {
    super.initState();
  }

  Widget connectionListShimmer() {
    return SingleChildScrollView(
      // scrollDirection: Axis.horizontal,
      scrollDirection: Axis.vertical,
      // child:
      //     SizedBox(
      //       height: MediaQuery.of(context).size.height,
      child: Shimmer.fromColors(
        baseColor: Colors.grey[850]!,
        highlightColor: Colors.grey[700]!,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[800]),
            ),
            const SizedBox(height: 3),
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (int i = 0;
                        i < MediaQuery.of(context).size.height / 55 + 2;
                        i++) ...{
                      Container(height: 55, color: Colors.grey[800]),
                      const SizedBox(height: 10),
                    },
                  ],
                ),
              ),
            ),
          ],
        ),
        // ),
      ),
      // }
      //   ],
      // ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;
    List<dynamic>? friends;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("${widget.title}", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.black,
        ),
        body: StreamBuilder<List<dynamic>>(
            stream: fetchFriends().asStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return connectionListShimmer();
                // Center(child:CircularProgressIndicator());
              }
              // print(friends?[0].displayName);
              if (snapshot.hasData) {
                friends = snapshot.data;
              } else {
                return Center(
                  child: Text(
                    'No friends available',
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }
              //   print("no data");
              // return SizedBox();
              return Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('spotifyBasedGenreUsers')
                          .snapshots(),
                      builder: (context, snapshot) {
                        return friends?.length != 0
                            ? ListView.builder(
                                scrollDirection: Axis.vertical,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemCount: friends?.length,
                                itemBuilder: (context, index) {
                                  return Column(children: [
                                    Card(
                                      color: Colors.black,
                                      child: Column(children: [
                                        InkWell(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          onTap: () async {
                                            print("For chatting");
                                            // print(friends?[index].email);
                                            ReadWrite _readWrite = ReadWrite();
                                            String currentUserEmail =
                                                await _readWrite.getEmail();
                                            // SharedPreferences _prefs = SharedPreferences();
                                            StaticStore.currentUserEmail =
                                                currentUserEmail;
                                            // print(StaticStore.currentUserEmail);
                                            // return;
                                            List<String?> s = [
                                              currentUserEmail,
                                              friends?[index].email
                                            ];
                                            s.sort();
                                            String messageId =
                                                "${s[0]}_${s[1]}";

                                            Navigator.of(context).push(
                                                PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  ChatScreen(friends![index],
                                                      messageId),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                return FadeTransition(
                                                  opacity: animation,
                                                  child: child,
                                                );
                                              },
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 400),
                                            )
                                                // MaterialPageRoute(
                                                //     builder: (context) =>
                                                //         ChatScreen(
                                                //             friends![index],
                                                //             messageId))
                                                );
                                          },
                                          child: ListTile(
                                            leading: Column(children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(3),
                                                  bottomLeft:
                                                      Radius.circular(3),
                                                ),
                                                child:
                                                    // StaticStore.currentSongImg==""?
                                                    // CachedNetworkImage(imageUrl: ""),
                                                    friends?[index]
                                                                .imgUrl
                                                                ?.length ==
                                                            0
                                                        ? Container(
                                                            width: 55,
                                                            height: 55,
                                                            child:
                                                                const LoadingUserImage(),
                                                          )

                                                        /* For user's friends image */
                                                        : CachedNetworkImage(
                                                            // imageUrl: user.avatar!,

                                                            // imageUrl: friends?[index].imgUrl?.length==2?"${friends?[index].imgUrl?[1]['url']}":"${friends?[index].imgUrl?[0]['url']}",
                                                            imageUrl: friends?[index]
                                                                            .imgUrl !=
                                                                        "" ||
                                                                    friends?[index]
                                                                            .imgUrl !=
                                                                        null
                                                                ? (friends?[
                                                                        index]
                                                                    .imgUrl)
                                                                : null,

                                                            width: 55,
                                                            height: 55,
                                                            memCacheHeight: (55 *
                                                                    devicePexelRatio)
                                                                .round(),
                                                            memCacheWidth: (55 *
                                                                    devicePexelRatio)
                                                                .round(),
                                                            maxHeightDiskCache:
                                                                (55 * devicePexelRatio)
                                                                    .round(),
                                                            maxWidthDiskCache:
                                                                (55 * devicePexelRatio)
                                                                    .round(),
                                                            // progressIndicatorBuilder:
                                                            //     (context, url, l) {
                                                            //           return const LoadingImage();
                                                            //     },
                                                            fit: BoxFit.cover,
                                                          ),
                                              ),
                                            ]),
                                            title: Text(
                                              "${friends?[index].displayName}",
                                              // "${friends[index]?.id}",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            subtitle: Text(
                                              "user",
                                              overflow: TextOverflow.ellipsis,
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            isThreeLine: true,
                                            trailing: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: []),
                                          ),
                                        ),
                                      ]),
                                    ),
                                  ]);
                                },
                              )
                            : Center(child: Text("No friends available"));
                      }),
                  footer(context),
                ],
                //   ),

                // )
              );
            }),
      ),
    );
  }
}
