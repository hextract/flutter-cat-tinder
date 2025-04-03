import '../entities/cat.dart';
import '../repositories/cat_repository.dart';

class FetchCats {
  final CatRepository repository;

  FetchCats(this.repository);

  Future<List<Cat>> call() => repository.fetchCats();
}
