import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/core/network/dio_client.dart';
import 'package:movieapp/data/models/movie_model.dart';
import 'package:movieapp/data/repositories/movie_repository.dart';
import 'package:movieapp/injector.dart';
import 'package:movieapp/presentation/screen/login_screen%20/bloc/login_bloc.dart';
import 'package:movieapp/presentation/screen/login_screen%20/login_screen.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/bloc/movie_bloc.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/movie_list_screen.dart';

void main() async {
  await Hive.initFlutter();

  Hive.registerAdapter<Movie>(MovieAdapter());

  await Hive.openBox<Movie>('movieBox');

  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MovieBloc(MovieRepository(
            GetIt.I<DioClient>(),
          )),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
      ],
      child: MaterialApp(
        builder: EasyLoading.init(),
        debugShowCheckedModeBanner: false,
        home: MovieListScreen(),
      ),
    );
    // return MaterialApp(
    //   builder: EasyLoading.init(),
    //   debugShowCheckedModeBanner: false,
    //   home: MultiBlocProvider(
      
    //     providers: [
    //       BlocProvider(
    //         create: (context) => MovieBloc(MovieRepository(
    //           GetIt.I<DioClient>(),
    //         )),
    //       ),
    //       BlocProvider(
    //         create: (context) => LoginBloc(),
    //       ),
    //     ],
    //     child: LoginScreen(),
    //   ),
    // );
  }
}
