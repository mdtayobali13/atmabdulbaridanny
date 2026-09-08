import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';

class HistoryOfLifeScreen extends StatelessWidget {
  const HistoryOfLifeScreen({super.key});

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
                    "History of Life and Struggle",
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Important chapters of life and struggle...",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatBox("Today Visitor", "8"),
                      const SizedBox(width: 16),
                      _buildStatBox("Total Visitor", "162"),
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
                    title: "Beginning of legal career in the Supreme Court",
                    text:
                        "After returning from the UK, he was enrolled as an advocate of the Supreme Court of Bangladesh. In a very short time, he became known as an accomplished litigator and participated in the management of important constitutional and criminal cases with senior lawyers.",
                    imageUrl: "https://picsum.photos/seed/legalcareer/400/250",
                  ),
                  _buildBioCard(
                    title: "Higher education and barrister-at-law qualification (United Kingdom)",
                    text:
                        "Barrister Kayser Kamal obtained his 'Barrister-at-Law' degree from the famous The Honourable Society of Lincoln's Inn, London. Earlier, he completed his LLB from the University of Wolverhampton, UK and his Masters from the University of Dhaka. This was the foundation of his professional life.",
                    imageUrl: "https://picsum.photos/seed/highereducation/400/250",
                  ),
                  _buildBioCard(
                    title: "Inclusion in the BNP Central Committee",
                    text:
                        "Due to his talent and loyalty to the party, he was appointed as the Legal Affairs Secretary in the Central Committee of the Bangladesh Nationalist Party (BNP). He became important in national politics as a key member of the legal panel of the party's Chairperson Begum Khaleda Zia and Acting Chairman Tarique Rahman.",
                    imageUrl: "https://picsum.photos/seed/bnpcommittee/400/250",
                  ),
                  _buildBioCard(
                    title: "Elected Secretary General of Nationalist Lawyers Forum",
                    text:
                        "He was elected as the Secretary General of the Bangladesh Nationalist Lawyers Forum in 2019 and the subsequent reconstituted committees. He played a central role in uniting thousands of nationalist lawyers spread across the country and building a movement for the establishment of legal good governance.",
                    imageUrl: "https://picsum.photos/seed/kayserportrait/400/400",
                    isPortrait: true,
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

  Widget _buildBioCard({required String title, required String text, required String imageUrl, bool isPortrait = false}) {
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
              height: isPortrait ? 300 : 200,
              width: double.infinity,
              fit: isPortrait ? BoxFit.contain : BoxFit.cover,
              placeholder: (context, url) => SizedBox(height: isPortrait ? 300 : 200, child: const Center(child: CircularProgressIndicator())),
              errorWidget: (context, url, error) => SizedBox(height: isPortrait ? 300 : 200, child: const Icon(Icons.image, size: 50)),
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
