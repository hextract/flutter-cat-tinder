import 'package:flutter/foundation.dart';
import '../entities/cat.dart';
import '../repositories/cat_repository.dart';

class ManageLikedCats {
  final CatRepository repository;
  final List<Cat> _likedCats = [];
  final ValueNotifier<int> likeCountNotifier;

  ManageLikedCats(this.repository) : likeCountNotifier = ValueNotifier<int>(0);

  void addLikedCat(Cat cat) {
    _likedCats.add(Cat(
      id: cat.id,
      url: cat.url,
      breedName: cat.breedName,
      breedDescription: cat.breedDescription,
      origin: cat.origin,
      temperament: cat.temperament,
      lifeSpan: cat.lifeSpan,
      weight: cat.weight,
      likedAt: DateTime.now(),
    ));
    likeCountNotifier.value = _likedCats.length; // Обновляем счетчик
  }

  void removeLikedCat(String id) {
    _likedCats.removeWhere((cat) => cat.id == id);
    likeCountNotifier.value = _likedCats.length; // Обновляем счетчик
  }

  List<Cat> getLikedCats({String? breedFilter}) => breedFilter == null
      ? _likedCats
      : _likedCats.where((cat) => cat.breedName == breedFilter).toList();
}