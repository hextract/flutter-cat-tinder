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
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LikedCatsScreen()),
                    ),
                    icon: const Icon(Icons.favorite, size: 20),
                    label: Text(
                      '${state.likeCounter}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF64B5F6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      elevation: 4,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: BlocConsumer<HomeBloc, HomeState>(
            listener: (context, state) {
              if (state.error != null) {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text('Oops!', style: TextStyle(color: Color(0xFF1976D2))),
                    content: Text(state.error!, style: Theme.of(context).textTheme.bodyLarge),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK', style: TextStyle(color: Color(0xFF64B5F6))),
                      ),
                    ],
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state.cats.isEmpty) {
                return Center(
                  child: state.isLoadingMore
                      ? const CircularProgressIndicator(color: Color(0xFF64B5F6))
                      : const Text(
                    'No cats available yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF0D47A1),
                      fontFamily: 'Poppins',
                    ),
                  ),
                );
              }
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
                            context.read<HomeBloc>().add(LikeCatEvent(prev));
                            manageLikedCats.addLikedCat(state.cats[prev]);
                          }
                          context.read<HomeBloc>().add(CheckLoadMoreEvent(curr ?? 0));
                          return true;
                        },
                        numberOfCardsDisplayed: 3,
                        backCardOffset: const Offset(40, 40),
                        scale: 0.9,
                        cardBuilder: (_, index, __, ___) => CatCard(cat: state.cats[index]),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DislikeButton(
                          onPressed: () => _swiperController.swipe(CardSwiperDirection.left),
                        ),
                        LikeButton(
                          onPressed: () => _swiperController.swipe(CardSwiperDirection.right),
                        ),
                      ],
                    ),
                  ),
                  if (state.isLoadingMore)
                    const LinearProgressIndicator(
                      color: Color(0xFF64B5F6),
                      backgroundColor: Color(0xFF1976D2),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}