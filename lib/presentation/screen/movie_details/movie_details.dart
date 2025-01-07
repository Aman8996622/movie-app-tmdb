import 'package:flutter/material.dart';
import 'package:movieapp/core/utils/utils.dart';
import 'package:movieapp/data/models/movie_model.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({
    super.key,
    required this.movie,
  });
  final Movie movie;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                alignment: Alignment.centerLeft,
                title: const Text('Book Tickets'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Movie: ${widget.movie.title}'),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            // Add booking logic here
                            Navigator.pop(context);
                          },
                          child: Container(
                              // height: 30,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              child: const Text('Book Ticket Now')),
                        ),
                        InkWell(
                          onTap: () {
                            // Add booking logic here
                            Navigator.pop(context);
                          },
                          child: Container(
                              // height: 30,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                    10,
                                  ),
                                ),
                              ),
                              child: const Text('Cancel')),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
          icon: const Icon(Icons.book_online),
          label: const Text(
            'Book Tickets',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blue.shade800,
        ),
        body: CustomScrollView(
          // sliver app bar
          slivers: [
            SliverAppBar(
              expandedHeight: MediaQuery.of(context).size.height / 2.1,

              iconTheme: const IconThemeData(
                  color:
                      Colors.white), // Added this line to make back arrow white
              actions: [
                Container(
                  padding: const EdgeInsets.only(right: 5),
                )
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  '${Utils.imageUrl}${widget.movie.posterPath}',
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey,
                      child: const Center(child: Text('No Image')),
                    );
                  },
                ),
              ),
            ),
            SliverList(
                delegate: SliverChildBuilderDelegate((ctx, _) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.movie.title ?? widget.movie.name!,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Wrap(
                      children: List.generate(
                          widget.movie.genreIds!.length,
                          (genreIndex) => Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, top: 4),
                                child: Chip(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  side: const BorderSide(width: 0),
                                  backgroundColor: Colors.grey.withOpacity(.9),
                                  label: Text(
                                    Utils.getGenres(widget.movie.genreIds!)
                                        .split(',')
                                        .elementAt(genreIndex),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.white70),
                                  ),
                                ),
                              )),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Icon(Icons.date_range),
                          Text(widget.movie.releaseDate == null
                              ? widget.movie.firstAirDate
                                  .toString()
                                  .substring(0, 4)
                              : widget.movie.releaseDate
                                  .toString()
                                  .substring(0, 4)),
                          const SizedBox(
                            width: 10,
                          ),
                          const Icon(Icons.star),
                          Text(widget.movie.voteAverage.toString()),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Story Line',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      widget.movie.overview!,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              );
            }, childCount: 1))
          ],
        ));
  }
}
