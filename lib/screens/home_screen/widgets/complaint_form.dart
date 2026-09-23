import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/complain_screen/complain_screen.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class ComplaintForm extends ConsumerWidget {
  const ComplaintForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightGreen = AppColors.instance.lightGreen;
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: lightGreen,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.rate_review_outlined, color: Colors.white, size: 36),
          const SizedBox(height: 8),
          Text(
            tr.complaintCardTitle,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            tr.complaintCardSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const ComplainScreen()),
              );
            },
            icon: const Icon(Icons.edit_note, color: Color(0xFF0C4B33)),
            label: Text(
              tr.submitComplaintBtn,
              style: const TextStyle(color: Color(0xFF0C4B33), fontWeight: FontWeight.bold, fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 2,
            ),
          ),
        ],
      ),
    );
  }
}
