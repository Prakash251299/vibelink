// import 'package:vibe_link/controller/variables/loading_enum.dart';
part of 'chat_cubit.dart';

class ChatState {
  final LoadPage status;
  List<dynamic>message;
  // final List<User> users;
  // final List<SongModel>? songs;
  // final List<AlbumModeling>? albums;

  // Map<String,List<dynamic>>? carouselSongs;
  // List<FrontPageCategories>? categories=[];
  // final List<String>? id;
  ChatState({
    required this.status,
    required this.message,
    // required this.users,
    // this.carouselSongs,
    // this.categories,
    // this.id,
  });
  factory ChatState.initial() {
    return ChatState(
      // name: 
      // id: [],
      // likedTrack:{},
      status: LoadPage.initial,
      message: []
      // users: [],
    );
  }

  ChatState copyWith({
    LoadPage? status,
    List<dynamic>? message,
    // Map<String,List<dynamic>>?carouselSongs,
    // List<FrontPageCategories>? categories,
    // List<String>?id,
    // List<AlbumModeling>? albums,
    // List<SongModel>? songs,
  }) {
    return ChatState(
      status: status ?? this.status,
      message: message ?? this.message,
      // users: users ?? this.users,
      // songs: songs ?? this.songs,
      // carouselSongs: carouselSongs ?? this.carouselSongs,
      // categories: categories ?? this.categories,
      // id: id ?? this.id,
    );
  }
}
