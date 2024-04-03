import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class DislikeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DislikeButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: AppTheme.dislikeButtonStyle(context),
      child: Icon(Icons.close, size: Theme.of(context).iconTheme.size),
    );
  }
}