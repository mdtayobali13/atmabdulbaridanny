import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/photo_gallery_screen/photo_gallery_screen.dart';
import 'package:atmabdulbaridanny/screens/video_gallery_screen/video_gallery_screen.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class GalleryScreen extends ConsumerWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: AppColors.instance.primaryGreen,
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: [
                Tab(text: tr.menuPhotoGallery),
                Tab(text: tr.menuVideoGallery),
              ],
            ),
          ),
          const Expanded(
            child: TabBarView(
              children: [
                PhotoGalleryScreen(),
                VideoGalleryScreen(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
