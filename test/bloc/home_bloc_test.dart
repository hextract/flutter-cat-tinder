import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../lib/domain/entities/cat.dart';
import '../../lib/domain/usecases/fetch_cats.dart';
import '../../lib/presentation/bloc/home/home_bloc.dart';
import '../../lib/presentation/bloc/home/home_event.dart';
import '../../lib/presentation/bloc/home/home_state.dart';

class MockFetchCats extends Mock implements FetchCats {}

void main() {
  late HomeBloc homeBloc;
  late MockFetchCats mockFetchCats;

  setUp(() {
    mockFetchCats = MockFetchCats();
    homeBloc = HomeBloc(mockFetchCats);
  });

  tearDown(() {
    homeBloc.close();
  });

  final testCats = [
    Cat(
      id: '1',
      url: 'https://example.com/cat1.jpg',
      breedName: 'Persian',
      breedDescription: 'Fluffy cat',
      origin: 'Persia',
      temperament: 'Calm',
      lifeSpan: '12-15 years',
      weight: '4.5',
    ),
  ];

  group('HomeBloc', () {
    blocTest<HomeBloc, HomeState>(
      'emits [loading, cats loaded] when FetchCatsEvent is added and fetch succeeds',
      build: () {
        when(() => mockFetchCats()).thenAnswer((_) async => testCats);
        return homeBloc;
      },
      act: (bloc) => bloc.add(FetchCatsEvent()),
      expect: () => [
        HomeState(cats: [], isLoadingMore: true, error: null),
        HomeState(cats: testCats, isLoadingMore: false, error: null),
      ],
      verify: (_) {
        verify(() => mockFetchCats()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits [loading, error] when FetchCatsEvent is added and fetch fails',
      build: () {
        when(() => mockFetchCats()).thenThrow(Exception('Network error'));
        return homeBloc;
      },
      act: (bloc) => bloc.add(FetchCatsEvent()),
      expect: () => [
        HomeState(cats: [], isLoadingMore: true, error: null),
        HomeState(cats: [], isLoadingMore: false, error: 'Network error'),
      ],
      verify: (_) {
        verify(() => mockFetchCats()).called(1);
      },
    );

    blocTest<HomeBloc, HomeState>(
      'emits [loading more] when CheckLoadMoreEvent triggers fetch',
      build: () {
        when(() => mockFetchCats()).thenAnswer((_) async => testCats);
        return homeBloc..add(FetchCatsEvent());
      },
      act: (bloc) => bloc.add(CheckLoadMoreEvent(9)),
      expect: () => [
        HomeState(cats: [], isLoadingMore: true, error: null),
        HomeState(cats: testCats, isLoadingMore: false, error: null),
        HomeState(cats: testCats, isLoadingMore: true, error: null),
        HomeState(
            cats: [...testCats, ...testCats],
            isLoadingMore: false,
            error: null),
      ],
      verify: (_) {
        verify(() => mockFetchCats()).called(2);
      },
    );
  });
}
