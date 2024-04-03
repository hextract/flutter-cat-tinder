import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../core/di/di.dart';
import '../../domain/usecases/manage_liked_cats.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import '../bloc/home/home_state.dart';
import '../widgets/like_button.dart';
import '../widgets/dislike_button.dart';
import '../widgets/cat_card.dart';
import 'liked_cats_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final _swiperController = CardSwiperController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final manageLikedCats = getIt<ManageLikedCats>();
    return BlocProvider(
      create: (_) => getIt<HomeBloc>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cat Tinder'),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: ValueListenableBuilder<int>(
                valueListenable: manageLikedCats.likeCountNotifier,
                builder: (context, likeCount, child) {
                  return ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LikedCatsScreen()),
                    ),
                    icon: Icon(Icons.favorite, size: Theme.of(context).iconTheme.size),
                    label: Text('$likeCount', style: Theme.of(context).textTheme.bodyMedium),
                    style: Theme.of(context).elevatedButtonTheme.style,
                  );
                },
              ),
            ),
          ],
        ),
        body: SafeArea(child: _buildBody(context)),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.error != null) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Oops!'),
              content: Text(state.error!, style: Theme.of(context).textTheme.bodyLarge),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.cats.isEmpty) {
          return _buildEmptyState(state, context);
        }
        return _buildCatList(context, state);
      },
    );
  }

  Widget _buildEmptyState(HomeState state, BuildContext context) {
    return Center(
      child: state.isLoadingMore
          ? const CircularProgressIndicator()
          : Text(
        'No cats available yet',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
      ),
    );
  }

  Widget _buildCatList(BuildContext context, HomeState state) {
    final manageLikedCats = getIt<ManageLikedCats>();
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: CardSwiper(
              controller: _swiperController,
              cardsCount: state.cats.length,
              onSwipe: (prev, curr, dir) {
                if (dir == CardSwiperDirection.right) {
                  manageLikedCats.addLikedCat(state.cats[prev]);
                }
                context.read<HomeBloc>().add(CheckLoadMoreEvent(curr ?? 0));
                return true;
              },
              numberOfCardsDisplayed: 3,
              backCardOffset: const Offset(40, 40),
              scale: 0.9,
              cardBuilder: (context, index, _, __) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => DetailScreen(catData: state.cats[index])),
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
              DislikeButton(onPressed: () => _swiperController.swipe(CardSwiperDirection.left)),
              LikeButton(onPressed: () => _swiperController.swipe(CardSwiperDirection.right)),
            ],
          ),
        ),
        if (state.isLoadingMore) const LinearProgressIndicator(),
      ],
    );
  }
}