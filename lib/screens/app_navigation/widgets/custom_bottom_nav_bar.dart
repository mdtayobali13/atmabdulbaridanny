import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/app_navigation/widgets/nav_bar_item.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class CustomBottomNavBar extends ConsumerStatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  ConsumerState<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends ConsumerState<CustomBottomNavBar> {
  int? _openedMenuIndex;

  RelativeRect _getMenuPosition(BuildContext context, double menuHeight) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay = Navigator.of(context).overlay!.context.findRenderObject() as RenderBox;
    return RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset(0, -menuHeight), ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);
    final currentRoute = GoRouterState.of(context).uri.toString();
    final router = GoRouter.of(context);

    // Active status detection based on current route
    final isHomeActive = (widget.currentIndex == 0 && currentRoute.contains('homeScreen')) ||
        (currentRoute == '/' || currentRoute == '/homeScreen');

    final isAboutActive = currentRoute.contains('aboutScreen') ||
        currentRoute.contains('biography_screen') ||
        currentRoute.contains('history_of_life_screen') ||
        currentRoute.contains('achievement_screen') ||
        currentRoute.contains('journey_screen') ||
        _openedMenuIndex == 1;

    final isDevWorksActive = currentRoute.contains('netrokona_sadar_upazila_screen') ||
        currentRoute.contains('barhatta_upazila_screen') ||
        currentRoute.contains('others_screen') ||
        currentRoute.contains('kalmakanda_upazila_screen') ||
        currentRoute.contains('durgapur_upazila_screen') ||
        _openedMenuIndex == 2;

    final isMediaGalleryActive = currentRoute.contains('photo_gallery_screen') ||
        currentRoute.contains('video_gallery_screen') ||
        currentRoute.contains('print_media_screen') ||
        currentRoute.contains('electronic_media_screen') ||
        (widget.currentIndex == 3 || widget.currentIndex == 4) ||
        _openedMenuIndex == 3;

    final isServicesActive = currentRoute.contains('blog_screen') ||
        currentRoute.contains('news_screen') ||
        currentRoute.contains('contact_screen') ||
        currentRoute.contains('appointment_screen') ||
        currentRoute.contains('complain_screen') ||
        (widget.currentIndex == 1 || widget.currentIndex == 2) ||
        _openedMenuIndex == 4;

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
            // 1. প্রথম পাতা / Home
            NavBarItem(
              isSelected: isHomeActive && _openedMenuIndex == null,
              icon: CupertinoIcons.house,
              filledIcon: CupertinoIcons.house_fill,
              onTap: () => widget.onTap(0),
            ),

            // 2. আমাদের সম্পর্কে / About Us
            Builder(
              builder: (context) {
                return NavBarItem(
                  isSelected: isAboutActive,
                  icon: CupertinoIcons.person_2,
                  filledIcon: CupertinoIcons.person_2_fill,
                  onTap: () {
                    setState(() => _openedMenuIndex = 1);
                    final position = _getMenuPosition(context, 260);
                    showMenu<String>(
                      context: context,
                      position: position,
                      color: AppColors.instance.primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      items: [
                        _buildPopupMenuItem("About Me", tr.menuAboutMe),
                        _buildPopupMenuItem("Biography", tr.menuBiography),
                        _buildPopupMenuItem("History", tr.menuHistoryOfLifeAndStruggle),
                        _buildPopupMenuItem("Achievement", tr.menuAchievement),
                        _buildPopupMenuItem("Journey", tr.menuJourney),
                      ],
                    ).then((value) {
                      if (!mounted) return;
                      setState(() => _openedMenuIndex = null);
                      if (value != null) {
                        if (value == "About Me") {
                          widget.onTap(5);
                        } else if (value == "Biography") {
                          router.go('/biography_screen');
                        } else if (value == "History") {
                          router.go('/history_of_life_screen');
                        } else if (value == "Achievement") {
                          router.go('/achievement_screen');
                        } else if (value == "Journey") {
                          router.go('/journey_screen');
                        }
                      }
                    });
                  },
                );
              },
            ),

            // 3. উন্নয়নমূলক কাজ / Development Works
            Builder(
              builder: (context) {
                return NavBarItem(
                  isSelected: isDevWorksActive,
                  icon: CupertinoIcons.building_2_fill,
                  filledIcon: CupertinoIcons.building_2_fill,
                  onTap: () {
                    setState(() => _openedMenuIndex = 2);
                    final position = _getMenuPosition(context, 165);
                    showMenu<String>(
                      context: context,
                      position: position,
                      color: AppColors.instance.primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      items: [
                        _buildPopupMenuItem("Netrokona Sadar", tr.menuNetrokonaSadar),
                        _buildPopupMenuItem("Barhatta", tr.menuBarhatta),
                        _buildPopupMenuItem("Others", tr.menuOthers),
                      ],
                    ).then((value) {
                      if (!mounted) return;
                      setState(() => _openedMenuIndex = null);
                      if (value != null) {
                        if (value == "Netrokona Sadar") {
                          router.go('/netrokona_sadar_upazila_screen');
                        } else if (value == "Barhatta") {
                          router.go('/barhatta_upazila_screen');
                        } else if (value == "Others") {
                          router.go('/others_screen');
                        }
                      }
                    });
                  },
                );
              },
            ),

            // 4. মিডিয়া ও গ্যালারি / Media & Gallery
            Builder(
              builder: (context) {
                return NavBarItem(
                  isSelected: isMediaGalleryActive,
                  icon: CupertinoIcons.photo_on_rectangle,
                  filledIcon: CupertinoIcons.photo_fill_on_rectangle_fill,
                  onTap: () {
                    setState(() => _openedMenuIndex = 3);
                    final position = _getMenuPosition(context, 210);
                    showMenu<String>(
                      context: context,
                      position: position,
                      color: AppColors.instance.primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      items: [
                        _buildPopupMenuItem("Photo Gallery", tr.menuPhotoGallery),
                        _buildPopupMenuItem("Video Gallery", tr.menuVideoGallery),
                        _buildPopupMenuItem("Print Media", tr.menuPrintMedia),
                        _buildPopupMenuItem("Electronic Media", tr.menuElectronicMedia),
                      ],
                    ).then((value) {
                      if (!mounted) return;
                      setState(() => _openedMenuIndex = null);
                      if (value != null) {
                        if (value == "Photo Gallery") {
                          widget.onTap(3);
                        } else if (value == "Video Gallery") {
                          widget.onTap(4);
                        } else if (value == "Print Media") {
                          router.go('/print_media_screen');
                        } else if (value == "Electronic Media") {
                          router.go('/electronic_media_screen');
                        }
                      }
                    });
                  },
                );
              },
            ),

            // 5. যোগাযোগ ও সেবা / Contact & Services
            Builder(
              builder: (context) {
                return NavBarItem(
                  isSelected: isServicesActive,
                  icon: CupertinoIcons.chat_bubble_2,
                  filledIcon: CupertinoIcons.chat_bubble_2_fill,
                  onTap: () {
                    setState(() => _openedMenuIndex = 4);
                    final position = _getMenuPosition(context, 260);
                    showMenu<String>(
                      context: context,
                      position: position,
                      color: AppColors.instance.primaryGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      items: [
                        _buildPopupMenuItem("Blog", tr.menuBlog),
                        _buildPopupMenuItem("News", tr.menuNews),
                        _buildPopupMenuItem("Contact", tr.menuContact),
                        _buildPopupMenuItem("Appointment", tr.menuAppointment),
                        _buildPopupMenuItem("Complaint", tr.menuComplaint),
                      ],
                    ).then((value) {
                      if (!mounted) return;
                      setState(() => _openedMenuIndex = null);
                      if (value != null) {
                        if (value == "Blog") {
                          widget.onTap(2);
                        } else if (value == "News") {
                          widget.onTap(1);
                        } else if (value == "Contact") {
                          router.go('/contact_screen');
                        } else if (value == "Appointment") {
                          router.push('/appointment_screen');
                        } else if (value == "Complaint") {
                          router.push('/complain_screen');
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
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
    );
  }
}
