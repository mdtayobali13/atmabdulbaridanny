import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';

class NewsDetailScreen extends StatelessWidget {
  final String title;
  final String time;
  final String imageUrl;
  final String description;
  final String sourceScreenName;

  const NewsDetailScreen({
    super.key,
    required this.title,
    required this.time,
    required this.imageUrl,
    this.description = "No detailed description provided.",
    this.sourceScreenName = "News Details",
  });

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;

    final displayDescription = description == "No detailed description provided."
        ? "Barrister Kayser Kamal said, you have to advise me before I make a mistake. So that I can't do any corruption. I will not do corruption myself, nor will I let anyone do it.\n\n"
              "He made these remarks during a discussion where he distributed various items among the people of his constituency. He emphasized the need for honest leadership and transparent governance.\n\n"
              "Kayser Kamal mentioned that he is acting as a servant of the people. No irregularity or corruption will be tolerated in any development project. The laws will apply equally to everyone, regardless of their political affiliation."
        : description;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        scrolledUnderElevation: 0, // Prevents color change on scroll in Material 3
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          sourceScreenName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Green Banner
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.3),
                  ),
                ],
              ),
            ),

            // Content Body
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title inside content
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Date
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(time, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) =>
                          const SizedBox(height: 200, child: Icon(Icons.error, size: 50)),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(displayDescription, style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87)),
                  const SizedBox(height: 40), // Bottom padding
                ],
              ),
            ),

            // Footer Section
            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
