import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../domain/usecases/get_breeds.dart';
import '../../../../domain/usecases/manage_liked_cats.dart';
import 'liked_cats_event.dart';
import 'liked_cats_state.dart';

class LikedCatsBloc extends Bloc<LikedCatsEvent, LikedCatsState> {
  final ManageLikedCats _manageLikedCats;
  final GetBreeds _getBreeds;

  LikedCatsBloc(this._manageLikedCats, this._getBreeds)
      : super(LikedCatsState.initial()) {
    on<LoadLikedCatsEvent>(_onLoadLikedCats);
    on<FilterLikedCatsEvent>(_onFilterLikedCats);
    on<RemoveLikedCatEvent>(_onRemoveLikedCat);
  }

  Future<void> _onLoadLikedCats(
      LoadLikedCatsEvent event, Emitter<LikedCatsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final cats = await _manageLikedCats.getLikedCats();
      final breeds = await _getBreeds();
      emit(state.copyWith(
        cats: cats,
        availableBreeds: breeds,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      final errorMessage = e is ServerException
          ? e.message
          : 'Failed to load liked cats';
      emit(state.copyWith(
        isLoading: false,
        error: errorMessage,
      ));
    }
  }

  Future<void> _onFilterLikedCats(
      FilterLikedCatsEvent event, Emitter<LikedCatsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    final selectedBreed = event.breed;
    try {
      final cats = await _manageLikedCats.getLikedCats();
      final filteredCats = selectedBreed == null ||
          !state.availableBreeds.contains(selectedBreed)
          ? cats
          : cats.where((cat) => cat.breedName == selectedBreed).toList();
      emit(state.copyWith(
        cats: filteredCats,
        selectedBreed: selectedBreed,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      final errorMessage = e is ServerException
          ? e.message
          : 'Failed to filter liked cats';
      emit(state.copyWith(
        isLoading: false,
        error: errorMessage,
      ));
    }
  }

  Future<void> _onRemoveLikedCat(
      RemoveLikedCatEvent event, Emitter<LikedCatsState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      await _manageLikedCats.removeLikedCat(event.id);
      final cats = await _manageLikedCats.getLikedCats();
      final breeds = await _getBreeds();
      final filteredCats = state.selectedBreed == null ||
          !breeds.contains(state.selectedBreed)
          ? cats
          : cats.where((cat) => cat.breedName == state.selectedBreed).toList();
      emit(state.copyWith(
        cats: filteredCats,
        availableBreeds: breeds,
        isLoading: false,
        error: null,
      ));
    } catch (e) {
      final errorMessage = e is ServerException
          ? e.message
          : 'Failed to remove liked cat';
      emit(state.copyWith(
        isLoading: false,
        error: errorMessage,
      ));
    }
  }
}