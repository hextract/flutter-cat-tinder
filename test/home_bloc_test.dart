import 'package:bloc_test/bloc_test.dart';
import 'package:cat_tinder/presentation/bloc/home/home_bloc.dart';
import 'package:cat_tinder/presentation/bloc/home/home_event.dart';
import 'package:cat_tinder/presentation/bloc/home/home_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:cat_tinder/core/error/exceptions.dart';
import 'package:cat_tinder/domain/entities/cat.dart';
import 'package:cat_tinder/domain/usecases/fetch_cats.dart';

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

  group('HomeBloc', () {
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

    group('FetchCatsEvent', () {
      blocTest<HomeBloc, HomeState>(
        'emits loading and cats on successful fetch',
        build: () {
          when(() => mockFetchCats()).thenAnswer((_) async => [cat]);
          return homeBloc;
        },
        act: (bloc) => bloc.add(FetchCatsEvent()),
        expect: () => [
          HomeState(cats: [], isLoadingMore: true, error: null),
          HomeState(cats: [cat], isLoadingMore: false, error: null),
        ],
        verify: (_) => verify(() => mockFetchCats()).called(1),
      );

      blocTest<HomeBloc, HomeState>(
        'emits loading and error on fetch failure',
        build: () {
          when(() => mockFetchCats())
              .thenThrow(ServerException('API key is missing'));
          return homeBloc;
        },
        act: (bloc) => bloc.add(FetchCatsEvent()),
        expect: () => [
          HomeState(cats: [], isLoadingMore: true, error: null),
          HomeState(
              cats: [], isLoadingMore: false, error: 'API key is missing'),
        ],
        verify: (_) => verify(() => mockFetchCats()).called(1),
      );

      blocTest<HomeBloc, HomeState>(
        'emits empty list on offline fetch',
        build: () {
          when(() => mockFetchCats()).thenAnswer((_) async => []);
          return homeBloc;
        },
        act: (bloc) => bloc.add(FetchCatsEvent()),
        expect: () => [
          HomeState(cats: [], isLoadingMore: true, error: null),
          HomeState(cats: [], isLoadingMore: false, error: null),
        ],
        verify: (_) => verify(() => mockFetchCats()).called(1),
      );
    });

    group('CheckLoadMoreEvent', () {
      blocTest<HomeBloc, HomeState>(
        'loads more cats when threshold is reached',
        build: () {
          when(() => mockFetchCats()).thenAnswer((_) async => [cat]);
          homeBloc.emit(HomeState(
              cats: List.filled(8, cat), isLoadingMore: false, error: null));
          return homeBloc;
        },
        act: (bloc) => bloc.add(CheckLoadMoreEvent(7)),
        expect: () => [
          HomeState(
              cats: List.filled(8, cat), isLoadingMore: true, error: null),
          HomeState(
              cats: List.filled(9, cat), isLoadingMore: false, error: null),
        ],
        verify: (_) => verify(() => mockFetchCats()).called(1),
      );

      blocTest<HomeBloc, HomeState>(
        'does not load more cats when threshold is not reached',
        build: () {
          homeBloc.emit(HomeState(
              cats: List.filled(8, cat), isLoadingMore: false, error: null));
          return homeBloc;
        },
        act: (bloc) => bloc.add(CheckLoadMoreEvent(5)),
        expect: () => [],
        verify: (_) => verifyNever(() => mockFetchCats()),
      );

      blocTest<HomeBloc, HomeState>(
        'emits error when loading more fails',
        build: () {
          when(() => mockFetchCats())
              .thenThrow(ServerException('Failed to load more cats'));
          homeBloc.emit(HomeState(
              cats: List.filled(8, cat), isLoadingMore: false, error: null));
          return homeBloc;
        },
        act: (bloc) => bloc.add(CheckLoadMoreEvent(7)),
        expect: () => [
          HomeState(
              cats: List.filled(8, cat), isLoadingMore: true, error: null),
          HomeState(
              cats: List.filled(8, cat),
              isLoadingMore: false,
              error: 'Failed to load more cats'),
        ],
        verify: (_) => verify(() => mockFetchCats()).called(1),
      );
    });
  });
}
