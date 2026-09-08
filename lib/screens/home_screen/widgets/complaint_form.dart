import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/complain_screen/complain_screen.dart';

class ComplaintForm extends StatelessWidget {
  const ComplaintForm({super.key});

  @override
  Widget build(BuildContext context) {
    final lightGreen = AppColors.instance.lightGreen;

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
          const Text(
            "Submit Citizen Complaint",
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Have an issue, feedback, or grievance in your locality? Submit it directly to Barrister Kayser Kamal's office.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
          ),
          const SizedBox(height: 18),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const ComplainScreen()),
              );
            },
            icon: const Icon(Icons.edit_note, color: Color(0xFF0C4B33)),
            label: const Text(
              "Open Complaint Form",
              style: TextStyle(color: Color(0xFF0C4B33), fontWeight: FontWeight.bold, fontSize: 15),
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
