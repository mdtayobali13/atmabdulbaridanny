import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';

class BiographyScreen extends StatelessWidget {
  const BiographyScreen({super.key});

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
              padding: const EdgeInsets.only(top: 32.0, bottom: 24.0, left: 16.0, right: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Biography",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Biography, experiences, and important life chapters are presented here in detail.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatBox("Today Visitor", "5"),
                      const SizedBox(width: 16),
                      _buildStatBox("Total Visitor", "192"),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Main Content List
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  _buildBioCard(
                    title: "The Honorable Society of Lincoln's Inn",
                    text:
                        "Barrister Kayser Kamal obtained his 'Barrister at Law' degree from the famous The Honourable Society of Lincoln's Inn, London. Earlier, he obtained his LLB from the University of Wolverhampton, UK.",
                    imageUrl: "https://picsum.photos/seed/lincoln/400/250",
                  ),
                  _buildBioCard(
                    title: "Dhaka University",
                    text:
                        "He completed his Bachelor's and Master's degrees from the prestigious University of Dhaka. During his time at the university, he was actively involved in various student and political activities, displaying leadership qualities early on. The academic environment helped shape his legal and political career significantly.",
                    imageUrl: "https://picsum.photos/seed/dhakauni/400/250",
                  ),
                  _buildBioCard(
                    title: "Netrokona Govt. College",
                    text:
                        "He completed his higher secondary education from Netrokona Government College. The institution played a crucial role in his early education and local political involvement, helping him build a strong connection with the people of Netrokona.",
                    imageUrl: "https://picsum.photos/seed/netrokona/400/250",
                  ),
                  _buildBioCard(
                    title: "Kalmakandha Govt. Pilot High School",
                    text:
                        "Barrister Kayser Kamal spent his early school days at Kalmakandha Government Pilot High School. It was here that he laid the foundation of his education before moving on to higher studies in Dhaka and eventually the UK.",
                    imageUrl: "https://picsum.photos/seed/kalmakandha/400/250",
                  ),
                ],
              ),
            ),

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

  Widget _buildBioCard({required String title, required String text, required String imageUrl}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 12.0),
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF0B3D2E), // primaryGreen
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(0),
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => const SizedBox(height: 200, child: Icon(Icons.image, size: 50)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
