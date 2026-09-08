import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/card_item.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';

class BlogScreen extends StatelessWidget {
  const BlogScreen({super.key});

  @override
  Widget build(BuildContext context) {
  

    final List<Map<String, String>> blogs = [
      {
        "title": "Construction of concrete culvert over the river in Hatirjhil style...",
        "imageUrl": "https://picsum.photos/seed/b1/300/200",
      },
      {
        "title": "Kayser Kamal stands beside Ahona, born with a hole in the heart",
        "imageUrl": "https://picsum.photos/seed/b2/300/200",
      },
      {
        "title": "No representative before, now a capable and visionary leader...",
        "imageUrl": "https://picsum.photos/seed/b3/300/200",
      },
      {
        "title": "Discussion meeting protesting human rights violations...",
        "imageUrl": "https://picsum.photos/seed/b4/300/200",
      },
      {"title": "Dreaming of a new day with the youth...", "imageUrl": "https://picsum.photos/seed/b5/300/200"},
      {"title": "Exchange of views meeting with lawyers...", "imageUrl": "https://picsum.photos/seed/b6/300/200"},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Grid content
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 12,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: blogs.map((blog) {
                  return FractionallySizedBox(
                    widthFactor: 0.47, // Roughly half screen width minus spacing
                    child: CardItem(
                      title: blog["title"]!,
                      btnText: "Read More",
                      imageUrl: blog["imageUrl"]!,
                      sourceScreenName: "Blog Articles",
                    ),
                  );
                }).toList(),
              ),
            ),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
