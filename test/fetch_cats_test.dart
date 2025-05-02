import 'package:cat_tinder/core/error/exceptions.dart';
import 'package:cat_tinder/domain/entities/cat.dart';
import 'package:cat_tinder/domain/repositories/cat_repository.dart';
import 'package:cat_tinder/domain/usecases/fetch_cats.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCatRepository extends Mock implements CatRepository {}

void main() {
  late FetchCats fetchCats;
  late MockCatRepository mockRepository;

  setUp(() {
    mockRepository = MockCatRepository();
    fetchCats = FetchCats(mockRepository);
  });

  group('FetchCats', () {
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

    test('returns cats from repository', () async {
      when(() => mockRepository.fetchCats()).thenAnswer((_) async => [cat]);

      final result = await fetchCats();

      expect(result, [cat]);
      verify(() => mockRepository.fetchCats()).called(1);
    });

    test('propagates repository error', () async {
      when(() => mockRepository.fetchCats())
          .thenThrow(ServerException('API error'));

      expect(
            () => fetchCats(),
        throwsA(isA<ServerException>().having((e) => e.message, 'message', 'API error')),
      );
      verify(() => mockRepository.fetchCats()).called(1);
    });
  });
}