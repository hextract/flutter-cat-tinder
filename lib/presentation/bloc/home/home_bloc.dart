import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/fetch_cats.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchCats _fetchCats;
  static const int _threshold = 8;

  HomeBloc(this._fetchCats)
      : super(HomeState(cats: [], isLoadingMore: false, error: null)) {
    on<FetchCatsEvent>(_onFetchCats);
    on<CheckLoadMoreEvent>(_onCheckLoadMore);
  }

  Future<void> _onFetchCats(
      FetchCatsEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoadingMore: true));
    try {
      final cats = await _fetchCats();
      emit(state.copyWith(cats: cats, isLoadingMore: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoadingMore: false));
    }
  }

  Future<void> _onCheckLoadMore(
      CheckLoadMoreEvent event, Emitter<HomeState> emit) async {
    if (event.currentIndex >= state.cats.length - _threshold &&
        !state.isLoadingMore) {
      emit(state.copyWith(isLoadingMore: true));
      try {
        final newCats = await _fetchCats();
        emit(state
            .copyWith(cats: [...state.cats, ...newCats], isLoadingMore: false));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), isLoadingMore: false));
      }
    }
  }
}
