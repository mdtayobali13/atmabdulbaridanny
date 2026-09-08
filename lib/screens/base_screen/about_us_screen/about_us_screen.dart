import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';
import 'package:flutter_riverpod_template/services/repository/home_repository.dart';

class AboutUsScreen extends ConsumerStatefulWidget {
  const AboutUsScreen({super.key});

  @override
  ConsumerState<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends ConsumerState<AboutUsScreen> {
  Map<String, dynamic>? _visitStats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await HomeRepository.instance.recordVisit('/about');
    if (mounted && stats != null) {
      setState(() => _visitStats = stats);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final aboutMeAsync = ref.watch(aboutMeProvider);

    final todayVisits = _visitStats?['today_visits']?.toString() ?? '7';
    final totalVisits = _visitStats?['total_visits']?.toString() ?? '221';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Banner with Stats
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.only(top: 36.0, bottom: 20.0, left: 16.0, right: 16.0),
              child: Column(
                children: [
                  const Text(
                    "About Me",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Personal profile, experience, and important information are presented here.",
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

            // 2. Main Content Card
            aboutMeAsync.when(
              data: (aboutMe) {
                final content = aboutMe?.localizedContent(false) ?? '';
                final cleanText = content.replaceAll(RegExp(r'<[^>]*>'), '').trim();
                final imgUrl = aboutMe?.fullImageUrl ?? '';

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 2),
                      ],
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Barrister Kayser Kamal",
                          style: TextStyle(color: primaryGreen, fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        if (imgUrl.isNotEmpty) ...[
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: imgUrl,
                                height: 260,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const SizedBox(
                                  height: 260,
                                  child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 180,
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.person, size: 80, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                        Text(
                          cleanText.isNotEmpty
                              ? cleanText
                              : "Barrister Kayser Kamal is a distinguished Bangladeshi politician and Senior Advocate of the Supreme Court of Bangladesh, representing the people with utmost integrity, justice, and devotion.",
                          style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
                          textAlign: TextAlign.justify,
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text("Failed to load about me: $err")),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Custom Footer
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String title, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
