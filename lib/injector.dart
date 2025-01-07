import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movieapp/core/network/dio_client.dart';
import 'package:movieapp/core/network/dio_instance.dart';
import 'package:movieapp/data/repositories/movie_repository.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  // injector.registerLazySingleton(() => ApiClient());
  // injector.registerLazySingleton(() => AuthRepository());
  // injector.registerLazySingleton(() => UserRepository());
  // injector.registerLazySingleton(() => UserViewModel());
  injector.registerSingleton<Dio>(Dio());
  injector.registerSingleton<DioInstance>(DioInstance(Dio()));
  injector.registerSingleton<DioClient>(DioClient(DioInstance(Dio())));

  injector.registerSingleton<MovieRepository>(
    MovieRepository(
      injector(),
    ),
  );
}
