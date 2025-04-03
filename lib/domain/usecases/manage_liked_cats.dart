import 'package:flutter/foundation.dart';
import '../entities/cat.dart';
import '../repositories/cat_repository.dart';

class ManageLikedCats {
  final CatRepository repository;
  final ValueNotifier<int> likeCountNotifier;

  ManageLikedCats(this.repository)
      : likeCountNotifier =
            ValueNotifier<int>(repository.getLikedCats().length);

  void addLikedCat(Cat cat) {
    repository.addLikedCat(cat);
    likeCountNotifier.value = repository.getLikedCats().length;
  }

  void removeLikedCat(String id) {
    repository.removeLikedCat(id);
    likeCountNotifier.value = repository.getLikedCats().length;
  }

  List<Cat> getLikedCats({String? breedFilter}) {
    final likedCats = repository.getLikedCats();
    return breedFilter == null
        ? likedCats
        : likedCats.where((cat) => cat.breedName == breedFilter).toList();
  }
}
