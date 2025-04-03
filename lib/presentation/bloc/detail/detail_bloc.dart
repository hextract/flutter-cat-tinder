import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/cat.dart';

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  DetailBloc(Cat cat)
      : super(DetailState(cat: cat, isLoading: false, error: null)) {
    on<LoadDetailEvent>(_onLoadDetail);
  }

  void _onLoadDetail(LoadDetailEvent event, Emitter<DetailState> emit) {
    emit(state.copyWith(isLoading: false));
  }
}

abstract class DetailEvent {}

class LoadDetailEvent extends DetailEvent {}

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
}
