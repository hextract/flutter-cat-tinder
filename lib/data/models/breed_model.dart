import 'package:equatable/equatable.dart';

class BreedModel extends Equatable {
  final String name;
  final String description;
  final String origin;
  final String temperament;
  final String lifeSpan;
  final String weight;

  const BreedModel({
    required this.name,
    required this.description,
    required this.origin,
    required this.temperament,
    required this.lifeSpan,
    required this.weight,
  });

  factory BreedModel.fromJson(Map<String, dynamic> json) {
    return BreedModel(
      name: json['name'] as String? ?? 'Unknown',
      description: json['description'] as String? ?? '',
      origin: json['origin'] as String? ?? '',
      temperament: json['temperament'] as String? ?? '',
      lifeSpan: json['life_span'] as String? ?? '',
      weight: json['weight']['metric'] as String? ?? '0',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'origin': origin,
      'temperament': temperament,
      'life_span': lifeSpan,
      'weight': {'metric': weight},
    };
  }

  @override
  List<Object?> get props => [
        name,
        description,
        origin,
        temperament,
        lifeSpan,
        weight,
      ];
}
