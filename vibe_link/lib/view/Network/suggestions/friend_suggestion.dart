import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:line_icons/line_icons.dart';
import 'package:vibe_link/controller/Network/fetch_friends.dart';
import 'package:vibe_link/controller/store_to_firebase/firebase_call.dart';
import 'package:vibe_link/controller/variables/loading_enum.dart';
import 'package:vibe_link/controller/variables/static_store.dart';
import 'package:vibe_link/model/user_info.dart';
import 'package:vibe_link/view/Network/chatting/loading_user_img.dart';
import 'package:vibe_link/view/Network/suggestions/cubit/suggestion_cubit.dart';
import 'package:vibe_link/view/Network/suggestions/show_more_suggestion.dart';
import 'package:vibe_link/view/Network/user_network.dart';
import 'package:vibe_link/view/home/loading.dart';
import 'package:vibe_link/view/sticky/sticky_widgets.dart';

class Suggestion extends StatefulWidget {
  // const Suggestion({super.key});

  // List<UserInfo>? bestMatch;
  // List<UserInfo>? goodMatch;
  // List<UserInfo>? allUsers;
  // List<List<UserInfo>?> recommendedUsers;
  // Suggestion(this.bestMatch, this.goodMatch, this.allUsers);
  Suggestion();
  @override
  State<Suggestion> createState() => _SuggestionState();
}

class _SuggestionState extends State<Suggestion> {
  // String requestStatusValue = "0";
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

// class Suggestion extends StatelessWidget {

  @override
  void initState() {
    StaticStore.screen = 2;
    // TODO: implement initState
    // state.recommendedUsers[2] = fetchAllFriends(context) as List<UserInfo>?;
    super.initState();
  }

  // MyWidget _myWidget = MyWidget();
  Friends _friends = Friends();

