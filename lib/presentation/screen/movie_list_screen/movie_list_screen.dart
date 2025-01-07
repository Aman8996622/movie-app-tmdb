// movie_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/bloc/movie_bloc.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/bloc/movie_event.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/bloc/movie_state.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/widget/movie_card.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/widget/movie_list_shimmer.dart';
import 'package:movieapp/presentation/screen/movie_list_screen/widget/search.dart';
import 'package:movieapp/presentation/screen/scan_qr/scan_qr_screen.dart';
import 'package:movieapp/presentation/widget/custom_toggle_switch.dart';

class MovieListScreen extends StatefulWidget {
  const MovieListScreen({super.key});

  @override
  State<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends State<MovieListScreen> {
  final ScrollController _scrollController = ScrollController();
  String _currentCategory = "popular";
  String _selectedGenre = "All";
  int _selectedIndex = 0;

  final List<String> _genres = [
    "All",
    "Action",
    "Adventure",
    "Animation",
    "Comedy",
    "Crime",
    "Drama",
    "Family",
    "Fantasy",
    "Horror",
    "Mystery",
    "Romance",
    "Sci-Fi",
    "Thriller"
  ];

  @override
  void initState() {
    _selectedGenre = "All";
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieBloc>().add(FetchMovies(_currentCategory));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movieBloc = context.read<MovieBloc>();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade800,
          title: const Text(
            "Movies",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: Search(
                    [],
                    movieBloc,
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ScanScreen()));
              },
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(160),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: BlocBuilder<MovieBloc, MovieState>(
                    builder: (context, state) {
                      return CustomToggleButton(
                          activeColor: Colors.grey.shade500,
                          leftLabel: "Grid View",
                          rightLabel: "List View",
                          onToggleValue: (value) {
                            movieBloc.add(ToggleViewMode());
                          });
                    },
                  ),
                ),

                // Tab Bar
                TabBar(
                  indicatorColor: Colors.grey.shade500,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  indicatorWeight: 3,
                  labelPadding: EdgeInsets.zero,
                  labelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                  tabs: [
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Text(
                          "Popular",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Text(
                          "Top Rated",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Text(
                          "Upcoming",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    Tab(
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        child: const Text(
                          "Now Playing",
                          style: TextStyle(
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                  onTap: (index) {
                    final categories = [
                      "popular",
                      "top_rated",
                      "upcoming",
                      "now_playing"
                    ];
                    _currentCategory = categories[index];
                    movieBloc.currentPage = 1;
                    movieBloc.add(FetchMovies(_currentCategory));
                  },
                ),

                BlocBuilder<MovieBloc, MovieState>(builder: (context, state) {
                  return Container(
                    height: 70,
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _genres.length,
                      itemBuilder: (context, index) {
                        debugPrint("selected genre $_selectedGenre");

                        final isSelected = _genres[index] == _selectedGenre;

                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: ChoiceChip(
                            label: Text(_genres[index]),
                            selected: isSelected,
                            onSelected: (selected) {
                              _selectedGenre = _genres[index];
                              context
                                  .read<MovieBloc>()
                                  .add(FilterByGenre(_genres[index]));
                            },
                            selectedColor: Colors.blue.shade800,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieLoading) {
              Future.delayed(const Duration(seconds: 4), () {});
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded || state is MovieFiltered) {
              final movies = state is MovieLoaded
                  ? state.movies
                  : (state as MovieFiltered).filteredMovies;
              final isGridView = state is MovieLoaded
                  ? state.isGridView
                  : (state as MovieFiltered).isGridView;

              return Stack(
                children: [
                  isGridView
                      ? GridView.builder(
                          padding: const EdgeInsets.all(8),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.9,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            mainAxisExtent:
                                MediaQuery.of(context).size.height * 0.45,
                          ),
                          itemCount: movies.length + 1,
                          itemBuilder: (context, index) {
                            if (index == movies.length) {
                              debugPrint("given index of grid view $index");

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Future.delayed(const Duration(seconds: 4), () {
                                  if (context.mounted) {
                                    Navigator.pop(context);
                                    context.read<MovieBloc>().add(
                                          LoadMoreMovies(
                                            category:
                                                _currentCategory.toLowerCase(),
                                            genre: _selectedGenre,
                                          ),
                                        );
                                  }
                                });

                                showDialog(
                                  context: context,
                                  barrierColor: Colors.transparent,
                                  builder: (context) => Container(
                                    padding: const EdgeInsets.only(
                                      bottom: 60,
                                    ),
                                    alignment: Alignment.bottomCenter,
                                    child: const CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                  ),
                                );
                              });

                              return Container(
                                height: 30,
                              );
                            }

                            return MovieCard(
                              isListView: false,
                              movie: movies[index],
                              index: index,
                            );
                          },
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: movies.length + 1,
                          itemBuilder: (context, index) {
                            debugPrint("given index of list view $index");

                            if (index == movies.length) {
                              return loadMoreButton();
                            }
                            return MovieCard(
                              movie: movies[index],
                              index: index,
                              isListView: true,
                            );
                          },
                        ),
                ],
              );
            } else if (state is MovieError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  String getGenreName(int id) {
    // Map genre IDs to names - add more as needed
    final Map<int, String> genreMap = {
      28: "Action",
      12: "Adventure",
      16: "Animation",
      35: "Comedy",
      80: "Crime",
      18: "Drama",
      10751: "Family",
      14: "Fantasy",
      27: "Horror",
      9648: "Mystery",
      10749: "Romance",
      878: "Sci-Fi",
      53: "Thriller"
    };
    return genreMap[id] ?? "Unknown";
  }

  Widget loadMoreButton() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: InkWell(
              onTap: () {
                context.read<MovieBloc>().add(LoadMoreMovies(
                      category: _currentCategory,
                      genre: _selectedGenre,
                    ));
              },
              child: Container(
                width: 200,
                height: 40,
                margin: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Load More',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.expand_more_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
