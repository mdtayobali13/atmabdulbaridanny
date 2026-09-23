import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/home_screen/widgets/card_item.dart';
import 'package:atmabdulbaridanny/screens/home_screen/widgets/custom_footer.dart';
import 'package:atmabdulbaridanny/services/providers/api_providers.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class BlogScreen extends ConsumerWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final blogsAsync = ref.watch(blogListProvider);
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
                    tr.blogTitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tr.blogSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // Grid content
            blogsAsync.when(
              data: (blogs) {
                if (blogs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text(tr.blogEmpty)),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    spacing: 12,
                    runSpacing: 16,
                    alignment: WrapAlignment.center,
                    children: blogs.map((blog) {
                      final title = blog.localizedTitle(isBangla);
                      final imgUrl = blog.fullImageUrl;
                      final content = blog.localizedContent(isBangla);
                      final rawTime = blog.createdAt != null && blog.createdAt!.length >= 10
                          ? blog.createdAt!.substring(0, 10)
                          : '';
                      final time = rawTime.toBanglaDigits(isBangla);

                      return FractionallySizedBox(
                        widthFactor: 0.47,
                        child: CardItem(
                          title: title,
                          btnText: tr.readMore,
                          imageUrl: imgUrl,
                          time: time,
                          description: content.isNotEmpty
                              ? content
                              : (isBangla ? "কোন বিস্তারিত বিবরণ পাওয়া যায়নি।" : "No detailed article body provided."),
                          sourceScreenName: isBangla ? "ব্লগ ও প্রকাশনা" : "Blog Article",
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
                child: Center(child: Text(isBangla ? "লোড করতে ব্যর্থ হয়েছে: $err" : "Failed to load blog articles: $err")),
              ),
            ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
