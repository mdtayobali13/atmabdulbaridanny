import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/models/gallery_and_media_models.dart';
import 'package:flutter_riverpod_template/screens/photo_gallery_screen/photo_album_screen.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';
import 'package:flutter_riverpod_template/utils/languages/language_provider.dart';

class PhotoGallery extends ConsumerWidget {
  final List<PhotoGalleryModel>? items;

  const PhotoGallery({super.key, this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBangla = ref.watch(isBanglaProvider);

    if (items != null && items!.isNotEmpty) {
      return _buildGrid(context, items!, isBangla);
    }

    final galleryAsync = ref.watch(photoGalleryProvider);

    return galleryAsync.when(
      data: (list) {
        if (list.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(isBangla ? "কোন ছবি পাওয়া যায়নি" : "No photos available")),
          );
        }
        return _buildGrid(context, list.take(6).toList(), isBangla);
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildGrid(BuildContext context, List<PhotoGalleryModel> photos, bool isBangla) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: photos.length > 6 ? 6 : photos.length,
        itemBuilder: (context, index) {
          final photo = photos[index];
          final imgUrl = photo.fullCoverUrl;

          return GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => PhotoAlbumScreen(
                    albumTitle: photo.localizedTitle(isBangla),
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imgUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image, color: Colors.grey),
                      )
                    : const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }
}
