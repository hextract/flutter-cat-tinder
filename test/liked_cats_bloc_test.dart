import 'package:bloc_test/bloc_test.dart';
import 'package:cat_tinder/domain/entities/cat.dart';
import 'package:cat_tinder/domain/usecases/get_breeds.dart';
import 'package:cat_tinder/domain/usecases/manage_liked_cats.dart';
import 'package:cat_tinder/presentation/bloc/liked_cats/liked_cats_bloc.dart';
import 'package:cat_tinder/presentation/bloc/liked_cats/liked_cats_event.dart';
import 'package:cat_tinder/presentation/bloc/liked_cats/liked_cats_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockManageLikedCats extends Mock implements ManageLikedCats {}
class MockGetBreeds extends Mock implements GetBreeds {}

void main() {
  late LikedCatsBloc likedCatsBloc;
  late MockManageLikedCats mockManageLikedCats;
  late MockGetBreeds mockGetBreeds;

  setUp(() {
    mockManageLikedCats = MockManageLikedCats();
    mockGetBreeds = MockGetBreeds();
    likedCatsBloc = LikedCatsBloc(mockManageLikedCats, mockGetBreeds);
  });

  tearDown(() {
    likedCatsBloc.close();
  });

  group('LikedCatsBloc', () {
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

    blocTest<LikedCatsBloc, LikedCatsState>(
      'emits loading and cats on successful load',
      build: () {
        when(() => mockManageLikedCats.getLikedCats())
            .thenAnswer((_) async => [cat]);
        when(() => mockGetBreeds()).thenAnswer((_) async => ['Persian']);
        return likedCatsBloc;
      },
      act: (bloc) => bloc.add(LoadLikedCatsEvent()),
      expect: () => [
        LikedCatsState.initial().copyWith(isLoading: true),
        LikedCatsState(
          cats: [cat],
          availableBreeds: ['Persian'],
          selectedBreed: null,
          isLoading: false,
          error: null,
        ),
      ],
      verify: (_) {
        verify(() => mockManageLikedCats.getLikedCats()).called(1);
        verify(() => mockGetBreeds()).called(1);
      },
    );

    blocTest<LikedCatsBloc, LikedCatsState>(
      'emits filtered cats on filter event',
      build: () {
        when(() => mockManageLikedCats.getLikedCats())
            .thenAnswer((_) async => [cat]);
        return likedCatsBloc;
      },
      seed: () => LikedCatsState(
        cats: [cat],
        availableBreeds: ['Persian'],
        selectedBreed: null,
        isLoading: false,
        error: null,
      ),
      act: (bloc) => bloc.add(FilterLikedCatsEvent('Persian')),
      expect: () => [
        LikedCatsState(
          cats: [cat],
          availableBreeds: ['Persian'],
          selectedBreed: null,
          isLoading: true,
          error: null,
        ),
        LikedCatsState(
          cats: [cat],
          availableBreeds: ['Persian'],
          selectedBreed: 'Persian',
          isLoading: false,
          error: null,
        ),
      ],
      verify: (_) => verify(() => mockManageLikedCats.getLikedCats()).called(1),
    );

    blocTest<LikedCatsBloc, LikedCatsState>(
      'emits updated cats on remove liked cat',
      build: () {
        when(() => mockManageLikedCats.removeLikedCat('1'))
            .thenAnswer((_) async {});
        when(() => mockManageLikedCats.getLikedCats())
            .thenAnswer((_) async => []);
        when(() => mockGetBreeds()).thenAnswer((_) async => []);
        return likedCatsBloc;
      },
      seed: () => LikedCatsState(
        cats: [cat],
        availableBreeds: ['Persian'],
        selectedBreed: null,
        isLoading: false,
        error: null,
      ),
      act: (bloc) => bloc.add(RemoveLikedCatEvent('1')),
      expect: () => [
        LikedCatsState(
          cats: [cat],
          availableBreeds: ['Persian'],
          selectedBreed: null,
          isLoading: true,
          error: null,
        ),
        LikedCatsState(
          cats: [],
          availableBreeds: [],
          selectedBreed: null,
          isLoading: false,
          error: null,
        ),
      ],
      verify: (_) {
        verify(() => mockManageLikedCats.removeLikedCat('1')).called(1);
        verify(() => mockManageLikedCats.getLikedCats()).called(1);
        verify(() => mockGetBreeds()).called(1);
      },
    );
  });
}