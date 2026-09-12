import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/news_item.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/screens/news_detail_screen/news_detail_screen.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';
import 'package:flutter_riverpod_template/services/repository/home_repository.dart';
import 'package:flutter_riverpod_template/utils/languages/language_provider.dart';

class PrintMediaScreen extends ConsumerStatefulWidget {
  const PrintMediaScreen({super.key});

  @override
  ConsumerState<PrintMediaScreen> createState() => _PrintMediaScreenState();
}

class _PrintMediaScreenState extends ConsumerState<PrintMediaScreen> {
  Map<String, dynamic>? _visitStats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await HomeRepository.instance.recordVisit('/print-media');
    if (mounted && stats != null) {
      setState(() => _visitStats = stats);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final newsAsync = ref.watch(newsListProvider);
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    final todayVisits = (_visitStats?['today_visits']?.toString() ?? '7').toBanglaDigits(isBangla);
    final totalVisits = (_visitStats?['total_visits']?.toString() ?? '113').toBanglaDigits(isBangla);

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
                  Text(
                    tr.printMediaTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr.printMediaSubtitle,
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

            // 2. Main Content Grid
            newsAsync.when(
              data: (newsList) {
                if (newsList.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text(tr.printMediaEmpty)),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final item = newsList[index];
                      final title = item.localizedTitle(isBangla);
                      final rawTime = item.createdAt != null && item.createdAt!.length >= 10
                          ? item.createdAt!.substring(0, 10)
                          : '';
                      final time = rawTime.toBanglaDigits(isBangla);
                      final imgUrl = item.fullImageUrl;
                      final content = item.localizedContent(isBangla);
                      final screenName = tr.printMediaTitle;

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => NewsDetailScreen(
                                title: title,
                                time: time,
                                imageUrl: imgUrl,
                                description: content.isNotEmpty
                                    ? content
                                    : (isBangla ? "কোন অতিরিক্ত বিবরণ পাওয়া যায়নি।" : "No additional details provided."),
                                sourceScreenName: screenName,
                              ),
                            ),
                          );
                        },
                        child: NewsItem(
                          title: title,
                          time: time,
                          imageUrl: imgUrl,
                          sourceScreenName: screenName,
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
                child: Center(child: Text(isBangla ? "লোড করতে ব্যর্থ হয়েছে: $err" : "Failed to load: $err")),
              ),
            ),

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
