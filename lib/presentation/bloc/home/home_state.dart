import 'package:equatable/equatable.dart';
import '../../../domain/entities/cat.dart';

class HomeState extends Equatable {
  final List<Cat> cats;
  final bool isLoadingMore;
  final String? error;

  const HomeState({
    required this.cats,
    required this.isLoadingMore,
    this.error,
  });

  factory HomeState.initial() => const HomeState(
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

  @override
  List<Object?> get props => [cats, isLoadingMore, error];
}