import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';

class DurgapurUpazilaScreen extends StatelessWidget {
  const DurgapurUpazilaScreen({super.key});

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
                    "Durgapur Upazila",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Detailed information and activities of development work are presented here.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatBox("Today Visitor", "1"),
                      const SizedBox(width: 16),
                      _buildStatBox("Total Visitor", "26"),
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
                  _buildContentCard(
                    title: "Barrister Kayser Kamal, MP, Deputy Speaker, Netrokona-1 (Kalmakanda-Durgapur)",
                    text: "যুক্তরাজ্য থেকে ফিরে তিনি বাংলাদেশ সুপ্রিম কোর্টের আইনজীবী হিসেবে তালিকাভুক্ত হন। অল্পের জন্য হলেও তিনি একজন দক্ষ লিটিগেটর হিসেবে পরিচিতি পান এবং জ্যেষ্ঠ আইনজীবীদের সাথে গুরুত্বপূর্ণ সাংবিধানিক ও ফৌজদারি মামলা পরিচালনায় অংশ নেন।\n\nযুক্তরাজ্য থেকে ফিরে তিনি বাংলাদেশ সুপ্রিম কোর্টের আইনজীবী হিসেবে তালিকাভুক্ত হন। অল্পের জন্য হলেও তিনি একজন দক্ষ লিটিগেটর হিসেবে পরিচিতি পান এবং জ্যেষ্ঠ আইনজীবীদের সাথে গুরুত্বপূর্ণ সাংবিধানিক ও ফৌজদারি মামলা পরিচালনায় অংশ নেন।\n\nযুক্তরাজ্য থেকে ফিরে তিনি বাংলাদেশ সুপ্রিম কোর্টের আইনজীবী হিসেবে তালিকাভুক্ত হন। অল্পের জন্য হলেও তিনি একজন দক্ষ লিটিগেটর হিসেবে পরিচিতি পান এবং জ্যেষ্ঠ আইনজীবীদের সাথে গুরুত্বপূর্ণ সাংবিধানিক ও ফৌজদারি মামলা পরিচালনায় অংশ নেন।\n\nযুক্তরাজ্য থেকে ফিরে তিনি বাংলাদেশ সুপ্রিম কোর্টের আইনজীবী হিসেবে তালিকাভুক্ত হন। অল্পের জন্য হলেও তিনি একজন দক্ষ লিটিগেটর হিসেবে পরিচিতি পান এবং জ্যেষ্ঠ আইনজীবীদের সাথে গুরুত্বপূর্ণ সাংবিধানিক ও ফৌজদারি মামলা পরিচালনায় অংশ নেন।",
                    imageUrl: "https://picsum.photos/seed/durgapur1/400/250",
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

  Widget _buildContentCard({required String title, required String text, required String imageUrl}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 10, spreadRadius: 2)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0, bottom: 12.0),
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
              style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.6),
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
