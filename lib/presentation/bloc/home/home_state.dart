import '../../../domain/entities/cat.dart';

class HomeState {
  final List<Cat> cats;
  final bool isLoadingMore;
  final String? error;

  HomeState({
    required this.cats,
    required this.isLoadingMore,
    this.error,
  });

  factory HomeState.initial() => HomeState(
        cats: [],
        isLoadingMore: false,
        error: null,
      );

  HomeState copyWith({
    List<Cat>? cats,
    bool? isLoadingMore,
    String? error,
  }) {
    return HomeState(
      cats: cats ?? this.cats,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error ?? this.error,
    );
  }
}
