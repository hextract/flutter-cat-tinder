import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/error/exceptions.dart';
import '../../domain/entities/cat.dart';
import '../../domain/repositories/cat_repository.dart';
import '../models/cat_model.dart';

class CatRepositoryImpl implements CatRepository {
  final List<Cat> _likedCats = [];

  @override
  Future<List<Cat>> fetchCats() async {
    final response = await http.get(
      Uri.parse(
          'https://api.thecatapi.com/v1/images/search?has_breeds=1&limit=10'),
      headers: {'x-api-key': dotenv.env['API_KEY']!},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
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
  }

  @override
  void removeLikedCat(String id) {
    _likedCats.removeWhere((cat) => cat.id == id);
  }

  @override
  List<Cat> getLikedCats() {
    return List.unmodifiable(_likedCats);
  }
}