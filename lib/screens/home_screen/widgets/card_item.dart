import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:atmabdulbaridanny/screens/news_detail_screen/news_detail_screen.dart';

class CardItem extends StatelessWidget {
  final String title;
  final String btnText;
  final String imageUrl;
  final String time;
  final String description;
  final String sourceScreenName;

  const CardItem({
    super.key, 
    required this.title, 
    required this.btnText, 
    required this.imageUrl,
    this.time = '',
    this.description = '',
    this.sourceScreenName = "News Details",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(
            builder: (context) => NewsDetailScreen(
              title: title,
              time: time,
              imageUrl: imageUrl,
              description: description,
              sourceScreenName: sourceScreenName,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        height: 215,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.2), blurRadius: 4, spreadRadius: 1)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 100,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Text(
                btnText,
                style: const TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
