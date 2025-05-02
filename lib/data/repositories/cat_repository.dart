import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/cat.dart';
import '../../domain/repositories/cat_repository.dart';
import '../database/cat_database.dart';
import '../models/cat_model.dart';

class CatRepositoryImpl implements CatRepository {
  final CatDatabase _catDatabase;
  final SharedPreferences _prefs;
  static const String _likedCatsKey = 'liked_cats';
  static const int _limit = 10;
  int _page = 0;

  CatRepositoryImpl(this._catDatabase, this._prefs);

  @override
  Future<List<Cat>> fetchCats() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOnline = connectivityResult.any((r) => r != ConnectivityResult.none);

    if (isOnline) {
      try {
        final response = await http.get(
          Uri.parse(
              'https://api.thecatapi.com/v1/images/search?limit=$_limit&page=$_page&order=RAND&has_breeds=1'),
          headers: {
            'x-api-key': dotenv.env['API_KEY'] ?? '',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body) as List<dynamic>;
          final List<Cat> cats = data
              .map((json) => CatModel.fromJson(json as Map<String, dynamic>).toCat())
              .toList();
          _page++;
          // Не сохраняем котиков в CatDatabase
          return cats;
        } else if (response.statusCode == 404) {
          throw Exception('API endpoint not found. Please check the URL or API key.');
        } else if (response.statusCode == 401) {
          throw Exception('Invalid or missing API key. Please verify your API key.');
        } else {
          throw Exception('Failed to load cats: ${response.statusCode}');
        }
      } catch (e) {
        return [];
      }
    } else {
      return [];
    }
  }

  @override
  Future<void> addLikedCat(Cat cat) async {
    final likedCats = await getLikedCats();
    if (!likedCats.any((c) => c.id == cat.id)) {
      final updatedCats = [...likedCats, cat.copyWith(likedAt: DateTime.now())];
      await _prefs.setString(
        _likedCatsKey,
        jsonEncode(updatedCats.map((c) => c.toJson()).toList()),
      );
    }
  }

  @override
  Future<List<Cat>> getLikedCats() async {
    try {
      final jsonString = _prefs.getString(_likedCatsKey);
      if (jsonString == null || jsonString.isEmpty) return [];

      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        return decoded.map((json) => Cat.fromJson(json as Map<String, dynamic>)).toList();
      } else {
        await _prefs.remove(_likedCatsKey);
        return [];
      }
    } catch (e) {
      await _prefs.remove(_likedCatsKey);
      return [];
    }
  }

  @override
  Future<void> removeLikedCat(String catId) async {
    final likedCats = await getLikedCats();
    final updatedCats = likedCats.where((c) => c.id != catId).toList();
    await _prefs.setString(
      _likedCatsKey,
      jsonEncode(updatedCats.map((c) => c.toJson()).toList()),
    );
  }
}