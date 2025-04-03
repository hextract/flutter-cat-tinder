import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/fetch_cats.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchCats _fetchCats;

  HomeBloc(this._fetchCats) : super(HomeState.initial()) {
    on<FetchCatsEvent>(_onFetchCats);
    on<CheckLoadMoreEvent>(_onCheckLoadMore);
    add(FetchCatsEvent());
  }

  Future<void> _onFetchCats(FetchCatsEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isLoadingMore: true));
    try {
      final newCats = await _fetchCats();
      emit(state.copyWith(
        cats: [...state.cats, ...newCats],
        isLoadingMore: false,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoadingMore: false,
        error: 'Failed to load cats: $e',
      ));
    }
  }

  void _onCheckLoadMore(CheckLoadMoreEvent event, Emitter<HomeState> emit) {
    if (event.currentIndex >= state.cats.length - 3 && !state.isLoadingMore) {
      add(FetchCatsEvent());
    }
  }
}