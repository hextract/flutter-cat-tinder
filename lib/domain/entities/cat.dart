import 'package:equatable/equatable.dart';

class Cat extends Equatable {
  final String id;
  final String url;
  final String breedName;
  final String breedDescription;
  final String origin;
  final String temperament;
  final String lifeSpan;
  final String weight;
  final DateTime? likedAt;

  const Cat({
    required this.id,
    required this.url,
    required this.breedName,
    required this.breedDescription,
    required this.origin,
    required this.temperament,
    required this.lifeSpan,
    required this.weight,
    this.likedAt,
  });

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'] as String,
      url: json['url'] as String,
      breedName: json['breedName'] as String,
      breedDescription: json['breedDescription'] as String,
      origin: json['origin'] as String,
      temperament: json['temperament'] as String,
      lifeSpan: json['lifeSpan'] as String,
      weight: json['weight'] as String,
      likedAt: json['likedAt'] != null
          ? DateTime.parse(json['likedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'breedName': breedName,
      'breedDescription': breedDescription,
      'origin': origin,
      'temperament': temperament,
      'lifeSpan': lifeSpan,
      'weight': weight,
      'likedAt': likedAt?.toIso8601String(),
    };
  }

  Cat copyWith({DateTime? likedAt}) {
    return Cat(
      id: id,
      url: url,
      breedName: breedName,
      breedDescription: breedDescription,
      origin: origin,
      temperament: temperament,
      lifeSpan: lifeSpan,
      weight: weight,
      likedAt: likedAt ?? this.likedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        url,
        breedName,
        breedDescription,
        origin,
        temperament,
        lifeSpan,
        weight,
        likedAt,
      ];
}
