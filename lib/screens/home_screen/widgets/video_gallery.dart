import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barristerkayserkamal/models/gallery_and_media_models.dart';
import 'package:barristerkayserkamal/screens/video_gallery_screen/video_detail_screen.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';

class VideoGallery extends ConsumerWidget {
  final List<VideoGalleryModel>? items;

  const VideoGallery({super.key, this.items});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBangla = ref.watch(isBanglaProvider);

    if (items != null && items!.isNotEmpty) {
      return _buildGrid(context, items!, isBangla);
    }

    final videosAsync = ref.watch(videoGalleryProvider);

    return videosAsync.when(
      data: (list) {
        if (list.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(child: Text(isBangla ? "কোন ভিডিও পাওয়া যায়নি" : "No videos available")),
          );
        }
        return _buildGrid(context, list.take(4).toList(), isBangla);
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(24.0),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildGrid(BuildContext context, List<VideoGalleryModel> videos, bool isBangla) {
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
        itemCount: videos.length > 4 ? 4 : videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final imgUrl = video.fullImageUrl;
          final videoId = video.youtubeVideoId ?? '';

          return GestureDetector(
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(
                  builder: (context) => VideoDetailScreen(
                    title: video.localizedTitle(isBangla),
                    date: video.createdAt ?? '',
                    videoId: videoId.isNotEmpty ? videoId : 'dQw4w9WgXcQ',
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (imgUrl.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.videocam, color: Colors.white54, size: 40)),
                      )
                    else
                      const Center(child: Icon(Icons.videocam, color: Colors.white54, size: 40)),
                    const Center(
                      child: Icon(Icons.play_circle_fill, color: Colors.white70, size: 40),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        color: Colors.black54,
                        child: Text(
                          video.localizedTitle(isBangla),
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
