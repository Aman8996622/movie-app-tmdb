import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/data/models/movie_model.dart';
import 'package:movieapp/core/utils/utils.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/bloc/movie_bloc.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/bloc/movie_event.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/bloc/movie_state.dart';
import 'package:movieapp/presentation/screen/movie_details/movie_details.dart';

class Search extends SearchDelegate<Movie> {
  final MovieBloc movieBloc;
  final List<Movie> movies;

  Search(
    this.movies,
    this.movieBloc,
  );

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blue.shade800,
      ),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          Utils.unFocus(context);

          query = '';
          movieBloc.add(
            SearchMovies(
              '',
            ),
          );
        },
        icon: const Icon(
          Icons.clear,
        ),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, Movie());
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocProvider.value(
      value: movieBloc,
      child: _BuildSearchResults(query: query),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocProvider.value(
      value: movieBloc,
      child: _BuildSearchResults(query: query),
    );
  }
}

class _BuildSearchResults extends StatelessWidget {
  final String query;

  const _BuildSearchResults({required this.query});

  @override
  Widget build(BuildContext context) {
    context.read<MovieBloc>().add(SearchMovies(query));

    return BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
      if (state is MovieLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (query.isEmpty) {
        return const SizedBox();
      }

      if (state is MovieError) {
        return Center(child: Text(state.message));
      }

      List<Movie> filteredMovies =
          (state is MovieFiltered) ? state.filteredMovies : [];

      if (filteredMovies.isEmpty) {
        return const Center(
          child: Text('Not Found'),
        );
      }

      return ListView.builder(
        itemCount: filteredMovies.length,
        itemBuilder: (context, index) {
          final movie = filteredMovies[index];
          return ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    movie: movie,
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor: Colors.grey,
              child: ClipOval(
                child: Image.network(
                  '${Utils.imageUrl}${movie.posterPath}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            title: Text(movie.title ?? "No Title"),
          );
        },
      );
    });
  }
}
