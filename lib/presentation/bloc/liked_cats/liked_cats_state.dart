import '../../../domain/entities/cat.dart';

class LikedCatsState {
  final List<Cat> cats;
  final List<String> availableBreeds;
  final String? selectedBreed;
  final String? error;

  LikedCatsState({
    required this.cats,
    required this.availableBreeds,
    this.selectedBreed,
    this.error,
  });

  factory LikedCatsState.initial() => LikedCatsState(
        cats: [],
        availableBreeds: [],
        selectedBreed: null,
        error: null,
      );

  LikedCatsState copyWith({
    List<Cat>? cats,
    List<String>? availableBreeds,
    String? selectedBreed,
    String? error,
  }) {
    return LikedCatsState(
      cats: cats ?? this.cats,
      availableBreeds: availableBreeds ?? this.availableBreeds,
      selectedBreed: selectedBreed ?? this.selectedBreed,
      error: error ?? this.error,
    );
  }
}
