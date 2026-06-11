import 'package:flutter/material.dart';

class SelectedIconWidget extends StatelessWidget {
  final IconData? icon;
  final String? assetPath;

  const SelectedIconWidget({super.key, this.icon, this.assetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      alignment: Alignment.center,
      child: assetPath != null
          ? Image.asset(
              assetPath!,
              width: 26,
              height: 26,
              color: Colors.white,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.image_not_supported_outlined, color: Colors.white54, size: 24),
            )
          : Icon(icon, color: Colors.white, size: 26),
    );
  }
}
