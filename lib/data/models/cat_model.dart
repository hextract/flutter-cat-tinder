import '../../domain/entities/cat.dart';

class CatModel extends Cat {
  const CatModel({
    required super.id,
    required super.url,
    required super.breedName,
    required super.breedDescription,
    required super.origin,
    required super.temperament,
    required super.lifeSpan,
    required super.weight,
    super.likedAt,
  });

  factory CatModel.fromJson(Map<String, dynamic> json) {
    final breed = json['breeds'][0];
    return CatModel(
      id: json['id'],
      url: json['url'],
      breedName: breed['name'],
      breedDescription: breed['description'],
      origin: breed['origin'],
      temperament: breed['temperament'],
      lifeSpan: breed['life_span'],
      weight: breed['weight']['metric'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'breeds': [
          {
            'name': breedName,
            'description': breedDescription,
            'origin': origin,
            'temperament': temperament,
            'life_span': lifeSpan,
            'weight': {'metric': weight},
          }
        ],
        'likedAt': likedAt?.toIso8601String(),
      };
}
