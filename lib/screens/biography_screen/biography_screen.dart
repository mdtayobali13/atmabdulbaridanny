import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';
import 'package:flutter_riverpod_template/services/repository/home_repository.dart';

class BiographyScreen extends ConsumerStatefulWidget {
  const BiographyScreen({super.key});

  @override
  ConsumerState<BiographyScreen> createState() => _BiographyScreenState();
}

class _BiographyScreenState extends ConsumerState<BiographyScreen> {
  Map<String, dynamic>? _visitStats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await HomeRepository.instance.recordVisit('/biography');
    if (mounted && stats != null) {
      setState(() => _visitStats = stats);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final bioAsync = ref.watch(biographyListProvider);
    final aboutMeAsync = ref.watch(aboutMeProvider);

    final todayVisits = _visitStats?['today_visits']?.toString() ?? '5';
    final totalVisits = _visitStats?['total_visits']?.toString() ?? '192';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Banner with Stats
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.only(top: 36.0, bottom: 24.0, left: 16.0, right: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  const Text(
                    "Biography",
                    style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Life story, legal milestones, and parliamentary leadership of Barrister Kayser Kamal.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatBox("Today Visitor", todayVisits),
                      const SizedBox(width: 16),
                      _buildStatBox("Total Visitor", totalVisits),
                    ],
                  ),
                ],
              ),
            ),

            // 2. About Me Section (if available)
            aboutMeAsync.when(
              data: (aboutMe) {
                if (aboutMe == null) return const SizedBox.shrink();
                final content = aboutMe.localizedContent(false);
                if (content.isEmpty) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, spreadRadius: 1),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (aboutMe.fullImageUrl.isNotEmpty) ...[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: aboutMe.fullImageUrl,
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const SizedBox(height: 200, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                            errorWidget: (context, url, error) => const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      const Text(
                        "About Barrister Kayser Kamal",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        content.replaceAll(RegExp(r'<[^>]*>'), '').trim(),
                        style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (err, stack) => const SizedBox.shrink(),
            ),

            // 3. Biography Milestones List
            bioAsync.when(
              data: (bios) {
                if (bios.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text("No biography entries available")),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: bios.map((bio) {
                      final title = bio.localizedTitle(false);
                      final content = bio.localizedContent(false);
                      final imgUrl = bio.fullImageUrl;

                      return _buildBioCard(
                        title: title,
                        text: content.replaceAll(RegExp(r'<[^>]*>'), '').trim(),
                        imageUrl: imgUrl,
                      );
                    }).toList(),
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text("Failed to load biography: $err")),
              ),
            ),

            const SizedBox(height: 20),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildBioCard({required String title, required String text, required String imageUrl}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const SizedBox(height: 180, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                errorWidget: (context, url, error) =>
                    Container(height: 180, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
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
                const SizedBox(height: 8),
                Text(
                  text,
                  style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
