import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barristerkayserkamal/constant/app_asserts_image_path.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/custom_footer.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';
import 'package:barristerkayserkamal/services/repository/home_repository.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';

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
                      "Barrister Kayser Kamal is a distinguished Bangladeshi politician and Senior Advocate of the Supreme Court, currently serving as the Deputy Speaker of the 13th Parliament of Bangladesh. Representing the Netrokona-1 constituency, he brings extensive legal and governmental experience to his leadership, having previously served as the State Minister for the Ministry of Land. Born in Netrokona in 1972, he earned his Bachelor's and Master's degrees from the University of Dhaka before pursuing legal studies in the United Kingdom, where he obtained his LLB (Honours) and was called to the Bar by the Honourable Society of Lincoln’s Inn in 2005. Unanimously elected as Deputy Speaker in March 2026, Barrister Kamal remains dedicated to fostering inclusive participation, ensuring transparent governance, and upholding impartial leadership within the nation's central democratic forum.";

                  const fallbackBn =
                      "ব্যারিস্টার কায়সার কামাল একজন বিশিষ্ট বাংলাদেশী রাজনীতিবিদ ও সুপ্রিম কোর্টের সিনিয়র এডভোকেট, বর্তমানে বাংলাদেশের ১৩তম সংসদের ডেপুটি স্পীকার হিসেবে দায়িত্ব পালন করছেন। নেত্রকোণা-১ আসনের প্রতিনিধিত্বকারী তিনি তার বিস্তৃত আইনগত ও সরকারি অভিজ্ঞতা নেতৃত্বে নিয়ে আসেন, পূর্বে ভূমি মন্ত্রণালয়ের প্রতিমন্ত্রী হিসেবে কর্মরত ছিলেন। ১৯৭২ সালে নেত্রকোণায় জন্মগ্রহণ করেন। ঢাকা বিশ্ববিদ্যালয় থেকে স্নাতক ও স্নাতকোত্তর ডিগ্রি অর্জনের পর যুক্তরাজ্যে আইন শিক্ষা সম্পন্ন করেন, যেখানে তিনি এলএলবি (অনার্স) লাভ করেন এবং ২০০৫ সালে দ্য অনারেবল সোসাইটি অব লিঙ্কন’স ইন কর্তৃক বারে অন্তর্ভুক্ত হন। ২০২৬ সালের মার্চে সর্বসম্মতিক্রমে ডেপুটি স্পীকার হিসেবে নির্বাচিত, ব্যারিস্টার কামাল অন্তর্ভুক্তিমূলক অংশগ্রহণ বৃদ্ধি, স্বচ্ছ শাসন নিশ্চিত করা এবং দেশের কেন্দ্রীয় গণতান্ত্রিক সংস্থায় নিরপেক্ষ নেতৃত্ব বজায় রাখার ক্ষেত্রে অঙ্গীকারবদ্ধ রয়েছেন।";

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
                    AppAssertsImagePath.instance.barristerKayserKamal,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                )
              : Image.asset(
                  AppAssertsImagePath.instance.barristerKayserKamal,
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
          isBangla ? "ব্যারিস্টার কায়সার কামাল, এমপি" : "Barrister Kayser Kamal, MP",
          style: TextStyle(color: primaryGreen, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          isBangla ? "নেত্রকোনা-১ (দুর্গাপুর-কলমাকান্দা)" : "Netrokona-1 (Durgapur-Kalmakanda)",
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
            isBangla ? "ডেপুটি স্পিকার, বাংলাদেশ জাতীয় সংসদ" : "Deputy Speaker, Bangladesh Parliament",
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
              isBangla ? "০১৭১৩০৪৬৭৮৩" : "01713046783",
              style: const TextStyle(fontSize: 12.5, color: Colors.black87),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.email, size: 14, color: Colors.black54),
            const SizedBox(width: 4),
            const Flexible(
              child: Text(
                "netrokona.1@parliament.gov.bd",
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
