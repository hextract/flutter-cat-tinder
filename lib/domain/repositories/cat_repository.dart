import '../entities/cat.dart';

abstract class CatRepository {
  Future<List<Cat>> fetchCats();
  Future<void> addLikedCat(Cat cat);
  Future<List<Cat>> getLikedCats();
  Future<void> removeLikedCat(String catId);
}
