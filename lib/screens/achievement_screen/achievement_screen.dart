import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/custom_footer.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';

class AchievementScreen extends ConsumerWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    final achievements = [
      {
        "title": isBangla ? "ডেপুটি স্পিকার" : "Deputy Speaker",
        "year": "2026".toBanglaDigits(isBangla),
        "desc": isBangla
            ? "ব্যারিস্টার কায়সার কামাল ত্রয়োদশ জাতীয় সংসদের ডেপুটি স্পিকার নির্বাচিত হয়েছেন। সংসদ অধিবেশনে নাটোরের সংসদ সদস্য রুহুল কুদ্দুস তালুকদার দুলু কায়সার কামালের নাম প্রস্তাব করেন।"
            : "Barrister Kayser Kamal has been elected as the Deputy Speaker of the 13th National Parliament. Natore MP Ruhul Quddus Talukder Dulu proposed Kayser Kamal's name in the parliament session.",
        "color": Colors.blueAccent,
      },
      {
        "title": isBangla ? "ভূমি প্রতিমন্ত্রী" : "State Minister For Land",
        "year": "2026".toBanglaDigits(isBangla),
        "desc": isBangla
            ? "নেত্রকোনা-১ (কলমাকান্দা-দুর্গাপুর) আসনের সংসদ সদস্য ব্যারিস্টার কায়সার কামাল ভূমি প্রতিমন্ত্রী হিসেবে মন্ত্রিসভায় অন্তর্ভুক্ত হয়েছেন।"
            : "Barrister Kayser Kamal, Member of Parliament for Netrokona-1 (Kalmakanda-Durgapur) constituency, has been inducted into the cabinet as State Minister for Land.",
        "color": Colors.teal,
      },
      {
        "title": isBangla ? "ত্রয়োদশ জাতীয় সংসদ" : "13th Parliament",
        "year": "2026".toBanglaDigits(isBangla),
        "desc": isBangla
            ? "ত্রয়োদশ জাতীয় সংসদ নির্বাচনে তিনি ১,০০,০০০ ভোট পেয়ে নির্বাচিত হন, যেখানে তাঁর নিকটতম প্রতিদ্বন্দ্বী পান ৮১,০০০ ভোট।"
            : "In the 13th National Parliament election, he received 100,000 votes, while his nearest rival received 81,000 votes. As a result, he won the 13th National Parliament election.",
        "color": Colors.purpleAccent,
      },
      {
        "title": isBangla ? "জাতীয়তাবাদী আইনজীবী ফোরামের মহাসচিব নির্বাচিত" : "Elected Secretary General of Nationalist Lawyers Forum",
        "year": "2019".toBanglaDigits(isBangla),
        "desc": isBangla
            ? "২০১৯ সালে এবং পরবর্তী পুনর্গঠিত কমিটিতে তিনি বাংলাদেশ জাতীয়তাবাদী আইনজীবী ফোরামের মহাসচিব নির্বাচিত হন। তিনি হাজার হাজার আইনজীবীকে ঐক্যবদ্ধ করতে কেন্দ্রীয় ভূমিকা পালন করেন।"
            : "In 2019 and the subsequent reconstituted committee, he was elected Secretary General of the Bangladesh Nationalist Lawyers Forum. He played a central role in uniting thousands of nationalist lawyers.",
        "color": Colors.deepPurpleAccent,
      },
      {
        "title": isBangla ? "বিএনপি কেন্দ্রীয় আইন বিষয়ক সম্পাদক" : "BNP Legal Affairs Secretary",
        "year": "2016".toBanglaDigits(isBangla),
        "desc": isBangla
            ? "তিনি ২০১৬ সাল থেকে কেন্দ্রীয় বিএনপির আইন বিষয়ক সম্পাদক হিসেবে দায়িত্ব পালন করছেন।"
            : "He has been serving as the Central Legal Affairs Secretary of the Central BNP since 2016.",
        "color": Colors.lightBlue,
      },
      {
        "title": isBangla ? "বিএনপি জাতীয় নির্বাহী কমিটি" : "BNP Central Committee",
        "year": "2009".toBanglaDigits(isBangla),
        "desc": isBangla
            ? "২০০৯ সালে তিনি বিএনপির জাতীয় নির্বাহী কমিটির সদস্য হন।"
            : "In 2009, he became an executive member of the BNP Central Committee.",
        "color": Colors.blue[700]!,
      },
      {
        "title": isBangla ? "ঢাকা বিশ্ববিদ্যালয়ের সিনেট সদস্য" : "Senate Member of Dhaka University",
        "year": "1996".toBanglaDigits(isBangla),
        "desc": isBangla
            ? "১৯৯৬ সালে তিনি ঢাকা বিশ্ববিদ্যালয়ের সিনেট সদস্য নির্বাচিত হন।"
            : "He was elected as a member of the Senate of Dhaka University in 1996.",
        "color": Colors.green[600]!,
      },
      {
        "title": isBangla ? "কেন্দ্রীয় ছাত্রদল" : "Central Chhatra Dal",
        "year": "1996".toBanglaDigits(isBangla),
        "desc": isBangla
            ? "১৯৯৬ সালে তিনি কেন্দ্রীয় ছাত্রদলের নির্বাহী সদস্য হন।"
            : "In 1996, he became an executive member of the Central Chhatra Dal.",
        "color": Colors.grey[400]!,
      },
      {
        "title": isBangla ? "ছাত্র রাজনীতি" : "Student Politics",
        "year": "1988".toBanglaDigits(isBangla),
        "desc": isBangla
            ? "১৯৮৮ সালে তিনি ছাত্র রাজনীতিতে প্রবেশ করেন।"
            : "He entered student politics in 1988.",
        "color": Colors.grey[600]!,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Banner
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
              child: Column(
                children: [
                  Text(
                    tr.achievementTitle,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tr.achievementSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatBox(tr.todayVisitor, "2".toBanglaDigits(isBangla)),
                      const SizedBox(width: 16),
                      _buildStatBox(tr.totalVisitor, "103".toBanglaDigits(isBangla)),
                    ],
                  ),
                ],
              ),
            ),

            // Timeline Content
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final data = achievements[index];
                  return AnimatedTimelineItem(
                    index: index,
                    title: data['title'] as String,
                    year: data['year'] as String,
                    desc: data['desc'] as String,
                    color: data['color'] as Color,
                  );
                },
              ),
            ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String title, String count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
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

