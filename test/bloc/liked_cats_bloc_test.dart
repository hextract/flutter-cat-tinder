import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../lib/domain/entities/cat.dart';
import '../../lib/domain/usecases/manage_liked_cats.dart';
import '../../lib/domain/usecases/get_breeds.dart';
import '../../lib/presentation/bloc/liked_cats/liked_cats_bloc.dart';
import '../../lib/presentation/bloc/liked_cats/liked_cats_event.dart';
import '../../lib/presentation/bloc/liked_cats/liked_cats_state.dart';

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

  final testCat = Cat(
    id: '1',
    url: 'https://example.com/cat1.jpg',
    breedName: 'Persian',
    breedDescription: 'Fluffy cat',
    origin: 'Persia',
    temperament: 'Calm',
    lifeSpan: '12-15 years',
    weight: '4.5',
    likedAt: DateTime.now(),
  );

  final testBreeds = ['Persian', 'Siamese'];

  group('LikedCatsBloc', () {
    blocTest<LikedCatsBloc, LikedCatsState>(
      'emits [cats loaded, breeds loaded] when LoadLikedCatsEvent is added',
      build: () {
        when(() => mockManageLikedCats.getLikedCats())
            .thenAnswer((_) async => [testCat]);
        when(() => mockGetBreeds()).thenAnswer((_) async => testBreeds);
        return likedCatsBloc;
      },
      act: (bloc) => bloc.add(LoadLikedCatsEvent()),
      expect: () => [
        LikedCatsState(
            cats: [testCat],
            availableBreeds: [],
            selectedBreed: null,
            error: null),
        LikedCatsState(
            cats: [testCat],
            availableBreeds: testBreeds,
            selectedBreed: null,
            error: null),
      ],
      verify: (_) {
        verify(() => mockManageLikedCats.getLikedCats()).called(1);
        verify(() => mockGetBreeds()).called(1);
      },
    );

    blocTest<LikedCatsBloc, LikedCatsState>(
      'emits [filtered cats] when FilterLikedCatsEvent is added',
      build: () {
        when(() => mockManageLikedCats.getLikedCats())
            .thenAnswer((_) async => [testCat]);
        when(() => mockGetBreeds()).thenAnswer((_) async => testBreeds);
        return likedCatsBloc;
      },
      act: (bloc) => bloc
        ..add(LoadLikedCatsEvent())
        ..add(FilterLikedCatsEvent('Persian')),
      expect: () => [
        LikedCatsState(
            cats: [testCat],
            availableBreeds: [],
            selectedBreed: null,
            error: null),
        LikedCatsState(
            cats: [testCat],
            availableBreeds: testBreeds,
            selectedBreed: null,
            error: null),
        LikedCatsState(
            cats: [testCat],
            availableBreeds: testBreeds,
            selectedBreed: 'Persian',
            error: null),
      ],
    );

    blocTest<LikedCatsBloc, LikedCatsState>(
      'emits [updated cats] when RemoveLikedCatEvent is added',
      build: () {
        when(() => mockManageLikedCats.getLikedCats())
            .thenAnswer((_) async => [testCat]);
        when(() => mockGetBreeds()).thenAnswer((_) async => testBreeds);
        when(() => mockManageLikedCats.removeLikedCat('1'))
            .thenAnswer((_) async {});
        return likedCatsBloc;
      },
      act: (bloc) => bloc
        ..add(LoadLikedCatsEvent())
        ..add(RemoveLikedCatEvent('1')),
      expect: () => [
        LikedCatsState(
            cats: [testCat],
            availableBreeds: [],
            selectedBreed: null,
            error: null),
        LikedCatsState(
            cats: [testCat],
            availableBreeds: testBreeds,
            selectedBreed: null,
            error: null),
        LikedCatsState(
            cats: [],
            availableBreeds: testBreeds,
            selectedBreed: null,
            error: null),
      ],
      verify: (_) {
        verify(() => mockManageLikedCats.removeLikedCat('1')).called(1);
      },
    );
  });
}
