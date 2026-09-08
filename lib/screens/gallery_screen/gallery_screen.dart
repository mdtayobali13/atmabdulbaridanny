import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/photo_gallery_screen/photo_gallery_screen.dart';
import 'package:flutter_riverpod_template/screens/video_gallery_screen/video_gallery_screen.dart';

class GalleryScreen extends StatelessWidget {
  const GalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: AppColors.instance.primaryGreen,
            child: const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              tabs: [
                Tab(text: "Photo Gallery"),
                Tab(text: "Video Gallery"),
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
