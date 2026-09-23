import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/base_screen/privacy_policy_screen/provider/privacy_policy_screen_provider.dart';
import 'package:atmabdulbaridanny/screens/base_screen/widgets/base_data_widget.dart';
import 'package:atmabdulbaridanny/screens/base_screen/widgets/coming_soon_widget.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBangla = ref.watch(isBanglaProvider);
    final primaryGreen = AppColors.instance.primaryGreen;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isBangla ? "গোপনীয়তা নীতি" : "Privacy Policy",
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
          final provider = ref.watch(privacyPolicyScreenProvider);
          return provider.when(
            data: (data) {
              if (data.isEmpty) {
                return const ComingSoonWidget(
                  titleEn: "Privacy Policy",
                  titleBn: "গোপনীয়তা নীতি",
                  icon: CupertinoIcons.shield_fill,
                  descriptionEn: "Our privacy policy details are currently being finalized and will be updated here shortly.",
                  descriptionBn: "আমাদের গোপনীয়তা নীতির বিস্তারিত তথ্যাবলি প্রস্তুত করা হচ্ছে এবং খুব শীঘ্রই এখানে প্রকাশিত হবে।",
                );
              }
              return BaseDataWidget(data: data);
            },
            error: (_, _) => const ComingSoonWidget(
              titleEn: "Privacy Policy",
              titleBn: "গোপনীয়তা নীতি",
              icon: CupertinoIcons.shield_fill,
              descriptionEn: "Our privacy policy details are currently being finalized and will be updated here shortly.",
              descriptionBn: "আমাদের গোপনীয়তা নীতির বিস্তারিত তথ্যাবলি প্রস্তুত করা হচ্ছে এবং খুব শীঘ্রই এখানে প্রকাশিত হবে।",
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
