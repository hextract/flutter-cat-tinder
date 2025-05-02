import 'package:cat_tinder/core/error/exceptions.dart';
import 'package:cat_tinder/domain/usecases/fetch_cats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchCats fetchCats;
  static const int _threshold = 2;

  HomeBloc(this.fetchCats) : super(HomeState.initial()) {
    on<FetchCatsEvent>(_onFetchCats);
    on<CheckLoadMoreEvent>(_onCheckLoadMore);
  }

  Future<void> _onFetchCats(FetchCatsEvent event, Emitter<HomeState> emit) async {
    print('HomeBloc: Handling FetchCatsEvent');
    emit(state.copyWith(isLoadingMore: true, error: null));
    try {
      final cats = await fetchCats();
      print('HomeBloc: Fetched ${cats.length} cats');
      emit(state.copyWith(cats: cats, isLoadingMore: false));
    } catch (e) {
      final errorMessage = e is ServerException ? e.message : 'Failed to fetch cats';
      print('HomeBloc: Error fetching cats: $errorMessage');
      emit(state.copyWith(isLoadingMore: false, error: errorMessage));
    }
  }

  Future<void> _onCheckLoadMore(CheckLoadMoreEvent event, Emitter<HomeState> emit) async {
    print('HomeBloc: Handling CheckLoadMoreEvent, currentIndex: ${event.currentIndex}');
    if (event.currentIndex >= state.cats.length - _threshold) {
      print('HomeBloc: Loading more cats');
      emit(state.copyWith(isLoadingMore: true, error: null));
      try {
        final newCats = await fetchCats();
        print('HomeBloc: Loaded ${newCats.length} new cats');
        emit(state.copyWith(
          cats: [...state.cats, ...newCats],
          isLoadingMore: false,
        ));
      } catch (e) {
        final errorMessage = e is ServerException ? e.message : 'Failed to load more cats';
        print('HomeBloc: Error loading more cats: $errorMessage');
        emit(state.copyWith(isLoadingMore: false, error: errorMessage));
      }
    }
  }
}