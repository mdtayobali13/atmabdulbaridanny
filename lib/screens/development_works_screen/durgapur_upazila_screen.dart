import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';
import 'package:flutter_riverpod_template/services/repository/home_repository.dart';

class DurgapurUpazilaScreen extends ConsumerStatefulWidget {
  const DurgapurUpazilaScreen({super.key});

  @override
  ConsumerState<DurgapurUpazilaScreen> createState() => _DurgapurUpazilaScreenState();
}

class _DurgapurUpazilaScreenState extends ConsumerState<DurgapurUpazilaScreen> {
  Map<String, dynamic>? _visitStats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await HomeRepository.instance.recordVisit('/development-work-durgapur');
    if (mounted && stats != null) {
      setState(() => _visitStats = stats);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final devWorkAsync = ref.watch(developmentWorkContentProvider);

    final todayVisits = _visitStats?['today_visits']?.toString() ?? '1';
    final totalVisits = _visitStats?['total_visits']?.toString() ?? '26';

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Header Banner with Stats
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.only(top: 36.0, bottom: 20.0, left: 16.0, right: 16.0),
              child: Column(
                children: [
                  const Text(
                    "Durgapur Upazila",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Development works, infrastructure projects, and public welfare initiatives in Durgapur.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatBox("Today Visitor", todayVisits),
                      const SizedBox(width: 16),
                      _buildStatBox("Total Visitor", totalVisits),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Main Content List
            devWorkAsync.when(
              data: (items) {
                // Filter items related to Durgapur if title mentions it, otherwise show all development works
                final list = items.where((e) =>
                    e.localizedTitle(false).toLowerCase().contains('durgapur') ||
                    e.localizedContent(false).toLowerCase().contains('durgapur')).toList();

                final displayList = list.isNotEmpty ? list : items;

                if (displayList.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Center(child: Text("No development works listed yet")),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: displayList.map((item) {
                      return _buildContentCard(
                        title: item.localizedTitle(false),
                        text: item.localizedContent(false).replaceAll(RegExp(r'<[^>]*>'), '').trim(),
                        imageUrl: item.fullImageUrl,
                      );
                    }).toList(),
                  ),
                );
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Center(child: Text("Failed to load: $err")),
              ),
            ),

            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 2),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildContentCard({required String title, required String text, required String imageUrl}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 6, spreadRadius: 1),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
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
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  text,
                  style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
