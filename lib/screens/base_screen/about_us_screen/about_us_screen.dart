import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:atmabdulbaridanny/constant/app_asserts_image_path.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/home_screen/widgets/custom_footer.dart';
import 'package:atmabdulbaridanny/services/providers/api_providers.dart';
import 'package:atmabdulbaridanny/services/repository/home_repository.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class AboutUsScreen extends ConsumerStatefulWidget {
  const AboutUsScreen({super.key});

  @override
  ConsumerState<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends ConsumerState<AboutUsScreen> {
  Map<String, dynamic>? _visitStats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await HomeRepository.instance.recordVisit('about-me');
    if (mounted && stats != null) {
      setState(() => _visitStats = stats);
    }
  }

  String _parseHtmlToPlainText(String html) {
    if (html.isEmpty) return '';
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final aboutMeAsync = ref.watch(aboutMeProvider);
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    final todayVisits = (_visitStats?['today_visits']?.toString() ?? '4').toBanglaDigits(isBangla);
    final totalVisits = (_visitStats?['total_visits']?.toString() ?? '246').toBanglaDigits(isBangla);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(aboutMeProvider);
          await _loadStats();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // 1. Header Banner with Stats
              Container(
                width: double.infinity,
                color: primaryGreen,
                padding: const EdgeInsets.only(top: 36.0, bottom: 20.0, left: 16.0, right: 16.0),
                child: Column(
                  children: [
                    Text(
                      tr.aboutMeTitle,
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tr.aboutMeSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 16),
                    // Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatBox(tr.todayVisitor, todayVisits),
                        const SizedBox(width: 16),
                        _buildStatBox(tr.totalVisitor, totalVisits),
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Main Content Card
              aboutMeAsync.when(
                data: (aboutMe) {
                  final rawContent = aboutMe?.localizedContent(isBangla) ?? '';
                  final cleanText = _parseHtmlToPlainText(rawContent);
                  final imgUrl = aboutMe?.fullImageUrl ?? '';

                  const fallbackEn =
                      "Mr. A T M Abdul Bari Danny joined as the Chairman of Bangladesh Inland Water Transport Corporation (BIWTC) on 26 July 2026. He completed his Honours in Public Administration in 1992 and Master's in 1994 from the University of Dhaka. Currently, he is serving as the Joint Secretary of Religious Affairs of the BNP Central Executive Committee and Member Secretary of the Dhaka University Alumni Association.";

                  const fallbackBn =
                      "জনাব এ টি এম আব্দুল বারী ড্যানী ২৬ জুলাই ২০২৬ খ্রি. বাংলাদেশ অভ্যন্তরীণ নৌপরিবহন করপোরেশন (বিআইডব্লিউটিসি)-এর চেয়ারম্যান হিসেবে যোগদান করেন। তিনি ১৯৯২ সালে ঢাকা বিশ্ববিদ্যালয় থেকে পাবলিক এডমিনিস্ট্রেশনে অনার্স ও ১৯৯৪ সালে একই বিষয়ে মাস্টার্স ডিগ্রি অর্জন করেন। বর্তমানে তিনি ঢাকা বিশ্ববিদ্যালয় এ্যালামনাই এসোসিয়েশনের সদস্য সচিব এবং বাংলাদেশ জাতীয়তাবাদী দল বিএনপি’র কেন্দ্রীয় নির্বাহী কমিটির সহ-ধর্ম বিষয়ক সম্পাদক।";

                  final displayText = cleanText.isNotEmpty ? cleanText : (isBangla ? fallbackBn : fallbackEn);

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withValues(alpha: 0.15), blurRadius: 12, spreadRadius: 2),
                        ],
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final isWide = constraints.maxWidth > 650;
                          if (isWide) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 240,
                                  child: _buildProfileImage(imgUrl),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: _buildProfileDetails(
                                    primaryGreen: primaryGreen,
                                    isBangla: isBangla,
                                    text: displayText,
                                  ),
                                ),
                              ],
                            );
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfileImage(imgUrl),
                              const SizedBox(height: 20),
                              _buildProfileDetails(
                                primaryGreen: primaryGreen,
                                isBangla: isBangla,
                                text: displayText,
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 60),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Center(child: Text("Failed to load about me: $err")),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Custom Footer
              const CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(String imgUrl) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 320),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: imgUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: imgUrl,
                  height: 300,
                  fit: BoxFit.contain,
                  placeholder: (context, url) => const SizedBox(
                    height: 300,
                    width: 230,
                    child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    AppAssertsImagePath.instance.atmAdminLogo,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                )
              : Image.asset(
                  AppAssertsImagePath.instance.atmAdminLogo,
                  height: 300,
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
  Widget _buildProfileDetails({
    required Color primaryGreen,
    required bool isBangla,
    required String text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isBangla ? "এ টি এম আব্দুল বারী ড্যানী" : "ATM Abdul Bari Danny",
          style: TextStyle(color: primaryGreen, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          isBangla ? "২৪ কাজী নজরুল ইসলাম এভিনিউ, ঢাকা-১০০০" : "24 Kazi Nazrul Islam Avenue, Dhaka-1000",
          style: TextStyle(
            color: AppColors.instance.primaryGreen.withValues(alpha: 0.85),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.instance.goldenColor.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.instance.goldenColor.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Text(
            isBangla ? "চেয়ারম্যান, বিআইডব্লিউটিসি" : "Chairman, BIWTC",
            style: TextStyle(
              color: AppColors.instance.primaryGreen,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.phone, size: 14, color: Colors.black54),
            const SizedBox(width: 4),
            Text(
              isBangla ? "০২২২৩৩৬০৬৭১ (অফিস)" : "02223360671 (Office)",
              style: const TextStyle(fontSize: 12.5, color: Colors.black87),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.email, size: 14, color: Colors.black54),
            const SizedBox(width: 4),
            const Flexible(
              child: Text(
                "chairman@biwtc.gov.bd",
                style: TextStyle(fontSize: 12, color: Colors.black87),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14.5,
            color: Colors.black87,
            height: 1.7,
            letterSpacing: 0.2,
          ),
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildStatBox(String title, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
