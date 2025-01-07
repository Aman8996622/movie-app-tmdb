import 'package:flutter/material.dart';
import 'package:movieapp/core/utils/utils.dart';
import 'package:movieapp/data/models/movie_model.dart';
import 'package:movieapp/presentation/screen/movie_details/movie_details.dart';
import 'package:movieapp/presentation/widget/custom_cached_image.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;
  final int index;
  final double height = 200;
  final bool isListView;

  const MovieCard({
    super.key,
    required this.movie,
    required this.index,
    this.isListView = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isListView) {
      return Card(
        elevation: 4.0,
        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: InkWell(
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
          child: Container(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CustomCacheImage(
                    imageUrl: '${Utils.imageUrl}${movie.posterPath}',
                    width: 150,
                    height: 150,
                    
                  ),
                ),
                // ClipRRect(
                //   borderRadius: BorderRadius.circular(8),
                //   child: SizedBox(
                //     width: 150,
                //     height: 150,
                //     child: Image.network(
                //       '${Utils.imageUrl}${movie.posterPath}',
                //       fit: BoxFit.cover,
                //       errorBuilder: (context, error, stackTrace) => Container(
                //         color: Colors.grey[300],
                //         child: const Center(
                //           child: Icon(
                //             Icons.broken_image,
                //             size: 30,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title ?? "No Title",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if ((movie.genreIds ?? []).isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          Utils.getGenres(movie.genreIds ?? []),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
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
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  '${Utils.imageUrl}${movie.posterPath}',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              movie.title ?? "No Title",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if ((movie.genreIds ?? []).isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              Utils.getGenres(movie.genreIds ?? []),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
