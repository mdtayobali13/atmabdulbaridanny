import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/home_screen/widgets/custom_footer.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class NewsDetailScreen extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final isBangla = ref.watch(isBanglaProvider);

    final displayDescription = (description == "No detailed description provided." || description.isEmpty)
        ? (isBangla
            ? "জনাব এ টি এম আব্দুল বারী ড্যানী বলেন, সততা ও নিষ্ঠার সাথে জনগণের সেবায় কাজ করে যেতে হবে।\n\n"
              "তিনি বিআইডব্লিউটিসি-এর কার্যক্রমকে আরও গতিশীল, স্বচ্ছ ও আধুনিক করার দৃঢ় প্রত্যয় ব্যক্ত করেন।"
            : "Mr. ATM Abdul Bari Danny stated that everyone must work with dedication and integrity to serve the people.\n\n"
              "He affirmed his commitment to making BIWTC operations more dynamic, transparent, and modernized.")
        : description;

    final displaySource = sourceScreenName == "News Details"
        ? (isBangla ? "সংবাদের বিস্তারিত" : "News Details")
        : sourceScreenName;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryGreen,
        scrolledUnderElevation: 0, // Prevents color change on scroll in Material 3
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        title: Text(
          displaySource,
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
