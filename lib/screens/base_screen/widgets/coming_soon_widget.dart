import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';
import 'package:go_router/go_router.dart';

class ComingSoonWidget extends ConsumerWidget {
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final IconData icon;

  const ComingSoonWidget({
    super.key,
    required this.titleEn,
    required this.titleBn,
    this.descriptionEn = "We are currently preparing and updating this section. It will be available very soon.",
    this.descriptionBn = "এই বিভাগটি বর্তমানে প্রস্তুত ও আপডেট করা হচ্ছে। খুব শীঘ্রই এটি এখানে প্রকাশ করা হবে।",
    this.icon = CupertinoIcons.hourglass,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBangla = ref.watch(isBanglaProvider);
    final primaryGreen = AppColors.instance.primaryGreen;
    final golden = AppColors.instance.goldenColor;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Badge with Outer Rings & Glow
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    primaryGreen.withValues(alpha: 0.1),
                    golden.withValues(alpha: 0.15),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(
                  color: golden.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryGreen.withValues(alpha: 0.08),
                    blurRadius: 24,
                    spreadRadius: 6,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryGreen,
                    boxShadow: [
                      BoxShadow(
                        color: primaryGreen.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      icon,
                      size: 38,
                      color: golden,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 28),

            // "Coming Soon" Pill Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: golden.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: golden.withValues(alpha: 0.4),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: golden,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isBangla ? "শীঘ্রই আসছে" : "Coming Soon",
                    style: TextStyle(
                      color: golden,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              isBangla ? titleBn : titleEn,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryGreen,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 10),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                isBangla ? descriptionBn : descriptionEn,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Back Button
            SizedBox(
              width: 170,
              height: 46,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    context.go('/homeScreen');
                  }
                },
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
                label: Text(
                  isBangla ? "ফিরে যান" : "Go Back",
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
