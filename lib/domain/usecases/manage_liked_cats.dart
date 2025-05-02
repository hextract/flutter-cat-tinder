import 'package:flutter/foundation.dart';
import '../entities/cat.dart';
import '../repositories/cat_repository.dart';

class ManageLikedCats {
  final CatRepository _repository;
  final ValueNotifier<int> likeCountNotifier = ValueNotifier(0);

  ManageLikedCats(this._repository) {
    _updateLikeCount();
  }

  Future<void> addLikedCat(Cat cat) async {
    await _repository.addLikedCat(cat);
    await _updateLikeCount();
  }

  Future<void> removeLikedCat(String catId) async {
    await _repository.removeLikedCat(catId);
    await _updateLikeCount();
  }

  Future<List<Cat>> getLikedCats() async {
    return await _repository.getLikedCats();
  }

  Future<void> _updateLikeCount() async {
    final likedCats = await getLikedCats();
    likeCountNotifier.value = likedCats.length;
  }
}
