import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class VideoGallery extends StatelessWidget {
  const VideoGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final images = [
      'https://picsum.photos/seed/v1/400/300',
      'https://picsum.photos/seed/v2/400/300',
      'https://picsum.photos/seed/v3/400/300',
      'https://picsum.photos/seed/v4/400/300',
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.2,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                  const Center(
                    child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 40),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
