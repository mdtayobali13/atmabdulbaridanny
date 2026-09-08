import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/screens/video_gallery_screen/video_detail_screen.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';
import 'package:flutter_riverpod_template/services/repository/home_repository.dart';

class ElectronicMediaScreen extends ConsumerStatefulWidget {
  const ElectronicMediaScreen({super.key});

  @override
  ConsumerState<ElectronicMediaScreen> createState() => _ElectronicMediaScreenState();
}

class _ElectronicMediaScreenState extends ConsumerState<ElectronicMediaScreen> {
  Map<String, dynamic>? _visitStats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await HomeRepository.instance.recordVisit('/electronic-media');
    if (mounted && stats != null) {
      setState(() => _visitStats = stats);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final mediaAsync = ref.watch(electronicMediaProvider);

    final todayVisits = _visitStats?['today_visits']?.toString() ?? '3';
    final totalVisits = _visitStats?['total_visits']?.toString() ?? '145';

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
                    "Browse television interviews, broadcast news, and electronic media reports.",
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
                  _buildStatItem("Today Visitor", todayVisits),
                  Container(
                    width: 1,
                    height: 30,
                    color: Colors.white30,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  _buildStatItem("Total Visitor", totalVisits),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Content List
            mediaAsync.when(
              data: (mediaList) {
                if (mediaList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text("No electronic media items available")),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: mediaList.length,
                    itemBuilder: (context, index) {
                      final item = mediaList[index];
                      final title = item.localizedTitle(false);
                      final date = item.createdAt != null && item.createdAt!.length >= 10
                          ? item.createdAt!.substring(0, 10)
                          : '';
                      final imgUrl = item.fullImageUrl;
                      final videoId = item.youtubeVideoId ?? 'dQw4w9WgXcQ';

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
                              BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2)),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    imgUrl.isNotEmpty
                                        ? CachedNetworkImage(
                                            imageUrl: imgUrl,
                                            height: 180,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                const SizedBox(height: 180, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                                            errorWidget: (context, url, error) =>
                                                Container(height: 180, color: Colors.grey[800], child: const Icon(Icons.videocam, color: Colors.white54, size: 48)),
                                          )
                                        : Container(height: 180, color: Colors.grey[800], child: const Icon(Icons.videocam, color: Colors.white54, size: 48)),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black.withValues(alpha: 0.4),
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      child: const Icon(Icons.play_arrow, color: Colors.white, size: 40),
                                    ),
                                  ],
                                ),
                              ),
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
                child: Center(child: Text("Failed to load media: $err")),
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
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
