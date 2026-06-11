import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/screens/app_navigation/widgets/selected_icon_widget.dart';

class NavBarItem extends StatelessWidget {
  final bool isSelected;
  final IconData? icon;
  final IconData? filledIcon;
  final String? assetPath;
  final VoidCallback onTap;

  const NavBarItem({super.key, required this.isSelected, this.icon, this.filledIcon, this.assetPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: 65,
        height: 60,
        alignment: Alignment.center,
        child: isSelected
            ? SelectedIconWidget(icon: filledIcon ?? icon, assetPath: assetPath)
            : assetPath != null
            ? Image.asset(
                assetPath!,
                width: 26,
                height: 26,
                color: Colors.white.withValues(alpha: 0.7),
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported_outlined, color: Colors.white.withValues(alpha: 0.5), size: 26),
              )
            : Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 26),
      ),
    );
  }
}
