// movie_event.dart
abstract class MovieEvent {}

class FetchMovies extends MovieEvent {
  final String category;
  FetchMovies(this.category);
}

class ToggleViewMode extends MovieEvent {}

class SearchMovies extends MovieEvent {
  final String query;
  SearchMovies(this.query);
}

class FilterByGenre extends MovieEvent {
  final String genre;
  FilterByGenre(this.genre);
}

class LoadMoreMovies extends MovieEvent {
  final String category;
  final String genre;

  LoadMoreMovies({
    required this.category,
    required this.genre,

  });
}
