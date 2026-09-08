import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/news_item.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;

    final List<Map<String, String>> newsList = [
      {
        "title": "Discussion meeting protesting human rights...",
        "time": "1 hours ago",
        "imageUrl": "https://picsum.photos/seed/n1/300/200",
      },
      {
        "title": "Prime Minister takes oath for a new term",
        "time": "2 hours ago",
        "imageUrl": "https://picsum.photos/seed/n2/300/200",
      },
      {
        "title": "Exchange of views with lawyers",
        "time": "5 hours ago",
        "imageUrl": "https://picsum.photos/seed/n3/300/200",
      },
      {
        "title": "Exchange of views with youth",
        "time": "1 day ago",
        "imageUrl": "https://picsum.photos/seed/n4/300/200",
      },
      {
        "title": "Inauguration of new bridge",
        "time": "2 days ago",
        "imageUrl": "https://picsum.photos/seed/n5/300/200",
      },
      {
        "title": "New educational policy announced",
        "time": "3 days ago",
        "imageUrl": "https://picsum.photos/seed/n6/300/200",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Green Banner
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: const Column(
                children: [
                  Text(
                    "Latest News & Updates",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            // Grid content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: newsList.length,
                itemBuilder: (context, index) {
                  final news = newsList[index];
                  return NewsItem(
                    title: news["title"]!,
                    time: news["time"]!,
                    imageUrl: news["imageUrl"]!,
                    sourceScreenName: "Latest News & Updates",
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
}
