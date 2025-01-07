import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_test/hive_test.dart';
import 'package:movieapp/data/models/movie_model.dart';
import 'package:movieapp/data/repositories/movie_repository.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/bloc/movie_bloc.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/bloc/movie_event.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/bloc/movie_state.dart';

import 'movie_bloc_test.mocks.dart';

@GenerateMocks([MovieRepository])
void main() {
  late MockMovieRepository mockMovieRepository;
  late MovieBloc movieBloc;

  setUpAll(() async {
    await setUpTestHive();
    Hive.registerAdapter(MovieAdapter());
  });

  setUp(() async {
    mockMovieRepository = MockMovieRepository();
    movieBloc = MovieBloc(mockMovieRepository);
    await Hive.openBox<Movie>('movies');
  });

  tearDown(() async {
    await movieBloc.close();
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  group('MovieBloc', () {
    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoading, MovieLoaded] when FetchMovies is added',
      build: () {
        when(mockMovieRepository.fetchMovies(
          category: 'popular',
          currentPage: 1,
        )).thenAnswer((_) async => [
              Movie(id: 1, title: 'Test Movie'),
              Movie(id: 2, title: 'Test Movie1'),
            ]);
        return movieBloc;
      },
      wait: const Duration(
        milliseconds: 500,
      ),
      act: (bloc) => bloc.add(FetchMovies('popular')),
      expect: () => [
        MovieLoading(),
        MovieLoaded([
          Movie(id: 1, title: 'Test Movie'),
          Movie(id: 2, title: 'Test Movie1'),
        ], true),
      ],
    );

    blocTest<MovieBloc, MovieState>(
      'emits [MovieLoaded] with toggled view mode when ToggleViewMode is added',
      build: () => movieBloc,
      act: (bloc) => bloc.add(ToggleViewMode()),
      expect: () => [
        MovieLoaded(const [], false),
      ],
    );
  });

    blocTest<MovieBloc, MovieState>(
      'emits [MovieFiltered] with filtered movies when FilterByGenre is added',
      build: () {
        movieBloc.allMovies = [
          Movie(id: 1, title: 'Action Movie', genreIds: [28]), // Action genre ID
          Movie(id: 2, title: 'Comedy Movie', genreIds: [35]), // Comedy genre ID
          Movie(id: 3, title: 'Action Movie 2', genreIds: [28]), // Action genre ID
        ];
        return movieBloc;
      },
      act: (bloc) => bloc.add(FilterByGenre('Action')),
      expect: () => [
        MovieFiltered([
          Movie(id: 1, title: 'Action Movie', genreIds: [28]),
          Movie(id: 3, title: 'Action Movie 2', genreIds: [28]),
        ], true),
      ],
    );
}
