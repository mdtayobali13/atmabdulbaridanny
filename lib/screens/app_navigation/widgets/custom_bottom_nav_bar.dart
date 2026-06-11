import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/app_navigation/widgets/nav_bar_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.instance.black600,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarItem(isSelected: currentIndex == 0, icon: CupertinoIcons.house, filledIcon: CupertinoIcons.house_fill, onTap: () => onTap(0)),
            NavBarItem(isSelected: currentIndex == 1, icon: CupertinoIcons.heart, filledIcon: CupertinoIcons.heart_fill, onTap: () => onTap(1)),
            NavBarItem(isSelected: currentIndex == 2, icon: CupertinoIcons.globe, filledIcon: CupertinoIcons.globe, onTap: () => onTap(2)),
            NavBarItem(
              isSelected: currentIndex == 3,
              icon: CupertinoIcons.chat_bubble_2,
              filledIcon: CupertinoIcons.chat_bubble_2_fill,
              onTap: () => onTap(3),
            ),
            NavBarItem(isSelected: currentIndex == 4, icon: CupertinoIcons.person, filledIcon: CupertinoIcons.person_fill, onTap: () => onTap(4)),
          ],
        ),
      ),
    );
  }
}
