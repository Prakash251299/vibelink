import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:spotify/spotify.dart';
import 'package:vibe_link/controller/local_storing/read_write.dart';
import 'package:vibe_link/controller/store_to_firebase/firebase_call.dart';
import 'package:vibe_link/model/artist.dart';
import 'package:vibe_link/view/home/bottom_nav_bar.dart';

class PickArtistPage extends StatefulWidget {
  const PickArtistPage({super.key});

  @override
  State<PickArtistPage> createState() => _PickArtistPageState();
}

class _PickArtistPageState extends State<PickArtistPage> {
  List<ArtistModal> artists = [];
  List<String> temp = [];
  List<int> selected = [];
  bool _isLoading = false;
  String? accessToken = "";

  ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    loadInitialArtists();
    controller.addListener(() {
      if (controller.offset >= controller.position.maxScrollExtent - 200) {
        setState(() {
          _isLoading = true;
        });
        fetchArtist(artists.length);
      }
    });
  }

  Future<void> loadInitialArtists() async {
    ReadWrite _readWrite = ReadWrite();
    String clientId = '97c3e7bd62554a2089e037cb7c1f8836';
    String clientSecret = 'b6609e7258154766822ca43565fa8932';
    final credentials = SpotifyApiCredentials(clientId, clientSecret);
    final spotify = SpotifyApi(credentials);
    accessToken = (await spotify.getCredentials()).accessToken;
    if (accessToken != null && accessToken != "") {
      await _readWrite.writeAccessToken(accessToken!);
    }
    await fetchArtist(0);
    return;
  }

  Future<int> fetchArtist(offset) async {
    ReadWrite _readWrite = ReadWrite();
    accessToken = await _readWrite.getAccessToken();
    int t = 0;
    while (true) {
      try {
        if (_isLoading) return 0;
        if (mounted) {
        setState(() {
          _isLoading = true;
        });}
        var res = await get(Uri.parse(
            'https://api.spotify.com/v1/search?q=popular&type=artist&limit=50&offset=$offset&access_token=$accessToken'));

        if (res.statusCode != 200) {
          print(
              'Error occured at fetchArtistPage with statuscode: ${res.statusCode}');
          if (res.statusCode == 429) {
            // for making api request wait for making next request
            await Future.delayed(const Duration(seconds: 3));
            continue;
          }
          return 0;
        }
        var data = jsonDecode(res.body);
        var artistsInfo = data['artists']['items'];

        await artistsInfo.forEach((v) {
          if (v != null &&
              !v['name'].contains('popular') &&
              !v['name'].contains('Popular') &&
              !v['name'].contains('POPULAR')) {
            // print(v['name']);
            if (v['name'] != null &&
                v['id'] != null &&
                v['images'] != null &&
                v['images'].length != 0 &&
                !temp.contains(v['name'])) {
              artists
                  .add(ArtistModal(v['name'], v['id'], v['images'][0]['url']));
              temp.add(v['name']);
              selected.add(0);
            }
            t = 0;
          }
        });
      } catch (e) {
        t++;
        if (t == 1) {
          print('Error occured with access token in pick_artist.dart file');
          return 0;
        }
        String clientId = '97c3e7bd62554a2089e037cb7c1f8836';
        String clientSecret = 'b6609e7258154766822ca43565fa8932';
        final credentials = SpotifyApiCredentials(clientId, clientSecret);
        final spotify = SpotifyApi(credentials);
        accessToken = (await spotify.getCredentials()).accessToken;
        if (accessToken != null && accessToken != "") {
          await _readWrite.writeAccessToken(accessToken!);
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
    // return 0;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  var optionColor = Color.fromARGB(255, 50, 76, 79);
  int count=0;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Artists',
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('Select artists',style: TextStyle(color: Colors.white),),
            actions: [
              Opacity(
                opacity: count>=3?1:0.3,
                child: InkWell(
                  child: Container(
                      height: 40,
                      // width:menuWidth==200?menuWidth:200,
                      width: 100,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.brown,
                      ),
                      child: const Center(
                          child: Text(
                        "Done",
                        style: TextStyle(color: Colors.white),
                      ))),
                  onTap: () async {
                    if(count<3){
                      return;
                    }
                    print("saving user artists");
                    // return;
                    /* User's artists are stored in firestore */
                    FirebaseCall _firebaseCall = FirebaseCall();
                    List<String?>artistIds=[];
                    
                    for(int i=0;i<selected.length;i++){
                      selected[i]==1&&artists[i].id!=null?artistIds.add(artists[i].id):null;
                    }
                    await _firebaseCall.storeUserData(artistIds); // it stores user's info
                    await _firebaseCall.getUserArtistsWithGenrePercentage();
                    await _firebaseCall.storeUserWithGenrePercentage();
                    // controller.dispose();
                    Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=>App()));
                  },
                ),
              )
              // :SizedBox(),
              ],
          ),
          backgroundColor: Colors.black,
          body: Stack(
            alignment: Alignment.topRight,
            children: [
              GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.6,
                ),
                controller: controller,
                itemCount: artists.length + (_isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (_isLoading && artists.length == index) {
                    return Center(child: CircularProgressIndicator());
                  } else
                    // if (index < artists.length) {
                    return GestureDetector(
                        child: Card(
                          color: Colors.black,
                          margin: EdgeInsets.all(8),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Stack(alignment: Alignment.center, children: [
                                  Container(
                                    width: 200, // Set your desired width
                                    height: 250, // Set your desired height
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        opacity: selected[index] == 1 ? 0.5 : 1,
                                        image: NetworkImage(
                                            '${artists[index].imgUrl}'),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: BorderRadius.circular(
                                          10), // Optional: Add rounded corners
                                      border: Border.all(
                                          color: Colors.black,
                                          width: 2), // Optional: Add border
                                    ),
                                  ),
                                  selected[index] == 1
                                      ? Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        )
                                      : SizedBox(),
                                ]),
                                Text(
                                  '${artists[index].name}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ]),
                        ),
                        onTap: () {
                          if (selected[index] == 0) {
                            setState(() {
                              selected[index] = 1;
                              count++;
                            });
                          } else {
                            setState(() {
                              count--;
                              selected[index] = 0;
                            });
                          }
                        });
                  // } else {
                  //   return Center(child: CircularProgressIndicator());
                  // }
                },
              ),
              // InkWell(
              //   child: Container(
              //       height: 40,
              //       // width:menuWidth==200?menuWidth:200,
              //       width: 200,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.all(Radius.circular(5)),
              //         color: optionColor,
              //       ),
              //       child: Center(
              //           child: Text(
              //         "Done",
              //         style: TextStyle(color: Colors.white),
              //       ))),
              //   onTap: () async {},
              // ),
              // // )
            ],
          ),
        ),
      ),
      // )

      // Scaffold(
      //   appBar: AppBar(
      //     title: const Text('Artists',style: TextStyle(color: Colors.white),),
      //     backgroundColor: Colors.black,
      //   ),
      //   backgroundColor: Colors.black,
      //   body: Column(
      //   children: [
      //     Expanded(
      //       child: GridView.builder(
      //         controller: _scrollController,
      //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //           crossAxisCount: 2, // Number of columns
      //           childAspectRatio: 1.0, // Aspect ratio of grid items
      //         ),
      //         itemCount: artists.length + (_isLoading ? 1 : 0),
      //         itemBuilder: (context, index) {
      //           if (index < artists.length) {
      //             return Card(
      //               margin: EdgeInsets.all(8),
      //               child: Center(
      //                 child: Text(
      //                   // 'Item ${artists[index].name}',
      //                   'Item $index}',
      //                   style: TextStyle(fontSize: 16),
      //                 ),
      //               ),
      //             );
      //           } else {
      //             return Center(child: CircularProgressIndicator());
      //           }
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      // ),
    );
  }
}
