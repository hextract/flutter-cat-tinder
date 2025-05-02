import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class LikeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LikeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: AppTheme.likeButtonStyle(context),
      child: Icon(Icons.pets, size: Theme.of(context).iconTheme.size),
    );
  }
}
