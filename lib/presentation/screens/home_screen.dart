import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import '../../core/di/di.dart';
import '../../core/services/connectivity_service.dart';
import '../bloc/home/home_bloc.dart';
import '../bloc/home/home_event.dart';
import 'home/home_app_bar.dart';
import 'home/home_body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _swiperController = CardSwiperController();
  final _connectivityService = ConnectivityService();

  @override
  void dispose() {
    _connectivityService.dispose();
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>(),
      child: Builder(
        builder: (blocContext) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _connectivityService.initialize(
              context: blocContext,
              onFetchCats: () {
                if (blocContext.mounted) {
                  blocContext.read<HomeBloc>().add(FetchCatsEvent());
                }
              },
            );
          });
          return Scaffold(
            appBar: const HomeAppBar(),
            body: SafeArea(
              child: HomeBody(
                connectivityService: _connectivityService,
                swiperController: _swiperController,
              ),
            ),
          );
        },
      ),
    );
  }
}
