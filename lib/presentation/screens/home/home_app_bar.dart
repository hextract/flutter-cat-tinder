import 'package:flutter/material.dart';
import '../../../core/di/di.dart';
import '../../../domain/usecases/manage_liked_cats.dart';
import '../liked_cats_screen.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final manageLikedCats = getIt<ManageLikedCats>();
    return AppBar(
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
                icon: const Icon(Icons.favorite),
                label: Text('$likeCount'),
                style: Theme.of(context).elevatedButtonTheme.style,
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}