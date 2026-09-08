import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/screens/video_gallery_screen/video_detail_screen.dart';

class ElectronicMediaScreen extends StatelessWidget {
  const ElectronicMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;

    final List<Map<String, String>> mediaList = [
      {
        "title": "Tarique Rahman Prime Minister Oath",
        "subtitle": "Watch coverage",
        "date": "16 March 2024",
        "imageUrl": "https://picsum.photos/seed/em1/400/250",
        "videoId": "dQw4w9WgXcQ",
        "tag": "Media",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Top Green Banner
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: const Column(
                children: [
                  SizedBox(height: 16),
                  Text(
                    "Electronic Media",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Browse videos, broadcasts, and important electronic media coverage here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            // Visitor Stats
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              color: primaryGreen.withValues(alpha: 0.9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatItem("Today Visitor", "3"),
                  Container(
                    width: 1,
                    height: 40,
                    color: Colors.white30,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  _buildStatItem("Total Visitor", "96"),
                ],
              ),
            ),

            // Media List
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: mediaList.length,
                itemBuilder: (context, index) {
                  final media = mediaList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (context) => VideoDetailScreen(
                            title: media["title"]!,
                            date: media["date"]!,
                            videoId: media["videoId"]!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 4, spreadRadius: 1),
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
                                  imageUrl: media["imageUrl"]!,
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
                                    media["date"]!,
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
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  media["title"]!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(media["subtitle"]!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: primaryGreen.withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: primaryGreen.withValues(alpha: 0.3)),
                                      ),
                                      child: Text(
                                        media["tag"]!,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: primaryGreen,
                                        ),
                                      ),
                                    ),
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
            ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
