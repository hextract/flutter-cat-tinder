import '../../../domain/entities/cat.dart';

class HomeState {
  final List<Cat> cats;
  final int likeCounter;
  final String? error;
  final bool isLoadingMore;

  const HomeState({
    required this.cats,
    required this.likeCounter,
    this.error,
    required this.isLoadingMore,
  });

  factory HomeState.initial() => const HomeState(
        cats: [],
        likeCounter: 0,
        isLoadingMore: false,
      );

  HomeState copyWith({
    List<Cat>? cats,
    int? likeCounter,
    String? error,
    bool? isLoadingMore,
  }) =>
      HomeState(
        cats: cats ?? this.cats,
        likeCounter: likeCounter ?? this.likeCounter,
        error: error ?? this.error,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      );
}
