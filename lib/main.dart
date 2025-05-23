import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/di/di.dart';
import 'core/theme/app_theme.dart';
import 'presentation/bloc/liked_cats/liked_cats_bloc.dart';
import 'presentation/screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    debugPrint('main: .env file loaded successfully');
  } catch (e) {
    debugPrint('main: Error loading .env: $e');
  }

  try {
    await setupDependencies();
    debugPrint('main: Dependencies initialized successfully');
  } catch (e) {
    debugPrint('main: Error initializing dependencies: $e');
  }

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
        home: const HomeScreen(),
      ),
    );
  }
}
