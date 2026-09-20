import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/screens/app_navigation/widgets/nav_bar_item.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';

class CustomBottomNavBar extends ConsumerStatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  ConsumerState<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends ConsumerState<CustomBottomNavBar> {
  int? _openedMenuIndex;

  @override
  Widget build(BuildContext context) {
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.instance.primaryGreen,
        border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.05), width: 1)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NavBarItem(
              isSelected: widget.currentIndex == 0,
              icon: CupertinoIcons.house,
              filledIcon: CupertinoIcons.house_fill,
              onTap: () => widget.onTap(0),
            ),
            NavBarItem(
              isSelected: widget.currentIndex == 1,
              icon: CupertinoIcons.news,
              filledIcon: CupertinoIcons.news_solid,
              onTap: () => widget.onTap(1),
            ),
            NavBarItem(
              isSelected: widget.currentIndex == 2,
              icon: CupertinoIcons.book,
              filledIcon: CupertinoIcons.book_fill,
              onTap: () => widget.onTap(2),
            ),
            Builder(
              builder: (context) {
                final isSelected = widget.currentIndex == 3 || widget.currentIndex == 4 || _openedMenuIndex == 3;
                return NavBarItem(
                  isSelected: isSelected,
                  icon: CupertinoIcons.photo,
                  filledIcon: CupertinoIcons.photo_fill,
                  onTap: () {
                    setState(() {
                      _openedMenuIndex = 3;
                    });
                    final RenderBox button = context.findRenderObject() as RenderBox;
                    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
                    final RelativeRect position = RelativeRect.fromRect(
                      Rect.fromPoints(
                        button.localToGlobal(const Offset(0, -120), ancestor: overlay),
                        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                      ),
                      Offset.zero & overlay.size,
                    );
                    showMenu(
                      context: context,
                      position: position,
                      color: AppColors.instance.primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      items: [
                        PopupMenuItem(
                          value: 3,
                          child: Text(tr.menuPhotoGallery, style: const TextStyle(color: Colors.white)),
                        ),
                        PopupMenuItem(
                          value: 4,
                          child: Text(tr.menuVideoGallery, style: const TextStyle(color: Colors.white)),
                        ),
                      ],
                    ).then((value) {
                      setState(() {
                        _openedMenuIndex = null;
                      });
                      if (value != null) {
                        widget.onTap(value);
                      }
                    });
                  },
                );
              },
            ),
            Builder(
              builder: (context) {
                final currentRoute = GoRouterState.of(context).uri.toString();
                final isSecondaryScreen = currentRoute.contains('kalmakanda_upazila_screen') ||
                    currentRoute.contains('durgapur_upazila_screen') ||
                    currentRoute.contains('others_screen') ||
                    currentRoute.contains('print_media_screen') ||
                    currentRoute.contains('electronic_media_screen') ||
                    currentRoute.contains('contact_screen') ||
                    currentRoute.contains('appointment_screen');
                    
                final isSelected = (widget.currentIndex == 5 && !isSecondaryScreen) || _openedMenuIndex == 5;

                return NavBarItem(
                  isSelected: isSelected,
                  icon: CupertinoIcons.person,
                  filledIcon: CupertinoIcons.person_solid,
                  onTap: () {
                    setState(() {
                      _openedMenuIndex = 5;
                    });
                    final RenderBox button = context.findRenderObject() as RenderBox;
                    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
                    final RelativeRect position = RelativeRect.fromRect(
                      Rect.fromPoints(
                        button.localToGlobal(const Offset(0, -265), ancestor: overlay),
                        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
                      ),
                      Offset.zero & overlay.size,
                    );
                    final router = GoRouter.of(context);
                    showMenu(
                      context: context,
                      position: position,
                      color: AppColors.instance.primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      items: <PopupMenuEntry<String>>[
                        _buildPopupMenuItem("About Me", tr.menuAboutMe),
                        _buildPopupMenuItem("Biography", tr.menuBiography),
                        _buildPopupMenuItem("History", tr.menuHistoryOfLifeAndStruggle),
                        _buildPopupMenuItem("Achievement", tr.menuAchievement),
                        _buildPopupMenuItem("Journey", tr.menuJourney),
                      ],
                    ).then((value) {
                      if (!mounted) return;
                      setState(() {
                        _openedMenuIndex = null;
                      });
                      if (value != null) {
                        if (value == "About Me") {
                          widget.onTap(5); // Existing index
                        } else if (value == "Biography") {
                          router.go('/biography_screen');
                        } else if (value == "History") {
                          router.go('/history_of_life_screen');
                        } else if (value == "Achievement") {
                          router.go('/achievement_screen');
                        } else if (value == "Journey") {
                          router.go('/journey_screen');
                        } else {
                          widget.onTap(5); // Fallback for unimplemented
                        }
                      }
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(String value, String text) {
    return PopupMenuItem<String>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}
