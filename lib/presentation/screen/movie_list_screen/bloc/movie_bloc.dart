// movie_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movieapp/data/models/movie_model.dart';
import 'package:movieapp/data/repositories/movie_repository.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/bloc/movie_event.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/bloc/movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final MovieRepository movieRepository;

  /// on basis of this flag we show grid view and list view
  ///
  bool isGridView = true;

  /// store of the all movies
  List<Movie> allMovies = [];

  /// store of the displayed movies
  List<Movie> displayedMovies = [];

  /// current page
  int currentPage = 1;

  /// items per page
  final int itemsPerPage = 20;

  MovieBloc(this.movieRepository) : super(MovieLoading()) {
    on<FetchMovies>(_onFetchMovies);
    on<ToggleViewMode>(_onToggleViewMode);
    on<SearchMovies>(_onSearchMovies);
    on<FilterByGenre>(_onFilterByGenre);
    on<LoadMoreMovies>(_onLoadMoreMovies);
  }

  /* ************************************** */
  // ON FETCH MOVIES
  // fetch movies from the api and store in the hive database
  /* ************************************** */

  Future<void> _onFetchMovies(
      FetchMovies event, Emitter<MovieState> emit) async {
    emit(MovieLoading());
    try {
      allMovies = [];
      displayedMovies = [];
      currentPage = 1;
      var box = await Hive.openBox<Movie>(event.category);

      var movieList = box.values.toList();
      if (movieList.isEmpty) {
        allMovies = await movieRepository.fetchMovies(
          category: event.category,
          currentPage: currentPage,
        );
        box.putAll(allMovies.asMap());
        displayedMovies = allMovies.take(itemsPerPage).toList();
        emit(MovieLoaded(displayedMovies, isGridView));
      } else {
        allMovies = movieList;
        displayedMovies = allMovies.take(itemsPerPage).toList();
        emit(MovieLoaded(displayedMovies, isGridView));
      }
    } catch (e) {
      emit(MovieError("Failed to load movies"));
    }
  }

  /* ************************************** */
  // ON TOGGLE VIEW MODE
  // toggle the view mode between grid and list
  /* ************************************** */
  void _onToggleViewMode(ToggleViewMode event, Emitter<MovieState> emit) {
    isGridView = !isGridView;

    emit(MovieLoaded(displayedMovies, isGridView));
  }

  /* ************************************** */
  // ON SEARCH MOVIES
  // search movies from the api and store in the hive database
  /* ************************************** */
  Future<void> _onSearchMovies(
      SearchMovies event, Emitter<MovieState> emit) async {
    var list = await movieRepository.movieSearch(
      event.query,
    );
    displayedMovies = list.take(itemsPerPage).toList();
    emit(MovieFiltered(displayedMovies, isGridView));
  }

  /* ************************************** */
  // ON FILTER BY GENRE
  // filter movies by genre
  /* ************************************** */
  void _onFilterByGenre(FilterByGenre event, Emitter<MovieState> emit) {
    currentPage = 1;

    if (event.genre == "All") {
      displayedMovies = allMovies.take(itemsPerPage).toList();
    } else {
      // Map genre names to their corresponding IDs
      final Map<String, int> tempGenreIds = {
        "Action": 28,
        "Adventure": 12,
        "Animation": 16,
        "Comedy": 35,
        "Crime": 80,
        "Documentary": 99,
        "Drama": 18,
        "Family": 10751,
        "Fantasy": 14,
        "Horror": 27,
        "Mystery": 9648,
        "Romance": 10749,
        "Sci-Fi": 878,
        "Thriller": 53
      };

      final filteredMovies = allMovies
          .where((movie) =>
              movie.genreIds?.contains(tempGenreIds[event.genre]) ?? false)
          .toList();
      displayedMovies = filteredMovies.take(itemsPerPage).toList();
    }
    emit(MovieFiltered(displayedMovies, isGridView));
  }

  /* ************************************** */
  // ON LOAD MORE MOVIES
  // load more movies from the api and store in the hive database
  /* ************************************** */
  Future<void> _onLoadMoreMovies(
      LoadMoreMovies event, Emitter<MovieState> emit) async {
    try {
      final Map<String, int> tempGenreIds = {
        "Action": 28,
        "Adventure": 12,
        "Animation": 16,
        "Comedy": 35,
        "Crime": 80,
        "Documentary": 99,
        "Drama": 18,
        "Family": 10751,
        "Fantasy": 14,
        "Horror": 27,
        "Mystery": 9648,
        "Romance": 10749,
        "Sci-Fi": 878,
        "Thriller": 53
      };

      currentPage = currentPage + 1;

      var box = await Hive.openBox<Movie>(event.category);
      var newMovies = await movieRepository.fetchMovies(
        category: event.category,
        currentPage: currentPage,
      );

      // Add new movies to existing list
      allMovies.addAll(newMovies);

      // Update the box with new movies
      box.clear(); // Clear existing data
      box.putAll(allMovies.asMap());

      List<Movie> moviesToDisplay;
      if (event.genre == "All") {
        moviesToDisplay = allMovies;
      } else {
        moviesToDisplay = allMovies
            .where((movie) =>
                movie.genreIds?.contains(tempGenreIds[event.genre]) ?? false)
            .toList();
      }

      // Show next page of items
      int startIndex = (currentPage - 1) * itemsPerPage;
      int endIndex = startIndex + itemsPerPage;
      if (endIndex > moviesToDisplay.length) {
        endIndex = moviesToDisplay.length;
      }

      displayedMovies = moviesToDisplay.sublist(0, endIndex);

      emit(MovieFiltered(
        displayedMovies,
        isGridView,
      ));
    } catch (e) {
      emit(MovieError("Failed to load more movies"));
    }
  }
}
