import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/screens/photo_gallery_screen/photo_album_screen.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';

class PhotoGalleryScreen extends ConsumerWidget {
  const PhotoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final photoAsync = ref.watch(photoGalleryProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Green Banner
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 28.0),
              child: const Column(
                children: [
                  Text(
                    "Photo Gallery",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Various events, activities, and memorable public moments captured in photos.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Grid content
            photoAsync.when(
              data: (photos) {
                if (photos.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text("No photos available at this moment")),
                  );
                }

                return Padding(
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
                      final title = photo.localizedTitle(false);
                      final imgUrl = photo.fullCoverUrl;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PhotoAlbumScreen(
                                albumTitle: title,
                                imageUrls: photo.allImageUrls,
                              ),
                            ),
                          );
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Stack(
                            children: [
                              imgUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: imgUrl,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                      errorWidget: (context, url, error) =>
                                          const Center(child: Icon(Icons.broken_image, size: 40)),
                                    )
                                  : Container(color: Colors.grey[300]),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  color: primaryGreen.withValues(alpha: 0.9),
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                  child: Text(
                                    title,
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
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text("Failed to load photo gallery: $err")),
              ),
            ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
