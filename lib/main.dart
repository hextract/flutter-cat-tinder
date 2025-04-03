import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/di.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/liked_cats/liked_cats_bloc.dart';
import 'presentation/screens/home_screen.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  setupDependencies();
  runApp(const CatTinderApp());
}

class CatTinderApp extends StatelessWidget {
  const CatTinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LikedCatsBloc>(),
      child: MaterialApp(
        title: 'Cat Tinder',
        theme: AppTheme.lightTheme,
        home: HomeScreen(),
      ),
    );
  }
}
