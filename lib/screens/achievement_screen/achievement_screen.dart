import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';

class AchievementScreen extends StatelessWidget {
  const AchievementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;

    final achievements = [
      {
        "title": "Deputy Speaker",
        "year": "2026",
        "desc":
            "Barrister Kayser Kamal has been elected as the Deputy Speaker of the 13th National Parliament. Natore MP Ruhul Quddus Talukder Dulu proposed Kayser Kamal's name in the parliament session.",
        "color": Colors.blueAccent,
      },
      {
        "title": "State Minister For Land",
        "year": "2026",
        "desc":
            "Barrister Kayser Kamal, Member of Parliament for Netrokona-1 (Kalmakanda-Durgapur) constituency, has been inducted into the cabinet as State Minister for Land.",
        "color": Colors.teal,
      },
      {
        "title": "13th Parliament",
        "year": "2026",
        "desc":
            "In the 13th National Parliament election, he received 100,000 votes, while his nearest rival received 81,000 votes. As a result, he won the 13th National Parliament election.",
        "color": Colors.purpleAccent,
      },
      {
        "title": "Elected Secretary General of Nationalist Lawyers Forum",
        "year": "2019",
        "desc":
            "In 2019 and the subsequent reconstituted committee, he was elected Secretary General of the Bangladesh Nationalist Lawyers Forum. He played a central role in uniting thousands of nationalist lawyers.",
        "color": Colors.deepPurpleAccent,
      },
      {
        "title": "BNP",
        "year": "2016",
        "desc": "He has been serving as the Central Legal Affairs Secretary of the Central BNP since 2016.",
        "color": Colors.lightBlue,
      },
      {
        "title": "BNP Central Committee",
        "year": "2009",
        "desc": "In 2009, he became an executive member of the BNP Central Committee.",
        "color": Colors.blue[700],
      },
      {
        "title": "Senate Member of Dhaka University",
        "year": "1996",
        "desc": "He was elected as a member of the Senate of Dhaka University in 1996.",
        "color": Colors.green[600],
      },
      {
        "title": "Central Chhatra Dal",
        "year": "1996",
        "desc": "In 1996, he became an executive member of the Central Chhatra Dal.",
        "color": Colors.grey[400],
      },
      {
        "title": "Student Politics",
        "year": "1988",
        "desc": "He entered student politics in 1988.",
        "color": Colors.grey[600],
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
                  const Text(
                    "Achievement",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Important achievements, timeline highlights, and notable milestones are presented here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatBox("Today Visitor", "2"),
                      const SizedBox(width: 16),
                      _buildStatBox("Total Visitor", "103"),
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
