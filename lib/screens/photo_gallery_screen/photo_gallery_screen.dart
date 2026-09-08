import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/screens/photo_gallery_screen/photo_album_screen.dart';

class PhotoGalleryScreen extends StatelessWidget {
  const PhotoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;

    final List<Map<String, String>> photos = [
      {"title": "photo101", "imageUrl": "https://picsum.photos/seed/p1/300/300"},
      {"title": "photo102", "imageUrl": "https://picsum.photos/seed/p2/300/300"},
      {"title": "photo103", "imageUrl": "https://picsum.photos/seed/p3/300/300"},
      {"title": "photo104", "imageUrl": "https://picsum.photos/seed/p4/300/300"},
      {"title": "Kalmakanda", "imageUrl": "https://picsum.photos/seed/p5/300/300"},
      {"title": "Durgapur", "imageUrl": "https://picsum.photos/seed/p6/300/300"},
      {"title": "Netrokona", "imageUrl": "https://picsum.photos/seed/p7/300/300"},
      {"title": "Dhaka", "imageUrl": "https://picsum.photos/seed/p8/300/300"},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Green Banner
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: const Column(
                children: [
                  Text(
                    "Various events, activities and important moments photo collection.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            // Grid content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemCount: photos.length,
                itemBuilder: (context, index) {
                  final photo = photos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PhotoAlbumScreen(albumTitle: photo["title"]!)),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        children: [
                          CachedNetworkImage(
                            imageUrl: photo["imageUrl"]!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: primaryGreen,
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              child: Text(
                                photo["title"]!,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
