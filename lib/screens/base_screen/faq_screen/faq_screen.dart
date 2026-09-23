import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/base_screen/faq_screen/providers/f_a_q_screen_provider.dart';
import 'package:atmabdulbaridanny/screens/base_screen/faq_screen/widgets/faq_card.dart';
import 'package:atmabdulbaridanny/screens/base_screen/faq_screen/widgets/faq_card_loader.dart';
import 'package:atmabdulbaridanny/screens/base_screen/widgets/coming_soon_widget.dart';
import 'package:atmabdulbaridanny/utils/app_size.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class FaqScreen extends ConsumerWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBangla = ref.watch(isBanglaProvider);
    final primaryGreen = AppColors.instance.primaryGreen;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isBangla ? "সাধারণ জিজ্ঞাসা (FAQ)" : "FAQ",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: primaryGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final provider = ref.watch(fAQScreenProvider);
          return provider.when(
            data: (data) {
              if (data.isEmpty) {
                return const ComingSoonWidget(
                  titleEn: "Frequently Asked Questions",
                  titleBn: "সাধারণ জিজ্ঞাসা (FAQ)",
                  icon: CupertinoIcons.question_circle_fill,
                  descriptionEn: "Frequently asked questions and answers are currently being prepared and will be available soon.",
                  descriptionBn: "সাধারণ জিজ্ঞাসা ও উত্তরসমূহ বর্তমানে প্রস্তুত করা হচ্ছে এবং খুব শীঘ্রই এখানে প্রকাশ করা হবে।",
                );
              }
              return Padding(
                padding: EdgeInsets.all(AppSize.size.width * 0.05),
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return FaqCard(
                      item: item,
                      onTap: () {
                        ref.read(fAQScreenProvider.notifier).changeItem(index);
                      },
                    );
                  },
                ),
              );
            },
            error: (_, _) => const ComingSoonWidget(
              titleEn: "Frequently Asked Questions",
              titleBn: "সাধারণ জিজ্ঞাসা (FAQ)",
              icon: CupertinoIcons.question_circle_fill,
              descriptionEn: "Frequently asked questions and answers are currently being prepared and will be available soon.",
              descriptionBn: "সাধারণ জিজ্ঞাসা ও উত্তরসমূহ বর্তমানে প্রস্তুত করা হচ্ছে এবং খুব শীঘ্রই এখানে প্রকাশ করা হবে।",
            ),
            loading: () => Skeletonizer(
              child: Padding(
                padding: EdgeInsets.all(AppSize.size.width * 0.05),
                child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return const FaqCardLoader();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
