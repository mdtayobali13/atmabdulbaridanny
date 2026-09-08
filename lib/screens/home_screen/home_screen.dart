import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/appointment_form.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/card_item.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/complaint_form.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/grid_list.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/horizontal_list.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/map_section.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/news_item.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/photo_gallery.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/section_title.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/video_gallery.dart';
import 'package:flutter_riverpod_template/screens/life_history_screen/life_history_screen.dart';
import 'package:flutter_riverpod_template/screens/print_media_screen/print_media_screen.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';
import 'package:flutter_riverpod_template/services/repository/home_repository.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Track visit to /home
    HomeRepository.instance.recordVisit('/home');
  }

  @override
  Widget build(BuildContext context) {
    final slidersAsync = ref.watch(sliderListProvider);
    final lifeAsync = ref.watch(lifeStruggleListProvider);
    final newsAsync = ref.watch(newsListProvider);
    final blogsAsync = ref.watch(blogListProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─────────────────────────────────────────────────────────────
            // 1. Banner Slider (Live API)
            // ─────────────────────────────────────────────────────────────
            slidersAsync.when(
              data: (sliders) {
                if (sliders.isEmpty) {
                  return _buildDefaultBanner();
                }
                return CarouselSlider(
                  options: CarouselOptions(
                    height: 230.0,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.92,
                    autoPlayInterval: const Duration(seconds: 4),
                  ),
                  items: sliders.map((slider) {
                    final imgUrl = slider.fullImageUrl;
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.1), spreadRadius: 1, blurRadius: 5),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: imgUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl: imgUrl,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                              )
                            : const Icon(Icons.image, size: 40, color: Colors.grey),
                      ),
                    );
                  }).toList(),
                );
              },
              loading: () => Container(
                height: 220,
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => _buildDefaultBanner(),
            ),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────
            // 2. Life & Success Records (Live API)
            // ─────────────────────────────────────────────────────────────
            SectionTitle(
              title: "Life & Success Records",
              onViewAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LifeHistoryScreen()));
              },
            ),
            lifeAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text("No life history records available")),
                  );
                }
                return HorizontalList(
                  items: items.map((item) {
                    final time = item.createdAt != null && item.createdAt!.length >= 10
                        ? item.createdAt!.substring(0, 10)
                        : '';
                    final desc = item.localizedContent(false).replaceAll(RegExp(r'<[^>]*>'), '').trim();
                    return CardItem(
                      title: item.localizedTitle(false),
                      btnText: "Read More",
                      imageUrl: item.fullImageUrl,
                      time: time,
                      description: desc,
                      sourceScreenName: "Life & Success Records",
                    );
                  }).toList(),
                );
              },
              loading: () => const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────
            // 3. Citizen Request Sections
            // ─────────────────────────────────────────────────────────────
            const AppointmentForm(),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────
            // 4. News & Activities (Live API)
            // ─────────────────────────────────────────────────────────────
            SectionTitle(
              title: "News & Activities",
              onViewAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PrintMediaScreen()));
              },
            ),
            newsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text("No news available")),
                  );
                }
                final displayItems = items.take(4).toList();
                return GridList(
                  items: displayItems.map((news) {
                    return NewsItem(
                      title: news.localizedTitle(false),
                      time: news.createdAt != null && news.createdAt!.length >= 10
                          ? news.createdAt!.substring(0, 10)
                          : '',
                      imageUrl: news.fullImageUrl,
                      sourceScreenName: "News & Activities",
                    );
                  }).toList(),
                );
              },
              loading: () => const SizedBox(
                height: 180,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────
            // 5. Blog (Live API)
            // ─────────────────────────────────────────────────────────────
            SectionTitle(
              title: "Blog",
              onViewAllPressed: () {
                AppRoutes.instance.go("/blog_screen");
              },
            ),
            blogsAsync.when(
              data: (blogs) {
                if (blogs.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text("No blog articles available")),
                  );
                }
                return HorizontalList(
                  items: blogs.map((blog) {
                    final time = blog.createdAt != null && blog.createdAt!.length >= 10
                        ? blog.createdAt!.substring(0, 10)
                        : '';
                    final desc = blog.localizedContent(false).replaceAll(RegExp(r'<[^>]*>'), '').trim();
                    return CardItem(
                      title: blog.localizedTitle(false),
                      btnText: "Read More",
                      imageUrl: blog.fullImageUrl,
                      time: time,
                      description: desc,
                      sourceScreenName: "Blog",
                    );
                  }).toList(),
                );
              },
              loading: () => const SizedBox(
                height: 150,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => const SizedBox.shrink(),
            ),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────
            // 6. Photo Gallery (Live API)
            // ─────────────────────────────────────────────────────────────
            SectionTitle(
              title: "Photo Gallery",
              onViewAllPressed: () {
                AppRoutes.instance.go("/photo_gallery_screen");
              },
            ),
            const PhotoGallery(),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────
            // 7. Video Gallery (Live API)
            // ─────────────────────────────────────────────────────────────
            SectionTitle(
              title: "Video Gallery",
              onViewAllPressed: () {
                AppRoutes.instance.go("/video_gallery_screen");
              },
            ),
            const VideoGallery(),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────
            // 8. Citizen Complaint Call to Action
            // ─────────────────────────────────────────────────────────────
            const ComplaintForm(),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────
            // 9. Map & Location Section (Live API)
            // ─────────────────────────────────────────────────────────────
            const MapSection(),

            const SizedBox(height: 20),

            // ─────────────────────────────────────────────────────────────
            // 10. Footer Section (Live API)
            // ─────────────────────────────────────────────────────────────
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultBanner() {
    return Container(
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.instance.primaryGreen,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_balance, color: Colors.white, size: 48),
            SizedBox(height: 8),
            Text(
              "Barrister Kayser Kamal",
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              "Deputy Speaker, 13th Parliament of Bangladesh",
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
