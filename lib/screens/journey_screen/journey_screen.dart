import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';

class JourneyScreen extends StatelessWidget {
  const JourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;

    final journeys = [
      {
        "title": "Barrister Kayser Kamal, MP, Deputy Speaker, Netrokona-1 (Kalmakanda-Durgapur)",
        "date": "06-Dec 1991",
        "year": "1991",
        "desc": "efwe",
        "color": const Color(0xFF713c54), // Matches the burgundy color in the screenshot
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
                    "Journey",
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
                      _buildStatBox("Total Visitor", "57"),
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
                itemCount: journeys.length,
                itemBuilder: (context, index) {
                  final data = journeys[index];
                  return AnimatedTimelineItem(
                    index: index,
                    title: data['title'] as String,
                    date: data['date'] as String,
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
  final String date;
  final String year;
  final String desc;
  final Color color;

  const AnimatedTimelineItem({
    super.key,
    required this.index,
    required this.title,
    required this.date,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
          const SizedBox(height: 8),
          Text(
            widget.date,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Text(
            widget.year,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(widget.desc, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }
}
