abstract class HomeEvent {}

class FetchCatsEvent extends HomeEvent {}

class CheckLoadMoreEvent extends HomeEvent {
  final int currentIndex;

  CheckLoadMoreEvent(this.currentIndex);
}