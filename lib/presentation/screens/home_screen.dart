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
  List<ConnectivityResult>? _lastConnectivityResult;

  Future<void> _checkConnectivity(BuildContext blocContext) async {
    if (kIsWeb) {
      _lastConnectivityResult = [ConnectivityResult.wifi]; // Для веба считаем онлайн
      blocContext.read<HomeBloc>().add(FetchCatsEvent());
      return;
    }
    final result = await Connectivity().checkConnectivity();
    _lastConnectivityResult = result;
    final isOffline = result.every((r) => r == ConnectivityResult.none);
    if (isOffline && mounted) {
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
              final isOffline = result.every((r) => r == ConnectivityResult.none);
              final wasOffline = _lastConnectivityResult?.every((r) => r == ConnectivityResult.none) ?? false;
              if (isOffline && !wasOffline) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'No internet connection.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      backgroundColor: Theme.of(context).colorScheme.error,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
                _lastConnectivityResult = result;
                if (mounted) {
                  blocContext.read<HomeBloc>().add(FetchCatsEvent());
                }
              } else if (wasOffline && !isOffline && mounted) {
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
                _lastConnectivityResult = result;
                blocContext.read<HomeBloc>().add(FetchCatsEvent());
              } else {
                _lastConnectivityResult = result;
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
                    : 'Unable to load cats.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        final isOffline = _lastConnectivityResult?.every((r) => r == ConnectivityResult.none) ?? false && !kIsWeb;
        if (isOffline || (state.cats.isEmpty && !state.isLoadingMore)) {
          return _buildEmptyState(state, context, isOffline);
        }
        return state.cats.isEmpty ? _buildLoadingState() : _buildCatList(context, state);
      },
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildEmptyState(HomeState state, BuildContext context, bool isOffline) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isOffline
                ? 'No internet connection.\nYou can view liked cats.'
                : 'No cats available. Please connect to the internet to load cats.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          if (isOffline)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LikedCatsScreen()),
                ),
                child: const Text('View Liked Cats'),
              ),
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