  Widget people_page(state,recommendationIndex,recommendationType) {
    // return Text("Hello ishu");
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Padding(
        padding: const EdgeInsets.only(left: 18, top: 18.0, bottom: 15),
        child: Text(
          "$recommendationType",
          style: TextStyle(fontSize: 22),
        ),
      ),
      Container(
        height: state.recommendedUsers[recommendationIndex] != null &&
                state.recommendedUsers[recommendationIndex]!.length >= 2
            ? 200
            : 100,
        child: ListView.builder(
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            // itemCount: _recommendedUserInfo!.length<=2?_recommendedUserInfo.length:2,
            itemCount:
                // state.recommendedUsers[2]!=null?state.recommendedUsers[2]!.length:0,

                state.recommendedUsers[recommendationIndex] != null &&
                        state.recommendedUsers[recommendationIndex]!.length >= 2
                    ? 2
                    : 1,
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
                          child: state.recommendedUsers[recommendationIndex]?[i].imgUrl == null
                              ? Container(
                                  width: 55,
                                  height: 55,
                                  child: const LoadingUserImage(),
                                )
                              : CachedNetworkImage(
                                  // imageUrl: user.avatar!,

                                  // imageUrl: "${widget._albumTracks?[position].imgUrl}",
                                  imageUrl:
                                      "${state.recommendedUsers[recommendationIndex]?[i].imgUrl}",
                                  // imageUrl: "",

                                  width: 55,
                                  height: 55,
                                  memCacheHeight:
                                      (55 * devicePexelRatio).round(),
                                  memCacheWidth:
                                      (55 * devicePexelRatio).round(),
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
                        "${state.recommendedUsers[recommendationIndex]?[i].displayName}",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "User",
                        style: TextStyle(color: Colors.white70),
                        overflow: TextOverflow.ellipsis,
                      ),
                      isThreeLine: true,
                      trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () async {
                                print("friend request sent");

                                await storeFriendRequest(
                                    state.recommendedUsers[recommendationIndex]?[i].email);

                                await _friends
                                    .friendStatusStore(
                                        state.recommendedUsers[recommendationIndex]?[i].email)
                                    .then((value) {
                                  setState(() {
                                    state.recommendedUsers[recommendationIndex] != null
                                        ? StaticStore.requestStatusValue?[recommendationIndex]
                                                ?[i] =
                                            state.recommendedUsers[recommendationIndex]![i].id
                                                .toString()
                                        : null;
                                  });
                                  print("updated");
                                });
                                print(StaticStore.requestStatusValue?[recommendationIndex]?[i]);
                              },
                              icon:
                                  // Icon(Icons.send)

                                  StaticStore.requestStatusValue?[recommendationIndex]?[i] ==
                                              "0" ||
                                          StaticStore.requestStatusValue?[recommendationIndex]
                                                  ?[i] ==
                                              ""
                                      ? Icon(Icons.send, color: Colors.white)
                                      : StaticStore.requestStatusValue?[recommendationIndex]
                                                  ?[i] ==
                                              "1"
                                          ? Icon(
                                              Icons.done_outline,
                                              color: Colors.white,
                                            )
                                          : Icon(Icons.watch_later_outlined,
                                              color: Colors.white),
                            )
                          ]),
                    ),
                  ),
                ]),
              );
            }),
      ),
      state.recommendedUsers[recommendationIndex] != null
          ? (state.recommendedUsers[recommendationIndex]!.length > 2
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Text(
                          "show more",
                          style: TextStyle(color: Colors.white),
                        ),
                        onTap: () async {
                          print("$recommendationType show more tapped");
                          if(recommendationIndex==2){
                            List<UserInfoMine> totalUsers =
                            await fetchAllFriends(50); // this value
                            await getRequestStatus(totalUsers, recommendationIndex,50);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context1) => ShowmoreSuggestion(
                                        totalUsers, "$recommendationType",recommendationIndex)));
                            return;
                          }
                          if(recommendationIndex==1){
                            List<UserInfoMine> totalUsers =
                            await fetchGoodMatchFriends(10);
                            await getRequestStatus(totalUsers, recommendationIndex,50);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context1) => ShowmoreSuggestion(
                                        state.recommendedUsers[recommendationIndex], "$recommendationType",recommendationIndex)));
                            return;

                          }
                          if(recommendationIndex==0){
                            List<UserInfoMine> totalUsers =
                            await fetchBestMatchFriends(10);
                            await getRequestStatus(totalUsers, recommendationIndex,50);

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context1) => ShowmoreSuggestion(
                                        state.recommendedUsers[recommendationIndex], "$recommendationType",recommendationIndex)));
                            return;

                          }
                        },
                      )
                    ],
                  ),
                )
              : SizedBox())
          : SizedBox(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // StaticStore.requestStatusValue=[List.filled(state.recommendedUsers[0]!.length, "0"),null,List.filled(state.recommendedUsers[2]!.length, "0")];
    print("Called Suggestion");
    final devicePexelRatio = MediaQuery.of(context).devicePixelRatio;
    return
        // SizedBox();

        BlocProvider(
            create: (context) => SuggestionCubit()..getRecommendedUsers(),
            // create:(_){},
            child: BlocBuilder<SuggestionCubit, SuggestionState>(
                // child: BlocBuilder(
                builder: (context, state) {
                  // return Text("hi");
              // print("recommendedUsers: ${state.recommendedUsers}");
              // return SizedBox();
              if (state.status == LoadPage.loading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state.status == LoadPage.loaded) {
                // print(
                    // "getRecommendedUsers: ${state.recommendedUsers[1]?[0].displayName}");
                return SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      leading: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                      // title: Text("Networks",style: TextStyle(color: Colors.white),),
                      backgroundColor: Colors.black,
                    ),
                    body:
                        state.recommendedUsers[0]?.length == 0 &&
                                state.recommendedUsers[1]?.length == 0 &&
                                state.recommendedUsers[2]?.length == 0
                            ? Center(
                                child: Stack(
                                alignment: Alignment.topCenter,
                                // mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  // friendOptions(context, state.recommendedUsers[2]),
                                  friendOptions(context),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    // crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text("No users available"),
                                    ],
                                  ),
                                  // footer(context),
                                ],
                              ))
                            : Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  // friendOptions(context),
                                  // Container(
                                  //   color: Colors.red,
                                  //   child: footer(context)
                                  // ),
                                  ListView.builder(
                                      itemCount: 1,
                                      itemBuilder: (context1, snapshot1) {
                                        return Stack(
                                          alignment: Alignment.topCenter,
                                          children: [
                                            // friendOptions(context, state.recommendedUsers[2]),

                                            friendOptions(context),

                                            Container(
                                              margin: const EdgeInsets.only(
                                                  top: 40),
                                              child: Column(children: [
                                                

                                                if (state.recommendedUsers[1]
                                                        ?.length !=
                                                    0) ...{
                                                  people_page(state, 1, "Good match"),
                                                },

                                                if (state.recommendedUsers[2]
                                                        ?.length !=
                                                    0) ...{
                                                      people_page(state,2,"All users"),
                                                  // Column(
                                                  //     crossAxisAlignment:
                                                  //         CrossAxisAlignment
                                                  //             .start,
                                                  //     children: [])
                                                }
                                              ]),
                                            ),

                                            // }
                                          ],
                                        );
                                      }
                                      //       );
                                      //   // }
                                      // }
                                      ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height -
                                                120),
                                    // color: Colors.red,
                                    child: friendOptions(context),
                                  ),
                                  StreamBuilder(
                                      stream:
                                          StaticStore.player.playerStateStream,
                                      builder: (context, snapshot1) {
                                        return StaticStore.playing == true ||
                                                StaticStore.pause == true
                                            ?
                                            // Text("hi")
                                            miniplayer(context)
                                            : const SizedBox();
                                      }),
                                  footer(context),
                                ],
                              ),
                  ),
                );
              }
              return SizedBox();
            }));
    // }));
  }
}

/* For Connected people */
Widget friendOptions(context) {
  return GestureDetector(
    child: Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        // color: const Color.fromARGB(255, 217, 194, 192),
        color: Colors.white,
      ),
      child: Center(
          child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18),
            child: Text(
              "Go to connections",
              style: TextStyle(color: Colors.red, fontSize: 18),
            ),
          ),
          Spacer(),
          Container(
            margin: const EdgeInsets.only(right: 18.0),
            child: Row(
              children: [
                Icon(
                  Icons.navigate_next,
                  color: Colors.red,
                ),
              ],
            ),
          ),
        ],
      )),
    ),
    onTap: () async {
      // NetworkFunction _networkFunction = NetworkFunction();
      // List<dynamic> friendIds = await fetchFriends();
      // List<UserInfo> friends = [];
      // UserInfo temp;
      // for (int i = 0; i < friendIds.length; i++) {
      //   temp = await _networkFunction.fetchUserInfo(friendIds[i]);
      //   friends.add(temp);
      // }
      // print("friends option tapped");
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => NetworkUser("Friends")));
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NetworkUser(friends)));
    },
  );
}
