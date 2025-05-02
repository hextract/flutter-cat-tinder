import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/cat.dart';

class DetailCubit extends Cubit<DetailState> {
  DetailCubit(Cat cat)
      : super(DetailState(cat: cat, isLoading: false, error: null));
}

class DetailState {
  final Cat cat;
  final bool isLoading;
  final String? error;

  DetailState({required this.cat, required this.isLoading, this.error});

  DetailState copyWith({Cat? cat, bool? isLoading, String? error}) {
    return DetailState(
      cat: cat ?? this.cat,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DetailState &&
              runtimeType == other.runtimeType &&
              cat == other.cat &&
              isLoading == other.isLoading &&
              error == other.error;

  @override
  int get hashCode => cat.hashCode ^ isLoading.hashCode ^ error.hashCode;
}