import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/screens/video_gallery_screen/video_detail_screen.dart';

class VideoGalleryScreen extends StatelessWidget {
  const VideoGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;

    final List<Map<String, String>> videos = [
      {
        "title": "Prime Minister takes oath for a new term",
        "subtitle": "Video Album",
        "date": "12 March 2024",
        "imageUrl": "https://picsum.photos/seed/v1/400/250",
        "videoId": "dQw4w9WgXcQ",
      },
      {
        "title": "Discussion meeting protesting human rights...",
        "subtitle": "Video Album",
        "date": "15 March 2024",
        "imageUrl": "https://picsum.photos/seed/v2/400/250",
        "videoId": "y881t8ilMyc",
      },
      {
        "title": "Exchange of views meeting with lawyers",
        "subtitle": "Video Album",
        "date": "18 March 2024",
        "imageUrl": "https://picsum.photos/seed/v3/400/250",
        "videoId": "jNQXAC9IVRw",
      },
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
                    "Watch videos of various programs, offices, events, and important moments.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            // Video List
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: videos.length,
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => VideoDetailScreen(
                            title: video["title"]!,
                            date: video["date"]!,
                            videoId: video["videoId"]!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 4, spreadRadius: 1),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Thumbnail with Play Button and Date
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                child: CachedNetworkImage(
                                  imageUrl: video["imageUrl"]!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              // Dark Overlay
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                  ),
                                ),
                              ),
                              // Play Button
                              Positioned.fill(
                                child: Center(
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.play_arrow, color: primaryGreen, size: 32),
                                  ),
                                ),
                              ),
                              // Date Badge
                              Positioned(
                                bottom: 8,
                                left: 8,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    video["date"]!,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Text Content
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        video["title"]!,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        video["subtitle"]!,
                                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(Icons.share, size: 16, color: Colors.black54),
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
            ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
