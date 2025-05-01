import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/usecases/get_breeds.dart';
import '../../../../domain/usecases/manage_liked_cats.dart';
import 'liked_cats_event.dart';
import 'liked_cats_state.dart';

class LikedCatsBloc extends Bloc<LikedCatsEvent, LikedCatsState> {
  final ManageLikedCats _manageLikedCats;
  final GetBreeds _getBreeds;

  LikedCatsBloc(this._manageLikedCats, this._getBreeds)
      : super(LikedCatsState(
            cats: [], availableBreeds: [], selectedBreed: null, error: null)) {
    on<LoadLikedCatsEvent>(_onLoadLikedCats);
    on<FilterLikedCatsEvent>(_onFilterLikedCats);
    on<RemoveLikedCatEvent>(_onRemoveLikedCat);
  }

  Future<void> _onLoadLikedCats(
      LoadLikedCatsEvent event, Emitter<LikedCatsState> emit) async {
    try {
      final cats = await _manageLikedCats.getLikedCats();
      final breeds = await _getBreeds();
      emit(state.copyWith(cats: cats, availableBreeds: breeds));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onFilterLikedCats(
      FilterLikedCatsEvent event, Emitter<LikedCatsState> emit) async {
    final selectedBreed = event.breed;
    try {
      final cats = await _manageLikedCats.getLikedCats();
      final filteredCats = selectedBreed == null ||
              !state.availableBreeds.contains(selectedBreed)
          ? cats
          : cats.where((cat) => cat.breedName == selectedBreed).toList();
      emit(state.copyWith(cats: filteredCats, selectedBreed: selectedBreed));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onRemoveLikedCat(
      RemoveLikedCatEvent event, Emitter<LikedCatsState> emit) async {
    try {
      await _manageLikedCats.removeLikedCat(event.id);
      final cats = await _manageLikedCats.getLikedCats();
      final breeds = await _getBreeds();
      emit(state.copyWith(cats: cats, availableBreeds: breeds));
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }
}
