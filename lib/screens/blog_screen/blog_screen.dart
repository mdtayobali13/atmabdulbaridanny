import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/card_item.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';

class BlogScreen extends ConsumerWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final blogsAsync = ref.watch(blogListProvider);

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
                    "Articles & Publications",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Read articles, legal opinions, and analyses written by Barrister Kayser Kamal.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Grid content
            blogsAsync.when(
              data: (blogs) {
                if (blogs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text("No blog articles available at this moment")),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: blogs.map((blog) {
                      final title = blog.localizedTitle(false);
                      final imgUrl = blog.fullImageUrl;
                      final content = blog.localizedContent(false);
                      final time = blog.createdAt != null && blog.createdAt!.length >= 10
                          ? blog.createdAt!.substring(0, 10)
                          : '';

                      return FractionallySizedBox(
                        widthFactor: 0.47,
                        child: CardItem(
                          title: title,
                          btnText: "Read More",
                          imageUrl: imgUrl,
                          time: time,
                          description: content.isNotEmpty ? content : "No detailed article body provided.",
                          sourceScreenName: "Blog Article",
                        ),
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
                child: Center(child: Text("Failed to load blog articles: $err")),
              ),
            ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
