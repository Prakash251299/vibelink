import 'package:bloc/bloc.dart';
import 'package:vibe_link/controller/Network/fetch_friends.dart';
import 'package:vibe_link/controller/variables/loading_enum.dart';
import 'package:vibe_link/model/user_info.dart';
part 'suggestion_state.dart';

class SuggestionCubit extends Cubit<SuggestionState> {
  // final repo = GetHomePage();
  SuggestionCubit() : super(SuggestionState.initial());

  Future<void> getRecommendedUsers() async {
    // print("ishu");
    // return;
    try {
      emit(state.copyWith(status: LoadPage.loading));

      emit(state.copyWith(
        // albums: await repo.getAlbum(),
        // songs: await repo.getSongs(),
        // carouselSongs: await getCarouselSongs(),
        // categories: await fetchCategory(),
        // id: await repo.getId(),
        recommendedUsers: await connectionCaller(),
        status: LoadPage.loaded,
      ));
    } catch (e) {
      // print(e.toString());
      print("Error happened at homecubit in getRecommendedUsers function");
      print(e);
      emit(state.copyWith(status: LoadPage.error));
    }
  }
}