class Cat {
  final String id;
  final String url;
  final String breedName;
  final String breedDescription;
  final String origin;
  final String temperament;
  final String lifeSpan;
  final String weight;
  final DateTime? likedAt;

  Cat({
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

  factory Cat.fromJson(Map<String, dynamic> json) {
    return Cat(
      id: json['id'],
      url: json['url'],
      breedName: json['breedName'],
      breedDescription: json['breedDescription'],
      origin: json['origin'],
      temperament: json['temperament'],
      lifeSpan: json['lifeSpan'],
      weight: json['weight'],
      likedAt: json['likedAt'] != null ? DateTime.parse(json['likedAt']) : null,
    );
  }
}
