import '../entities/cat.dart';
import '../repositories/cat_repository.dart';

class GetBreeds {
  final CatRepository repository;

  GetBreeds(this.repository);

  List<String> call(List<Cat> cats) =>
      cats.map((cat) => cat.breedName).toSet().toList();
}
