import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/manage_liked_cats.dart';
import '../../../domain/usecases/get_breeds.dart';
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

  void _onLoadLikedCats(
      LoadLikedCatsEvent event, Emitter<LikedCatsState> emit) {
    try {
      final cats = _manageLikedCats.getLikedCats();
      emit(LikedCatsState(
        cats: cats,
        availableBreeds: _getBreeds(cats),
        selectedBreed: null,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to load liked cats: $e'));
    }
  }

  void _onFilterLikedCats(
      FilterLikedCatsEvent event, Emitter<LikedCatsState> emit) {
    try {
      final allCats = _manageLikedCats.getLikedCats();
      final filteredCats =
          _manageLikedCats.getLikedCats(breedFilter: event.breed);
      emit(state.copyWith(
        cats: filteredCats,
        availableBreeds: _getBreeds(allCats),
        selectedBreed: event.breed,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to filter liked cats: $e'));
    }
  }

  void _onRemoveLikedCat(
      RemoveLikedCatEvent event, Emitter<LikedCatsState> emit) {
    try {
      _manageLikedCats.removeLikedCat(event.id);
      final allCats = _manageLikedCats.getLikedCats();
      final availableBreeds = _getBreeds(allCats);
      final filteredCats =
          _manageLikedCats.getLikedCats(breedFilter: state.selectedBreed);
      final selectedBreed = availableBreeds.contains(state.selectedBreed) &&
              filteredCats.isNotEmpty
          ? state.selectedBreed
          : null;

      emit(state.copyWith(
        cats: filteredCats.isEmpty && selectedBreed == null
            ? allCats
            : filteredCats,
        availableBreeds: availableBreeds,
        selectedBreed: selectedBreed,
        error: null,
      ));
    } catch (e) {
      emit(state.copyWith(error: 'Failed to remove liked cat: $e'));
    }
  }
}
