import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/news_item.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';


class PrintMediaScreen extends StatelessWidget {
  const PrintMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;
    
    // Sample data to mimic the screenshot
    final List<Map<String, String>> newsList = [
      {
        "title": "I will not commit corruption myself, nor will I let anyone do so: Deputy...",
        "time": "26 April 2024",
        "imageUrl": "https://picsum.photos/seed/pm1/300/200"
      },
      {
        "title": "Teachers are not leaders of any party: Deputy Speaker",
        "time": "26 April 2024",
        "imageUrl": "https://picsum.photos/seed/pm2/300/200"
      },
      {
        "title": "Question arises whether to hold elections in the future, Deputy...",
        "time": "26 April 2024",
        "imageUrl": "https://picsum.photos/seed/pm3/300/200"
      },
      {
        "title": "Kayser Kamal arranges clean water for farmers in Haor",
        "time": "26 April 2024",
        "imageUrl": "https://picsum.photos/seed/pm4/300/200"
      },
    ];

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
                    "Print Media",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Browse the latest news, publications, and important media updates here.",
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
                      _buildStatBox("Total Visitor", "113"),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Main Content Grid
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  return NewsItem(
                    title: news["title"]!,
                    time: news["time"]!,
                    imageUrl: news["imageUrl"]!,
                    sourceScreenName: "Print Media",
                  );
                },
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
}
