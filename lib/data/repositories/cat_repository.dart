import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../core/error/exceptions.dart';
import '../models/cat_model.dart';
import '../../domain/repositories/cat_repository.dart';

class CatRepositoryImpl implements CatRepository {
  @override
  Future<List<CatModel>> fetchCats() async {
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
}
