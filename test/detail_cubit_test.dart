import 'package:cat_tinder/domain/entities/cat.dart';
import 'package:cat_tinder/presentation/bloc/detail/detail_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DetailCubit', () {
    final cat = Cat(
      id: '1',
      url: 'http://example.com/cat.jpg',
      breedName: 'Persian',
      breedDescription: 'Fluffy cat',
      origin: 'Iran',
      temperament: 'Calm',
      lifeSpan: '12-15 years',
      weight: '4 kg',
    );

    test('initializes with correct cat', () {
      final cubit = DetailCubit(cat);

      expect(cubit.state, DetailState(cat: cat, isLoading: false, error: null));
    });
  });
}