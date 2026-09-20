import 'package:barristerkayserkamal/services/repository/home_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barristerkayserkamal/constant/app_asserts_image_path.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/custom_footer.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';


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
    final goldenColor = AppColors.instance.goldenColor;
    final bioAsync = ref.watch(biographyListProvider);
    final aboutMeAsync = ref.watch(aboutMeProvider);
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    final todayVisits = (_visitStats?['today_visits']?.toString() ?? '5').toBanglaDigits(isBangla);
    final totalVisits = (_visitStats?['total_visits']?.toString() ?? '192').toBanglaDigits(isBangla);

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
                  Text(
                    tr.biographyTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tr.biographySubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatBox(tr.todayVisitor, todayVisits),
                      const SizedBox(width: 16),
                      _buildStatBox(tr.totalVisitor, totalVisits),
                    ],
                  ),
                ],
              ),
            ),

            // 2. About Me Section (Full Uncropped Picture & Elegant Card)
            aboutMeAsync.when(
              data: (aboutMe) {
                if (aboutMe == null) return const SizedBox.shrink();
                final content = aboutMe.localizedContent(isBangla);
                if (content.isEmpty) return const SizedBox.shrink();

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: goldenColor.withValues(alpha: 0.35), width: 1.2),
                    boxShadow: [
                      BoxShadow(
                        color: primaryGreen.withValues(alpha: 0.08),
                        blurRadius: 16,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Full Uncropped Picture in Luxury Frame
                      Center(
                        child: Container(
                          constraints: const BoxConstraints(maxHeight: 280),
                          padding: const EdgeInsets.all(3.5),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                goldenColor,
                                const Color(0xFFFFF4BF),
                                const Color(0xFFAA771C),
                                goldenColor,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: goldenColor.withValues(alpha: 0.3),
                                blurRadius: 12,
                                spreadRadius: 1,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14.5),
                            child: Container(
                              color: Colors.grey.shade50,
                              child: aboutMe.fullImageUrl.isNotEmpty
                                  ? CachedNetworkImage(
                                      imageUrl: aboutMe.fullImageUrl,
                                      fit: BoxFit.contain, // FULL PICTURE VISIBLE - NO CROPPING
                                      placeholder: (context, url) => const SizedBox(
                                        height: 220,
                                        width: 200,
                                        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        AppAssertsImagePath.instance.barristerKayserKamal,
                                        fit: BoxFit.contain,
                                        height: 220,
                                      ),
                                    )
                                  : Image.asset(
                                      AppAssertsImagePath.instance.barristerKayserKamal,
                                      fit: BoxFit.contain,
                                      height: 220,
                                    ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Name
                      Text(
                        isBangla ? "ব্যারিস্টার কায়সার কামাল, এমপি" : "Barrister Kayser Kamal, MP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primaryGreen,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: goldenColor.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: goldenColor.withValues(alpha: 0.4), width: 1),
                        ),
                        child: Text(
                          isBangla ? "ডেপুটি স্পিকার, বাংলাদেশ জাতীয় সংসদ" : "Deputy Speaker, Bangladesh Parliament",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: primaryGreen,
                          ),
                        ),
                      ),

                      // Decorative Divider
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        height: 1.5,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              goldenColor.withValues(alpha: 0.5),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),

                      // Content Section
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isBangla ? "ব্যারিস্টার কায়সার কামাল সম্পর্কে" : "About Barrister Kayser Kamal",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: primaryGreen,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        content.replaceAll(RegExp(r'<[^>]*>'), '').trim(),
                        style: const TextStyle(
                          fontSize: 14.5,
                          height: 1.7,
                          color: Colors.black87,
                          letterSpacing: 0.15,
                        ),
                        textAlign: TextAlign.justify,
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text(tr.biographyEmpty)),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Column(
                    children: bios.map((bio) {
                      final title = bio.localizedTitle(isBangla);
                      final content = bio.localizedContent(isBangla);
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
                child: Center(child: Text(isBangla ? "লোড করতে ব্যর্থ হয়েছে: $err" : "Failed to load biography: $err")),
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
