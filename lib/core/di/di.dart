import 'package:get_it/get_it.dart';
import '../../data/repositories/cat_repository.dart';
import '../../domain/usecases/fetch_cats.dart';
import '../../domain/usecases/manage_liked_cats.dart';
import '../../domain/usecases/get_breeds.dart';
import '../../presentation/bloc/home/home_bloc.dart';
import '../../presentation/bloc/liked_cats/liked_cats_bloc.dart';
import '../../domain/repositories/cat_repository.dart' as domain;

final getIt = GetIt.instance;

void setupDependencies() {
  // Data layer
  getIt.registerLazySingleton<domain.CatRepository>(() => CatRepositoryImpl());

  // Domain layer
  getIt.registerLazySingleton<FetchCats>(
      () => FetchCats(getIt<domain.CatRepository>()));
  getIt.registerLazySingleton<ManageLikedCats>(
      () => ManageLikedCats(getIt<domain.CatRepository>()));
  getIt.registerLazySingleton<GetBreeds>(
      () => GetBreeds(getIt<domain.CatRepository>()));

  // Presentation layer
  getIt.registerFactory<HomeBloc>(() => HomeBloc(getIt<FetchCats>()));
  getIt.registerFactory<LikedCatsBloc>(() => LikedCatsBloc(
        getIt<ManageLikedCats>(),
        getIt<GetBreeds>(),
      ));
}
