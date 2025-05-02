import 'package:cat_tinder/domain/entities/cat.dart';
import 'package:cat_tinder/domain/repositories/cat_repository.dart';
import 'package:cat_tinder/domain/usecases/manage_liked_cats.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCatRepository extends Mock implements CatRepository {}

void main() {
  late ManageLikedCats manageLikedCats;
  late MockCatRepository mockRepository;

  setUp(() {
    mockRepository = MockCatRepository();
    when(() => mockRepository.getLikedCats()).thenAnswer((_) async => []);
    manageLikedCats = ManageLikedCats(mockRepository);
  });

  group('ManageLikedCats', () {
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

    test('adds liked cat and updates like count', () async {
      when(() => mockRepository.addLikedCat(cat)).thenAnswer((_) async {});
      when(() => mockRepository.getLikedCats()).thenAnswer((_) async => [cat]);

      await manageLikedCats.addLikedCat(cat);

      expect(manageLikedCats.likeCountNotifier.value, 1);
      verify(() => mockRepository.addLikedCat(cat)).called(1);
      verify(() => mockRepository.getLikedCats()).called(2);
    });

    test('removes liked cat and updates like count', () async {
      when(() => mockRepository.removeLikedCat('1')).thenAnswer((_) async {});
      when(() => mockRepository.getLikedCats()).thenAnswer((_) async => []);

      await manageLikedCats.removeLikedCat('1');

      expect(manageLikedCats.likeCountNotifier.value, 0);
      verify(() => mockRepository.removeLikedCat('1')).called(1);
      verify(() => mockRepository.getLikedCats()).called(2);
    });

    test('returns liked cats', () async {
      when(() => mockRepository.getLikedCats()).thenAnswer((_) async => [cat]);

      final result = await manageLikedCats.getLikedCats();

      expect(result, [cat]);
      verify(() => mockRepository.getLikedCats()).called(2);
    });

    testWidgets('updates like count on initialization', (WidgetTester tester) async {
      reset(mockRepository);
      when(() => mockRepository.getLikedCats()).thenAnswer((_) async => [cat]);

      final newInstance = ManageLikedCats(mockRepository);

      await tester.pump();

      expect(newInstance.likeCountNotifier.value, 1);
      verify(() => mockRepository.getLikedCats()).called(1);
    });
  });
}