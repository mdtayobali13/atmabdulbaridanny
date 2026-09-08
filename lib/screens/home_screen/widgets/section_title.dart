import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAllPressed;

  const SectionTitle({super.key, required this.title, this.onViewAllPressed});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen),
          ),
          TextButton(
            onPressed: onViewAllPressed ?? () {},
            style: TextButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              minimumSize: const Size(0, 30),
            ),
            child: const Text("View All", style: TextStyle(fontSize: 12)),
          )
        ],
      ),
    );
  }
}
