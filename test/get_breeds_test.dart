import 'package:cat_tinder/domain/entities/cat.dart';
import 'package:cat_tinder/domain/repositories/cat_repository.dart';
import 'package:cat_tinder/domain/usecases/get_breeds.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCatRepository extends Mock implements CatRepository {}

void main() {
  late GetBreeds getBreeds;
  late MockCatRepository mockRepository;

  setUp(() {
    mockRepository = MockCatRepository();
    getBreeds = GetBreeds(mockRepository);
  });

  group('GetBreeds', () {
    final cat1 = Cat(
      id: '1',
      url: 'http://example.com/cat1.jpg',
      breedName: 'Persian',
      breedDescription: 'Fluffy cat',
      origin: 'Iran',
      temperament: 'Calm',
      lifeSpan: '12-15 years',
      weight: '4 kg',
    );
    final cat2 = Cat(
      id: '2',
      url: 'http://example.com/cat2.jpg',
      breedName: 'Siamese',
      breedDescription: 'Vocal cat',
      origin: 'Thailand',
      temperament: 'Active',
      lifeSpan: '10-12 years',
      weight: '3 kg',
    );

    test('returns unique breeds from liked cats', () async {
      when(() => mockRepository.getLikedCats())
          .thenAnswer((_) async => [cat1, cat2]);

      final result = await getBreeds();

      expect(result, ['Persian', 'Siamese']);
      verify(() => mockRepository.getLikedCats()).called(1);
    });

    test('returns empty list when no liked cats', () async {
      when(() => mockRepository.getLikedCats()).thenAnswer((_) async => []);

      final result = await getBreeds();

      expect(result, []);
      verify(() => mockRepository.getLikedCats()).called(1);
    });
  });
}
