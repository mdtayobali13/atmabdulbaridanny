import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';

class LifeHistoryScreen extends StatelessWidget {
  const LifeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;

    final List<Map<String, String>> records = [
      {
        "title": "Supreme Court Lawyers' Rally",
        "description":
            "Barrister Kayser Kamal participated in the lawyers' rally at the Supreme Court. He strongly condemned the recent actions and demanded justice for the oppressed. The lawyers' community united under his leadership to protest against the unjust laws.",
        "image": "https://picsum.photos/seed/lh1/600/400",
      },
      {
        "title": "BNP Law Affairs Secretary",
        "description":
            "As the Law Affairs Secretary of BNP, Barrister Kayser Kamal has been working tirelessly to provide legal support to the party members. He has organized several meetings to discuss the legal strategies for the upcoming elections.",
        "image": "https://picsum.photos/seed/lh2/600/400",
      },
      {
        "title": "BNP National Executive Committee",
        "description":
            "Being a prominent member of the BNP National Executive Committee, he has played a crucial role in shaping the party's policies. He has always advocated for the rights of the common people and has been a strong voice against corruption.",
        "image": "https://picsum.photos/seed/lh3/600/400",
      },
      {
        "title": "Participation in Central Committee",
        "description":
            "He was recently inducted into the central committee where he emphasized the need for unity among the party workers. His speeches have always been inspiring and have motivated the youth to join politics.",
        "image": "https://picsum.photos/seed/lh4/600/400",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Life & Success Records",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: CachedNetworkImage(
                    imageUrl: record["image"]!,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record["title"]!,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryGreen),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        record["description"]!,
                        style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
