import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MovieShimmer extends StatelessWidget {
  final bool isGridView;

  const MovieShimmer({
    super.key,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    return isGridView ? _buildGridShimmer() : _buildListShimmer();
  }

  Widget _buildGridShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.9,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        mainAxisExtent: 350,
      ),
      itemCount: 8, // Show 6 shimmer items while loading
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster placeholder
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Title placeholder
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                // Rating placeholder
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 15,
                    width: 80,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildListShimmer() {
    return ListView.builder(
      itemCount: 8, // Show 8 shimmer items while loading
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Poster placeholder
                Container(
                  width: 120,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title placeholder
                      Container(
                        height: 20,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 8),
                      // Rating placeholder
                      Container(
                        height: 15,
                        width: 80,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 16),
                      // Description placeholder
                      Container(
                        height: 80,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
