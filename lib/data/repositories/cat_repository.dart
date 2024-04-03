import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/cat.dart';
import '../../domain/repositories/cat_repository.dart';
import '../models/cat_model.dart';

class CatRepositoryImpl implements CatRepository {
  static const _baseUrl = 'https://api.thecatapi.com/v1/images/search';
  static const _limit = 10;
  static const _likedCatsKey = 'liked_cats';

  final List<Cat> _likedCats = [];

  CatRepositoryImpl() {
    _loadLikedCats();
  }

  @override
  Future<List<Cat>> fetchCats() async {
    final response = await http.get(
      Uri.parse('$_baseUrl?has_breeds=1&limit=$_limit'),
      headers: {'x-api-key': dotenv.env['API_KEY']!},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;
      return data.map((json) => CatModel.fromJson(json)).toList();
    }
    throw ServerException('Failed to load cats: ${response.statusCode}');
  }

  @override
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
    _saveLikedCats();
  }

  @override
  void removeLikedCat(String id) {
    _likedCats.removeWhere((cat) => cat.id == id);
    _saveLikedCats();
  }

  @override
  List<Cat> getLikedCats() {
    return List.unmodifiable(_likedCats);
  }

  Future<void> _loadLikedCats() async {
    final prefs = await SharedPreferences.getInstance();
    final likedCatsJson = prefs.getStringList(_likedCatsKey) ?? [];
    _likedCats.clear();
    for (var json in likedCatsJson) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      _likedCats.add(CatModel.fromJson(map));
    }
  }

  Future<void> _saveLikedCats() async {
    final prefs = await SharedPreferences.getInstance();
    final likedCatsJson = _likedCats.map((cat) => jsonEncode({
      'id': cat.id,
      'url': cat.url,
      'breedName': cat.breedName,
      'breedDescription': cat.breedDescription,
      'origin': cat.origin,
      'temperament': cat.temperament,
      'lifeSpan': cat.lifeSpan,
      'weight': cat.weight,
      'likedAt': cat.likedAt?.toIso8601String(),
    })).toList();
    await prefs.setStringList(_likedCatsKey, likedCatsJson);
  }
}