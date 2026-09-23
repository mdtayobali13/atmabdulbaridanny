import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/base_screen/terms_and_conditions_screen/provider/terms_and_conditions_screen_provider.dart';
import 'package:atmabdulbaridanny/screens/base_screen/widgets/base_data_widget.dart';
import 'package:atmabdulbaridanny/screens/base_screen/widgets/coming_soon_widget.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class TermsAndConditionsScreen extends ConsumerWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBangla = ref.watch(isBanglaProvider);
    final primaryGreen = AppColors.instance.primaryGreen;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isBangla ? "শর্তাবলী ও নীতিমালা" : "Terms & Conditions",
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
          final provider = ref.watch(termsAndConditionsScreenProvider);
          return provider.when(
            data: (data) {
              if (data.isEmpty) {
                return const ComingSoonWidget(
                  titleEn: "Terms & Conditions",
                  titleBn: "শর্তাবলী ও নীতিমালা",
                  icon: CupertinoIcons.doc_text_fill,
                  descriptionEn: "Terms and conditions are currently being formulated and will be published here soon.",
                  descriptionBn: "আমাদের শর্তাবলী ও নীতিমালা প্রক্রিয়াধীন রয়েছে এবং খুব শীঘ্রই এখানে প্রকাশ করা হবে।",
                );
              }
              return BaseDataWidget(data: data);
            },
            error: (_, _) => const ComingSoonWidget(
              titleEn: "Terms & Conditions",
              titleBn: "শর্তাবলী ও নীতিমালা",
              icon: CupertinoIcons.doc_text_fill,
              descriptionEn: "Terms and conditions are currently being formulated and will be published here soon.",
              descriptionBn: "আমাদের শর্তাবলী ও নীতিমালা প্রক্রিয়াধীন রয়েছে এবং খুব শীঘ্রই এখানে প্রকাশ করা হবে।",
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
