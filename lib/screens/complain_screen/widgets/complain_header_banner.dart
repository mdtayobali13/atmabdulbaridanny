import 'package:flutter/material.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';

class ComplainHeaderBanner extends StatelessWidget {
  final Color primaryGreen;
  final AppTranslations tr;
  final Map<String, dynamic>? visitStats;
  final bool isBangla;

  const ComplainHeaderBanner({
    super.key,
    required this.primaryGreen,
    required this.tr,
    required this.visitStats,
    required this.isBangla,
  });

  @override
  Widget build(BuildContext context) {
    final todayVisits = (visitStats?['today_visits']?.toString() ?? '1').toBanglaDigits(isBangla);
    final totalVisits = (visitStats?['total_visits']?.toString() ?? '288').toBanglaDigits(isBangla);

    return Container(
      width: double.infinity,
      color: primaryGreen,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  tr.complainBannerTitle,
                  style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Builder(
                  builder: (scaffoldContext) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () {
                      Scaffold.of(scaffoldContext).openDrawer();
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            tr.complainBannerSubtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.4),
          ),
          const SizedBox(height: 24),
          // Visitor Stats
          Container(
            width: 250,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatItem(tr.todayVisitor, todayVisits),
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.white30,
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                ),
                _buildStatItem(tr.totalVisitor, totalVisits),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
