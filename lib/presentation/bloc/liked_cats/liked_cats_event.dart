abstract class LikedCatsEvent {}

class LoadLikedCatsEvent extends LikedCatsEvent {}

class FilterLikedCatsEvent extends LikedCatsEvent {
  final String? breed;

  FilterLikedCatsEvent(this.breed);
}

class RemoveLikedCatEvent extends LikedCatsEvent {
  final String id;

  RemoveLikedCatEvent(this.id);
}
