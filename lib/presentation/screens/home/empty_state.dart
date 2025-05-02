import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';
import '../liked_cats_screen.dart';

class EmptyState extends StatelessWidget {
  final HomeState state;
  final bool isOffline;

  const EmptyState({super.key, required this.state, required this.isOffline});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isOffline
                ? 'No internet connection.\nYou can view liked cats.'
                : state.error ??
                    'No cats available.\nPlease connect to the internet.',
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          if (state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: ElevatedButton(
                onPressed: () => context.read<HomeBloc>().add(FetchCatsEvent()),
                child: const Text('Retry'),
              ),
            ),
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
}
