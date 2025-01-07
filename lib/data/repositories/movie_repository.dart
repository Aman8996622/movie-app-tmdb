// movie_repository.dart
import 'package:movieapp/core/api_url/api_url.dart';
import 'package:movieapp/core/network/dio_client.dart';

import 'package:movieapp/data/models/movie_model.dart';

class MovieRepository {
  final DioClient dioClient;
  int currentPage = 1;

  MovieRepository(
    this.dioClient,
  );

  Future<List<Movie>> fetchMovies({
    required String category,
    int currentPage = 1,
  }) async {
    try {
      var url = "movie/$category?api_key=${ApiUrl.apiKey}&page=$currentPage";

      final response = await dioClient.get(
        url,
      );

      final movies = Model.fromJson(response.data);
      List<Movie> moviesList = movies.movies;

      // Cache movies offline

      return moviesList;
    } catch (e) {
      throw Exception('Failed to fetch movies: ${e.toString()}');
    }
  }

  Future<List<Movie>> movieSearch(String query) async {
    try {
      var url = '${ApiUrl.movieSearch}?api_key=${ApiUrl.apiKey}&query=$query';

      final response = await dioClient.get(url);

      if (response.statusCode == 200) {
        var model = Model.fromJson(response.data);
        return model.movies;
      } else {
        throw Exception('Movie not found');
      }
    } catch (e) {
      throw Exception('Failed to search movies: ${e.toString()}');
    }
  }
}
