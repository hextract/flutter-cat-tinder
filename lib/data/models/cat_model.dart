import '../../domain/entities/cat.dart';

class CatModel {
  final String id;
  final String url;
  final List<BreedModel> breeds;

  CatModel({
    required this.id,
    required this.url,
    required this.breeds,
  });

  factory CatModel.fromJson(Map<String, dynamic> json) {
    return CatModel(
      id: json['id'] ?? '',
      url: json['url'] ?? '',
      breeds: (json['breeds'] as List<dynamic>?)
              ?.map((b) => BreedModel.fromJson(b))
              .toList() ??
          [],
    );
  }

  Cat toCat() {
    return Cat(
      id: id,
      url: url,
      breedName: breeds.isNotEmpty ? breeds[0].name : 'Unknown',
      breedDescription: breeds.isNotEmpty ? breeds[0].description : '',
      origin: breeds.isNotEmpty ? breeds[0].origin : '',
      temperament: breeds.isNotEmpty ? breeds[0].temperament : '',
      lifeSpan: breeds.isNotEmpty ? breeds[0].lifeSpan : '',
      weight: breeds.isNotEmpty ? breeds[0].weight : '0',
    );
  }
}

class BreedModel {
  final String name;
  final String description;
  final String origin;
  final String temperament;
  final String lifeSpan;
  final String weight;

  BreedModel({
    required this.name,
    required this.description,
    required this.origin,
    required this.temperament,
    required this.lifeSpan,
    required this.weight,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      name: json['name'] ?? 'Unknown',
      description: json['description'] ?? '',
      origin: json['origin'] ?? '',
      temperament: json['temperament'] ?? '',
      lifeSpan: json['life_span'] ?? '',
      weight: json['weight']?['metric'] ?? '0',
    );
  }
}
