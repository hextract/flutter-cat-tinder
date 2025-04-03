import '../entities/cat.dart';

abstract class CatRepository {
  Future<List<Cat>> fetchCats();
  void addLikedCat(Cat cat);
  void removeLikedCat(String id);
  List<Cat> getLikedCats();
}