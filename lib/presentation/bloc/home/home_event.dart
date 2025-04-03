abstract class HomeEvent {}

class FetchCatsEvent extends HomeEvent {}

class LikeCatEvent extends HomeEvent {
  final int index;
  LikeCatEvent(this.index);
}

class CheckLoadMoreEvent extends HomeEvent {
  final int currentIndex;
  CheckLoadMoreEvent(this.currentIndex);
}
