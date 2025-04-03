import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/fetch_cats.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchCats _fetchCats;

  HomeBloc(this._fetchCats) : super(HomeState.initial()) {
    on<FetchCatsEvent>(_onFetchCats);
    on<LikeCatEvent>(_onLikeCat);
    on<CheckLoadMoreEvent>(_onCheckLoadMore);
    add(FetchCatsEvent());
  }
  Future<void> _onFetchCats(
      FetchCatsEvent event, Emitter<HomeState> emit) async {
    if (state.isLoadingMore) return;
    emit(state.copyWith(isLoadingMore: true));
    try {
      final cats = await _fetchCats();
      emit(
          state.copyWith(cats: [...state.cats, ...cats], isLoadingMore: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoadingMore: false));
    }
  }

  void _onLikeCat(LikeCatEvent event, Emitter<HomeState> emit) {
    emit(state.copyWith(likeCounter: state.likeCounter + 1));
  }

  void _onCheckLoadMore(CheckLoadMoreEvent event, Emitter<HomeState> emit) {
    if (state.cats.length - event.currentIndex <= 3) {
      add(FetchCatsEvent());
    }
  }
}
