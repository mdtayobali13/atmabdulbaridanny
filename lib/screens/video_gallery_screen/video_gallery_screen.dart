import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/home_screen/widgets/custom_footer.dart';
import 'package:atmabdulbaridanny/screens/video_gallery_screen/video_detail_screen.dart';
import 'package:atmabdulbaridanny/services/providers/api_providers.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class VideoGalleryScreen extends ConsumerWidget {
  const VideoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final videosAsync = ref.watch(videoGalleryProvider);
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

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
              child: Column(
                children: [
                  Text(
                    tr.videoGalleryTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tr.videoGallerySubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Video List
            videosAsync.when(
              data: (videos) {
                if (videos.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text(tr.videoEmpty)),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      final title = video.localizedTitle(isBangla);
                      final rawDate = video.createdAt != null && video.createdAt!.length >= 10
                          ? video.createdAt!.substring(0, 10)
                          : '';
                      final date = rawDate.toBanglaDigits(isBangla);
                      final imgUrl = video.fullImageUrl;
                      final videoId = video.youtubeVideoId ?? 'dQw4w9WgXcQ';

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => VideoDetailScreen(
                                title: title,
                                date: date,
                                videoId: videoId,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, spreadRadius: 1),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Video Thumbnail with Play Button
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                    child: imgUrl.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: imgUrl,
                                            height: 200,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const SizedBox(height: 200, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                                            errorWidget: (context, url, error) =>
                                                Container(height: 200, color: Colors.grey[800], child: const Icon(Icons.videocam, color: Colors.white54, size: 50)),
                                          )
                                        : Container(height: 200, color: Colors.grey[800], child: const Icon(Icons.videocam, color: Colors.white54, size: 50)),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.4),
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(12),
                                    child: const Icon(Icons.play_arrow, color: Colors.white, size: 48),
                                  ),
                                ],
                              ),
                              // Video Details
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                  ],
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
                child: Center(child: Text("Failed to load videos: $err")),
              ),
            ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
