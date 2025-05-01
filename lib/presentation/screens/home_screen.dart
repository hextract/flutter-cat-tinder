import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _swiperController = CardSwiperController();
  bool _wasOffline = false;

  Future<void> _checkConnectivity(BuildContext blocContext) async {
    if (kIsWeb) {
      blocContext.read<HomeBloc>().add(FetchCatsEvent());
      return;
    }
    final result = await Connectivity().checkConnectivity();
    _wasOffline = result == ConnectivityResult.none;
    if (_wasOffline && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No internet connection. Showing offline cats.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          duration: const Duration(seconds: 3),
        ),
      );
      blocContext.read<HomeBloc>().add(FetchCatsEvent());
    } else if (mounted) {
      blocContext.read<HomeBloc>().add(FetchCatsEvent());
    }
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manageLikedCats = getIt<ManageLikedCats>();
    return BlocProvider(
      create: (_) => getIt<HomeBloc>(),
      child: Builder(
        builder: (blocContext) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _checkConnectivity(blocContext);
          });
          if (!kIsWeb) {
            Connectivity().onConnectivityChanged.listen((result) {
              if (result == ConnectivityResult.none) {
                if (mounted) {
                  _wasOffline = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'No internet connection. Showing offline cats.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  blocContext.read<HomeBloc>().add(FetchCatsEvent());
                }
              } else if (_wasOffline && mounted) {
                _wasOffline = false;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Internet connection restored.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    duration: const Duration(seconds: 3),
                  ),
                );
                blocContext.read<HomeBloc>().add(FetchCatsEvent());
              }
            });
          }
          return Scaffold(
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
                          MaterialPageRoute(builder: (_) => const LikedCatsScreen()),
                        ),
                        icon: Icon(
                          Icons.favorite,
                          size: Theme.of(context).iconTheme.size,
                        ),
                        label: Text(
                          '$likeCount',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        style: Theme.of(context).elevatedButtonTheme.style,
                      );
                    },
                  ),
                ),
              ],
            ),
            body: SafeArea(child: _buildBody(blocContext)),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error == 'API endpoint not found. Please check the URL or API key.'
                    ? 'Failed to connect to the Cat API. Please check your API key or internet connection.'
                    : state.error == 'Invalid or missing API key. Please verify your API key.'
                    ? 'Please provide a valid API key for accessing breed information.'
                    : 'Unable to load cats. Showing offline cats.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 3),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            state.isLoadingMore
                ? 'Loading cats...'
                : 'No cats available. Please connect to the internet to load cats.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          if (state.isLoadingMore)
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: CircularProgressIndicator(),
            ),
        ],
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
              onSwipe: (prev, curr, dir) async {
                if (dir == CardSwiperDirection.right) {
                  try {
                    await manageLikedCats.addLikedCat(state.cats[prev]);
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            e.toString().replaceFirst('Exception: ', ''),
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          backgroundColor: Theme.of(context).colorScheme.error,
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                }
                context.read<HomeBloc>().add(CheckLoadMoreEvent(curr ?? 0));
                return true;
              },
              numberOfCardsDisplayed: state.cats.length >= 3 ? 3 : state.cats.length,
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
                    _swiperController.swipe(CardSwiperDirection.left),
              ),
              LikeButton(
                onPressed: () =>
                    _swiperController.swipe(CardSwiperDirection.right),
              ),
            ],
          ),
        ),
        if (state.isLoadingMore) const LinearProgressIndicator(),
      ],
    );
  }
}