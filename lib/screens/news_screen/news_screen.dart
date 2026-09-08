import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/news_item.dart';
import 'package:flutter_riverpod_template/screens/news_detail_screen/news_detail_screen.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final newsAsync = ref.watch(newsListProvider);

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
              child: const Column(
                children: [
                  Text(
                    "Latest News & Updates",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Read official press releases, political statements, and news coverage.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Content
            newsAsync.when(
              data: (newsList) {
                if (newsList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text("No news articles available at this moment")),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.82,
                    ),
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      final news = newsList[index];
                      final title = news.localizedTitle(false);
                      final time = news.createdAt != null && news.createdAt!.length >= 10
                          ? news.createdAt!.substring(0, 10)
                          : '';
                      final imgUrl = news.fullImageUrl;
                      final content = news.localizedContent(false);

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                            MaterialPageRoute(
                              builder: (context) => NewsDetailScreen(
                                title: title,
                                time: time,
                                imageUrl: imgUrl,
                                description: content.isNotEmpty ? content : "No additional details provided.",
                                sourceScreenName: "News Details",
                              ),
                            ),
                          );
                        },
                        child: NewsItem(
                          title: title,
                          time: time,
                          imageUrl: imgUrl,
                          sourceScreenName: "News Details",
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
                child: Center(child: Text("Failed to load news: $err")),
              ),
            ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
