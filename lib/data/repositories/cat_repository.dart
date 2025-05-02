import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/error/exceptions.dart';
import '../../domain/entities/cat.dart';
import '../../domain/repositories/cat_repository.dart';
import '../models/cat_model.dart';

class CatRepositoryImpl implements CatRepository {
  final SharedPreferences _prefs;
  static const String _likedCatsKey = 'liked_cats';
  static const int _limit = 10;
  static const int _maxLikedCats = 100; // Ограничение на количество лайков
  int _page = 0;
  final List<Cat> _likedCats;

  CatRepositoryImpl(this._prefs) : _likedCats = _loadLikedCatsFromPrefsSync(_prefs);

  static List<Cat> _loadLikedCatsFromPrefsSync(SharedPreferences prefs) {
    final jsonString = prefs.getString(_likedCatsKey);
    if (jsonString == null || jsonString.isEmpty) {
      debugPrint('CatRepository: No liked cats found in SharedPreferences');
      return [];
    }

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded is List) {
        final cats = decoded
            .map((json) => Cat.fromJson(json as Map<String, dynamic>))
            .toList();
        debugPrint('CatRepository: Loaded ${cats.length} liked cats from SharedPreferences');
        return cats.take(_maxLikedCats).toList(); // Ограничиваем размер
      } else {
        debugPrint('CatRepository: Invalid liked cats JSON format, clearing cache');
        prefs.remove(_likedCatsKey);
        return [];
      }
    } catch (e) {
      debugPrint('CatRepository: Error parsing liked cats JSON: $e');
      prefs.remove(_likedCatsKey);
      return [];
    }
  }

  Future<void> _saveLikedCatsToPrefs() async {
    debugPrint('CatRepository: Saving ${_likedCats.length} liked cats to SharedPreferences');
    try {
      await _prefs.setString(
        _likedCatsKey,
        jsonEncode(_likedCats.take(_maxLikedCats).map((c) => c.toJson()).toList()),
      );
    } catch (e) {
      debugPrint('CatRepository: Error saving liked cats to SharedPreferences: $e');
    }
  }

  @override
  Future<List<Cat>> fetchCats() async {
    debugPrint('CatRepository: fetchCats called, page: $_page');
    final connectivityResult = await Connectivity().checkConnectivity();
    final isOnline = connectivityResult.any((r) => r != ConnectivityResult.none);
    debugPrint('CatRepository: isOnline: $isOnline');

    if (!isOnline) {
      debugPrint('CatRepository: Offline, returning empty list');
      return [];
    }

    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      debugPrint('CatRepository: API key is missing');
      throw ServerException('API key is missing');
    }

    debugPrint('CatRepository: Sending HTTP request to TheCatAPI');
    final response = await http.get(
      Uri.parse(
          'https://api.thecatapi.com/v1/images/search?limit=$_limit&page=$_page&order=RAND&has_breeds=1'),
      headers: {'x-api-key': apiKey},
    );

    debugPrint('CatRepository: HTTP response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Cat> cats = data
          .map((json) => CatModel.fromJson(json as Map<String, dynamic>).toCat())
          .toList();
      debugPrint('CatRepository: Fetched ${cats.length} cats');
      _page++;
      return cats;
    } else if (response.statusCode == 404) {
      debugPrint('CatRepository: API endpoint not found');
      throw ServerException('API endpoint not found');
    } else if (response.statusCode == 401) {
      debugPrint('CatRepository: Invalid or missing API key');
      throw ServerException('Invalid or missing API key');
    } else {
      debugPrint('CatRepository: Failed to load cats: ${response.statusCode}');
      throw ServerException('Failed to load cats: ${response.statusCode}');
    }
  }

  @override
  Future<void> addLikedCat(Cat cat) async {
    debugPrint('CatRepository: Adding liked cat: ${cat.id}');
    if (!_likedCats.any((c) => c.id == cat.id)) {
      _likedCats.add(cat.copyWith(likedAt: DateTime.now()));
      if (_likedCats.length > _maxLikedCats) {
        _likedCats.removeAt(0); // Удаляем самый старый лайк
      }
      await _saveLikedCatsToPrefs();
      debugPrint('CatRepository: Liked cat added, total liked: ${_likedCats.length}');
    }
  }

  @override
  Future<List<Cat>> getLikedCats() async {
    debugPrint('CatRepository: Returning ${_likedCats.length} liked cats');
    return _likedCats;
  }

  @override
  Future<void> removeLikedCat(String catId) async {
    debugPrint('CatRepository: Removing liked cat: $catId');
    _likedCats.removeWhere((c) => c.id == catId);
    await _saveLikedCatsToPrefs();
    debugPrint('CatRepository: Liked cat removed, total liked: ${_likedCats.length}');
  }
}