import 'package:cat_tinder/domain/entities/cat.dart';
import 'package:equatable/equatable.dart';
import 'breed_model.dart';

class CatModel extends Equatable {
  final String id;
  final String url;
  final List<BreedModel> breeds;

  const CatModel({
    required this.id,
    required this.url,
    required this.breeds,
  });

  factory CatModel.fromJson(Map<String, dynamic> json) {
    return CatModel(
      id: json['id'] as String,
      url: json['url'] as String,
      breeds: (json['breeds'] as List<dynamic>?)
          ?.map((breed) => BreedModel.fromJson(breed as Map<String, dynamic>))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'breeds': breeds.map((breed) => breed.toJson()).toList(),
    };
  }

  Cat toCat() {
    final breed = breeds.isNotEmpty ? breeds.first : null;
    return Cat(
      id: id,
      url: url,
      breedName: breed?.name ?? 'Unknown',
      breedDescription: breed?.description ?? '',
      origin: breed?.origin ?? '',
      temperament: breed?.temperament ?? '',
      lifeSpan: breed?.lifeSpan ?? '',
      weight: breed?.weight ?? '0',
    );
  }

  @override
  List<Object?> get props => [id, url, breeds];
}