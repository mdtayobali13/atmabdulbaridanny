import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';
import 'package:flutter_riverpod_template/utils/languages/language_provider.dart';

class LifeHistoryScreen extends ConsumerWidget {
  const LifeHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final lifeAsync = ref.watch(lifeStruggleListProvider);
    final isBangla = ref.watch(isBanglaProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          isBangla ? "জীবন ও সফলতার ইতিহাস" : "Life & Success Records",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: lifeAsync.when(
        data: (records) {
          if (records.isEmpty) {
            return Center(child: Text(isBangla ? "কোন তথ্য পাওয়া যায়নি" : "No records available"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];
              final title = record.localizedTitle(isBangla);
              final description = record.localizedContent(isBangla).replaceAll(RegExp(r'<[^>]*>'), '').trim();
              final imgUrl = record.fullImageUrl;

              return Card(
                color: Colors.white,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (imgUrl.isNotEmpty)
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: CachedNetworkImage(
                          imageUrl: imgUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const SizedBox(height: 200, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                          errorWidget: (context, url, error) =>
                              Container(height: 200, color: Colors.grey[200], child: const Icon(Icons.broken_image)),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Failed to load: $err")),
      ),
    );
  }
}
