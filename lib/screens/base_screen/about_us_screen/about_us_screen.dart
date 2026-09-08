import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Banner with Stats
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0, right: 16.0),
              child: Column(
                children: [
                  const Text(
                    "About Me",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Personal profile, experience, and important information are presented here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatBox("Today Visitor", "7"),
                      const SizedBox(width: 16),
                      _buildStatBox("Total Visitor", "221"),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Main Content Card
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 2)],
                ),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About Me",
                      style: TextStyle(color: primaryGreen, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: 'https://picsum.photos/seed/kayserkamal/300/350', // Placeholder
                          height: 200,
                          width: 160,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.person, size: 100),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Barrister Kayser Kamal is a distinguished Bangladeshi politician and Senior Advocate of the Supreme Court, currently serving as the Deputy Speaker of the 13th Parliament of Bangladesh. Representing the Netrokona-1 constituency, he brings extensive legal and governmental experience to his leadership, having previously served as the State Minister for the Ministry of Land. Born in Netrokona in 1972, he earned his Bachelor's and Master's degrees from the University of Dhaka before pursuing legal studies in the United Kingdom, where he obtained his LLB (Honours) and was called to the Bar by the Honourable Society of Lincoln's Inn in 2005. Unanimously elected as Deputy Speaker in March 2026, Barrister Kamal remains dedicated to fostering inclusive participation, ensuring transparent governance, and upholding impartial leadership within the nation's central democratic forum.",
                      style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 3. Custom Footer
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
