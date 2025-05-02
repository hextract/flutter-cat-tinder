import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../core/di/di.dart';
import '../../../domain/usecases/manage_liked_cats.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';
import '../../widgets/cat_card.dart';
import '../../widgets/dislike_button.dart';
import '../../widgets/like_button.dart';
import '../detail_screen.dart';

class CatList extends StatelessWidget {
  final HomeState state;
  final CardSwiperController swiperController;

  const CatList({
    super.key,
    required this.state,
    required this.swiperController,
  });

  @override
  Widget build(BuildContext context) {
    final manageLikedCats = getIt<ManageLikedCats>();
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CardSwiper(
              controller: swiperController,
              cardsCount: state.cats.length,
              onSwipe: (prev, curr, dir) async {
                final homeBloc = context.read<HomeBloc>();
                if (dir == CardSwiperDirection.right) {
                  await manageLikedCats.addLikedCat(state.cats[prev]);
                }
                homeBloc.add(CheckLoadMoreEvent(curr ?? 0));
                return true;
              },
              numberOfCardsDisplayed:
                  state.cats.length >= 3 ? 3 : state.cats.length,
              backCardOffset: const Offset(40, 40),
              scale: 0.9,
              cardBuilder: (context, index, _, __) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailScreen(catData: state.cats[index]),
                  ),
                ),
                child: CatCard(cat: state.cats[index]),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DislikeButton(
                onPressed: () =>
                    swiperController.swipe(CardSwiperDirection.left),
              ),
              LikeButton(
                onPressed: () =>
                    swiperController.swipe(CardSwiperDirection.right),
              ),
            ],
          ),
        ),
        if (state.isLoadingMore) const LinearProgressIndicator(),
      ],
    );
  }
}