class AnimatedTimelineItem extends StatefulWidget {
  final int index;
  final String title;
  final String year;
  final String desc;
  final Color color;

  const AnimatedTimelineItem({
    super.key,
    required this.index,
    required this.title,
    required this.year,
    required this.desc,
    required this.color,
  });

  @override
  State<AnimatedTimelineItem> createState() => _AnimatedTimelineItemState();
}

class _AnimatedTimelineItemState extends State<AnimatedTimelineItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));

    // Determine slide direction based on alternating sides
    final isLeft = widget.index % 2 == 0;
    // Increased offset to 1.5 so it comes from completely outside
    final beginOffset = isLeft ? const Offset(-1.5, 0) : const Offset(1.5, 0);

    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Stagger animation based on index
    Future.delayed(Duration(milliseconds: 150 * widget.index), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLeft = widget.index % 2 == 0;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Left Card
            Expanded(
              child: isLeft ? SlideTransition(position: _slideAnimation, child: _buildCard()) : const SizedBox.shrink(),
            ),
            // Center Line and Dot
            SizedBox(
              width: 30,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(width: 2, color: Colors.grey[300]),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ],
              ),
            ),
            // Right Card
            Expanded(
              child: !isLeft
                  ? SlideTransition(position: _slideAnimation, child: _buildCard())
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: widget.color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  widget.year,
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.year,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(widget.desc, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}
