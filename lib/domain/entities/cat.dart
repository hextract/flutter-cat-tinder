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
}
