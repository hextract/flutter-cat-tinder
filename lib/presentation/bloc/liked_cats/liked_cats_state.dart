import 'package:equatable/equatable.dart';
import '../../../domain/entities/cat.dart';

class LikedCatsState extends Equatable {
  final List<Cat> cats;
  final List<String> availableBreeds;
  final String? selectedBreed;
  final String? error;
  final bool isLoading;

  const LikedCatsState({
    required this.cats,
    required this.availableBreeds,
    this.selectedBreed,
    this.error,
    required this.isLoading,
  });

  factory LikedCatsState.initial() => const LikedCatsState(
        cats: [],
        availableBreeds: [],
        selectedBreed: null,
        error: null,
        isLoading: false,
      );

  LikedCatsState copyWith({
    List<Cat>? cats,
    List<String>? availableBreeds,
    String? selectedBreed,
    String? error,
    bool? isLoading,
  }) {
    return LikedCatsState(
      cats: cats ?? this.cats,
      availableBreeds: availableBreeds ?? this.availableBreeds,
      selectedBreed: selectedBreed ?? this.selectedBreed,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
        cats,
        availableBreeds,
        selectedBreed,
        error,
        isLoading,
      ];
}
