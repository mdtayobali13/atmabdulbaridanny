import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/models/admin_dashboard_model.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';

class AdminOverviewTab extends ConsumerWidget {
  final bool isBangla;
  final Future<void> Function() onRefresh;

  const AdminOverviewTab({
    super.key,
    required this.isBangla,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(adminDashboardProvider);

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.instance.primaryGreen,
      child: dashboardAsync.when(
        data: (data) => _buildDashboardGrid(data, isBangla),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                isBangla ? "তথ্য লোড করতে ব্যর্থ হয়েছে" : "Failed to load dashboard data",
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: onRefresh,
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(isBangla ? "পুনরায় চেষ্টা করুন" : "Retry"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.instance.primaryGreen,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardGrid(AdminDashboardModel? data, bool isBangla) {
    final items = [
      _StatItem(
        title: isBangla ? "ফটো গ্যালারি" : "Photo Gallery",
        count: data?.photoGallery ?? 0,
        icon: CupertinoIcons.photo,
        color: const Color(0xFF8B5CF6),
      ),
      _StatItem(
        title: isBangla ? "ভিডিও গ্যালারি" : "Video Gallery",
        count: data?.videoGallery ?? 0,
        icon: CupertinoIcons.videocam_fill,
        color: const Color(0xFFEC4899),
      ),
      _StatItem(
        title: isBangla ? "জীবনবৃত্তান্ত" : "Biography",
        count: data?.biography ?? 0,
        icon: CupertinoIcons.text_alignleft,
        color: const Color(0xFF0D9488),
      ),
      _StatItem(
        title: isBangla ? "জীবনের সংগ্রাম" : "Life Struggle",
        count: data?.lifeStruggle ?? 0,
        icon: CupertinoIcons.square_list,
        color: const Color(0xFF3B82F6),
      ),
      _StatItem(
        title: isBangla ? "প্রিন্ট মিডিয়া" : "Print Media",
        count: data?.printMedia ?? 0,
        icon: CupertinoIcons.film,
        color: const Color(0xFF6366F1),
      ),
      _StatItem(
        title: isBangla ? "ইলেকট্রনিক মিডিয়া" : "Electronic Media",
        count: data?.electronicMedia ?? 0,
        icon: CupertinoIcons.tv,
        color: const Color(0xFFEA580C),
      ),
      _StatItem(
        title: isBangla ? "কৃতিত্ব" : "Achievment",
        count: data?.achievementCount ?? 0,
        icon: CupertinoIcons.info_circle,
        color: const Color(0xFF06B6D4),
      ),
      _StatItem(
        title: isBangla ? "ভ্রমণ ও পথচলা" : "Journey",
        count: data?.journeyCount ?? 0,
        icon: CupertinoIcons.info,
        color: const Color(0xFF8B5CF6),
      ),
      _StatItem(
        title: isBangla ? "প্রাচীন নজির" : "Precedents",
        count: data?.precedentsCount ?? 0,
        icon: CupertinoIcons.square_stack_3d_up,
        color: const Color(0xFF3B82F6),
      ),
      _StatItem(
        title: isBangla ? "গবেষণা কর্ম" : "Research",
        count: data?.researchCount ?? 0,
        icon: CupertinoIcons.square_stack_3d_up_fill,
        color: const Color(0xFF2563EB),
      ),
      _StatItem(
        title: isBangla ? "আমাদের গল্প" : "Stories",
        count: data?.storiesCount ?? 0,
        icon: CupertinoIcons.square_stack_3d_down_right,
        color: const Color(0xFF10B981),
      ),
      _StatItem(
        title: isBangla ? "আইনি সহায়তা" : "Pro Bono Services",
        count: data?.proBonoCount ?? 0,
        icon: CupertinoIcons.gear,
        color: const Color(0xFFF59E0B),
      ),
      _StatItem(
        title: isBangla ? "কোম্পানী" : "Company",
        count: data?.companyCount ?? 0,
        icon: CupertinoIcons.gear_alt,
        color: const Color(0xFF3B82F6),
      ),
      _StatItem(
        title: isBangla ? "পারিবারিক আইনজীবী সেবা" : "Family Lawyer Services",
        count: data?.familyLawyerCount ?? 0,
        icon: CupertinoIcons.gear_alt_fill,
        color: const Color(0xFFD946EF),
      ),
      _StatItem(
        title: isBangla ? "দেওয়ানী" : "Civil",
        count: data?.civilCount ?? 0,
        icon: CupertinoIcons.gear,
        color: const Color(0xFFF97316),
      ),
      _StatItem(
        title: isBangla ? "সাংবিধানিক আইন সেবা" : "Constitutional Law Services",
        count: data?.constitutionalLawCount ?? 0,
        icon: CupertinoIcons.gear_alt,
        color: const Color(0xFF64748B),
      ),
      _StatItem(
        title: isBangla ? "ফৌজদারি" : "Criminal",
        count: data?.criminalCount ?? 0,
        icon: CupertinoIcons.gear_alt_fill,
        color: const Color(0xFF14B8A6),
      ),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Welcome Card
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.instance.primaryGreen,
                const Color(0xFF06281A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.instance.primaryGreen.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.instance.goldenColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.instance.goldenColor,
                    width: 2,
                  ),
                ),
                child: Icon(
                  CupertinoIcons.shield_fill,
                  color: AppColors.instance.goldenColor,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isBangla ? "অ্যাডমিনিস্ট্রেশন সেন্টার" : "Administration Center",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isBangla
                          ? "অ্যাপের কন্টেন্ট ও নাগরিক আবেদনের সারাংশ"
                          : "Overview of content and citizen submissions",
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isBangla ? "ওয়েবসাইট ওভারভিউ" : "Website overview",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.instance.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isBangla ? "১৭টি বিভাগ" : "17 Modules",
                style: TextStyle(
                  color: AppColors.instance.primaryGreen,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: items.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.65,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final item = items[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, color: item.color, size: 19),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isBangla ? "মোট" : "Total",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade500,
                          ),
                        ),
                        Text(
                          "${item.count}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF334155),
                            height: 1.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _StatItem {
  final String title;
  final int count;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
  });
}
