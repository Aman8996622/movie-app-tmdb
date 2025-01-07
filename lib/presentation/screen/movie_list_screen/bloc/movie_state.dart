// movie_state.dart
import 'package:equatable/equatable.dart';
import 'package:movieapp/data/models/movie_model.dart';

abstract class MovieState extends Equatable {}

class MovieLoading extends MovieState {
  final bool isFirstFetch;
  MovieLoading({this.isFirstFetch = false});
  
  @override
  List<Object?> get props => [isFirstFetch];
}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final bool isGridView;
  final int currentPage;
  MovieLoaded(this.movies, this.isGridView, { this.currentPage = 1});

  @override
  List<Object?> get props => [movies, isGridView, currentPage];
}

class MovieError extends MovieState {
  final String message;
  MovieError(this.message);
  
  @override
  List<Object?> get props => [message];
}

class MovieFiltered extends MovieState {
  final List<Movie> filteredMovies;
  final bool isGridView;
  MovieFiltered(this.filteredMovies, this.isGridView);
  
  @override
  List<Object?> get props => [filteredMovies, isGridView];
}

class MoviePaginationLoading extends MovieState {
  final List<Movie> oldMovies;
  final bool isGridView;
  MoviePaginationLoading(this.oldMovies, this.isGridView);
  
  @override
  List<Object?> get props => [oldMovies, isGridView];
}





