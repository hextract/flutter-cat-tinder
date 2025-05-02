import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../../core/services/connectivity_service.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_state.dart';
import 'cat_list.dart';
import 'empty_state.dart';

class HomeBody extends StatelessWidget {
  final ConnectivityService connectivityService;
  final CardSwiperController swiperController;

  const HomeBody({
    super.key,
    required this.connectivityService,
    required this.swiperController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.error != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.error == 'API key is missing' ||
                        state.error == 'Invalid or missing API key'
                    ? 'Please check your API key'
                    : state.error!,
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      builder: (context, state) {
        final isOffline = connectivityService.isOffline();
        if (isOffline || (state.cats.isEmpty && !state.isLoadingMore)) {
          return EmptyState(state: state, isOffline: isOffline);
        }
        return state.isLoadingMore && state.cats.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : CatList(state: state, swiperController: swiperController);
      },
    );
  }
}
