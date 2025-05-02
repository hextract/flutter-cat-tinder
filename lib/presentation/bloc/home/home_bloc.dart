import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import '../../../../core/error/exceptions.dart';
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
    debugPrint('HomeBloc: Handling FetchCatsEvent');
    emit(state.copyWith(isLoadingMore: true, error: null));
    try {
      final cats = await _fetchCats();
      debugPrint('HomeBloc: Fetched ${cats.length} cats');
      emit(state.copyWith(cats: cats, isLoadingMore: false, error: null));
    } catch (e) {
      final errorMessage =
      e is ServerException ? e.message : 'Failed to load cats';
      debugPrint('HomeBloc: Error fetching cats: $errorMessage');
      emit(state.copyWith(isLoadingMore: false, error: errorMessage));
    }
  }

  Future<void> _onCheckLoadMore(
      CheckLoadMoreEvent event, Emitter<HomeState> emit) async {
    debugPrint('HomeBloc: Handling CheckLoadMoreEvent, currentIndex: ${event.currentIndex}');
    if (event.currentIndex >= state.cats.length - _threshold &&
        !state.isLoadingMore) {
      debugPrint('HomeBloc: Loading more cats');
      emit(state.copyWith(isLoadingMore: true, error: null));
      try {
        final newCats = await _fetchCats();
        debugPrint('HomeBloc: Loaded ${newCats.length} new cats');
        emit(state.copyWith(
          cats: [...state.cats, ...newCats],
          isLoadingMore: false,
          error: null,
        ));
      } catch (e) {
        final errorMessage =
        e is ServerException ? e.message : 'Failed to load more cats';
        debugPrint('HomeBloc: Error loading more cats: $errorMessage');
        emit(state.copyWith(isLoadingMore: false, error: errorMessage));
      }
    }
  }
}