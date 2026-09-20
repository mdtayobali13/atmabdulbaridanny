import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/models/content_models.dart';
import 'package:barristerkayserkamal/routes/app_routes.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/appointment_form.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/card_item.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/complaint_form.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/custom_footer.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/grid_list.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/horizontal_list.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/map_section.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/news_item.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/photo_gallery.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/profile_identity_card.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/section_title.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/video_gallery.dart';
import 'package:barristerkayserkamal/screens/life_history_screen/life_history_screen.dart';
import 'package:barristerkayserkamal/screens/print_media_screen/print_media_screen.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';
import 'package:barristerkayserkamal/services/repository/home_repository.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';

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
    final isBangla = ref.watch(isBanglaProvider);
    final slidersAsync = ref.watch(sliderListProvider);
    final lifeAsync = ref.watch(lifeStruggleListProvider);
    final newsAsync = ref.watch(newsListProvider);
    final blogsAsync = ref.watch(blogListProvider);

    final websiteSettingAsync = ref.watch(websiteSettingProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ─────────────────────────────────────────────────────────────
            // 1. Banner Slider / Hero Banner (Live API)
            // ─────────────────────────────────────────────────────────────
            slidersAsync.when(
              data: (sliders) {
                if (sliders.isNotEmpty) {
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
                }
                return _buildApiBanner(websiteSettingAsync);
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
              error: (err, stack) => _buildApiBanner(websiteSettingAsync),
            ),

            const SizedBox(height: 12),

            // ─────────────────────────────────────────────────────────────
            // Official Profile Identity Card
            // ─────────────────────────────────────────────────────────────
            const ProfileIdentityCard(),

            const SizedBox(height: 16),

            // ─────────────────────────────────────────────────────────────
            // 2. Life & Success Records (Live API)
            // ─────────────────────────────────────────────────────────────
            SectionTitle(
              title: isBangla ? "জীবন ও সফলতার ইতিহাস" : "Life & Success Records",
              buttonText: isBangla ? "সব দেখুন" : "View All",
              onViewAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const LifeHistoryScreen()));
              },
            ),
            lifeAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text(isBangla ? "কোন তথ্য পাওয়া যায়নি" : "No life history records available")),
                  );
                }
                return HorizontalList(
                  items: items.map((item) {
                    final time = item.createdAt != null && item.createdAt!.length >= 10
                        ? item.createdAt!.substring(0, 10)
                        : '';
                    final desc = item.localizedContent(isBangla).replaceAll(RegExp(r'<[^>]*>'), '').trim();
                    return CardItem(
                      title: item.localizedTitle(isBangla),
                      btnText: isBangla ? "বিস্তারিত পড়ুন" : "Read More",
                      imageUrl: item.fullImageUrl,
                      time: time,
                      description: desc,
                      sourceScreenName: isBangla ? "জীবন ও সফলতার ইতিহাস" : "Life & Success Records",
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
              title: isBangla ? "সংবাদ ও কার্যক্রম" : "News & Activities",
              buttonText: isBangla ? "সব দেখুন" : "View All",
              onViewAllPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PrintMediaScreen()));
              },
            ),
            newsAsync.when(
              data: (items) {
                if (items.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text(isBangla ? "কোন সংবাদ পাওয়া যায়নি" : "No news available")),
                  );
                }
                final displayItems = items.take(4).toList();
                return GridList(
                  items: displayItems.map((news) {
                    return NewsItem(
                      title: news.localizedTitle(isBangla),
                      time: news.createdAt != null && news.createdAt!.length >= 10
                          ? news.createdAt!.substring(0, 10)
                          : '',
                      imageUrl: news.fullImageUrl,
                      sourceScreenName: isBangla ? "সংবাদ ও কার্যক্রম" : "News & Activities",
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
              title: isBangla ? "ব্লগ" : "Blog",
              buttonText: isBangla ? "সব দেখুন" : "View All",
              onViewAllPressed: () {
                AppRoutes.instance.go("/blog_screen");
              },
            ),
            blogsAsync.when(
              data: (blogs) {
                if (blogs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text(isBangla ? "কোন ব্লগ পাওয়া যায়নি" : "No blog articles available")),
                  );
                }
                return HorizontalList(
                  items: blogs.map((blog) {
                    final time = blog.createdAt != null && blog.createdAt!.length >= 10
                        ? blog.createdAt!.substring(0, 10)
                        : '';
                    final desc = blog.localizedContent(isBangla).replaceAll(RegExp(r'<[^>]*>'), '').trim();
                    return CardItem(
                      title: blog.localizedTitle(isBangla),
                      btnText: isBangla ? "বিস্তারিত পড়ুন" : "Read More",
                      imageUrl: blog.fullImageUrl,
                      time: time,
                      description: desc,
                      sourceScreenName: isBangla ? "ব্লগ" : "Blog",
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
              title: isBangla ? "ফটো গ্যালারি" : "Photo Gallery",
              buttonText: isBangla ? "সব দেখুন" : "View All",
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
              title: isBangla ? "ভিডিও গ্যালারি" : "Video Gallery",
              buttonText: isBangla ? "সব দেখুন" : "View All",
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

  Widget _buildApiBanner(AsyncValue<WebsiteSettingModel?> websiteSettingAsync) {
    return websiteSettingAsync.when(
      data: (setting) {
        final bannerUrl = setting?.fullBannerUrl;
        if (bannerUrl != null && bannerUrl.trim().isNotEmpty) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: bannerUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                ),
                errorWidget: (context, url, error) => _buildFallbackBannerCard(setting),
              ),
            ),
          );
        }
        return _buildFallbackBannerCard(setting);
      },
      loading: () => Container(
        height: 180,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => _buildFallbackBannerCard(null),
    );
  }

  Widget _buildFallbackBannerCard(WebsiteSettingModel? setting) {
    final isBangla = ref.watch(isBanglaProvider);
    final title = isBangla
        ? (setting?.titleBn ?? "ব্যারিস্টার কায়সার কামাল")
        : (setting?.titleEn ?? "Barrister Kayser Kamal");

    return Container(
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.instance.primaryGreen,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 6,
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance, color: Colors.white, size: 44),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
