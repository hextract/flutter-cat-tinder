import '../repositories/cat_repository.dart';

class GetBreeds {
  final CatRepository repository;

  GetBreeds(this.repository);

  Future<List<String>> call() async {
    final cats = await repository.getLikedCats();
    return cats.map((cat) => cat.breedName).toSet().toList();
  }
}
