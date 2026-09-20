import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/models/content_models.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFooter extends ConsumerWidget {
  const CustomFooter({super.key});

  Future<void> _launch(String? url) async {
    if (url == null || url.trim().isEmpty) return;
    String target = url.trim();
    if (!target.startsWith('http://') && !target.startsWith('https://')) {
      target = 'https://$target';
    }
    try {
      final uri = Uri.parse(target);
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final setting = ref.watch(websiteSettingProvider).asData?.value;
    final footerLinks = ref.watch(footerLinksProvider).asData?.value ?? [];
    final visitStats = ref.watch(homeVisitStatsProvider).asData?.value;
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    return Container(
      width: double.infinity,
      color: primaryGreen,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Profile & Contact Info
          _buildProfileInfo(setting, isBangla, tr),
          const SizedBox(height: 32),

          // Section 2: Important Links from API
          _buildImportantLinks(footerLinks, isBangla, tr),
          const SizedBox(height: 32),

          // Section 3: Facebook Page Section
          _buildFacebookCard(setting, isBangla, tr),
          const SizedBox(height: 32),

          // Section 4: Total Visits (Visitor Stats)
          _buildVisitorStats(visitStats, isBangla, tr),
          const SizedBox(height: 32),

          // Copyright
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          Center(
            child: Text(
              tr.copyrightText,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(WebsiteSettingModel? setting, bool isBangla, AppTranslations tr) {
    final avatarUrl = setting?.fullAdminLogoUrl.isNotEmpty == true
        ? setting!.fullAdminLogoUrl
        : setting?.fullFileUrl.isNotEmpty == true
            ? setting!.fullFileUrl
            : 'https://ui-avatars.com/api/?name=Kayser+Kamal&background=0C4B33&color=fff&size=100';

    final title = isBangla
        ? (setting?.titleBn?.isNotEmpty == true ? setting!.titleBn! : tr.appTitle)
        : (setting?.titleEn?.isNotEmpty == true ? setting!.titleEn! : tr.appTitle);

    final hasBengaliInAddress = setting?.address != null &&
        RegExp(r'[\u0980-\u09FF]').hasMatch(setting!.address!);

    final String address;
    if (isBangla) {
      if (setting?.address?.isNotEmpty == true) {
        address = setting!.address!.replaceAll(RegExp(r'।?\s*মোবাইল[ঃ:].*'), '').trim();
      } else {
        address = tr.profileDesignation;
      }
    } else {
      if (setting?.address?.isNotEmpty == true && !hasBengaliInAddress) {
        address = setting!.address!;
      } else {
        address = "Deputy Speaker, Bangladesh Parliament\nNetrokona-1 (Durgapur-Kalmakanda)";
      }
    }

    final rawPhone = setting?.mobile?.isNotEmpty == true
        ? setting!.mobile!
        : tr.profileMobileNumber;
    final phone = isBangla ? rawPhone.toBanglaDigits(true) : rawPhone;

    final email = setting?.email?.isNotEmpty == true
        ? setting!.email!
        : tr.profileEmailAddress;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: CachedNetworkImage(
                imageUrl: avatarUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const SizedBox(height: 80, width: 80, child: Center(child: CircularProgressIndicator())),
                errorWidget: (context, url, error) =>
                    const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              address,
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              "${isBangla ? 'ফোন: ' : 'Phone: '}$phone",
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              "${isBangla ? 'ইমেইল: ' : 'Email: '}$email",
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (setting?.fb != null && setting!.fb!.isNotEmpty)
                _socialIcon(Icons.facebook, () => _launch(setting.fb)),
              if (setting?.yt != null && setting!.yt!.isNotEmpty) ...[
                const SizedBox(width: 12),
                _socialIcon(Icons.ondemand_video, () => _launch(setting.yt)),
              ],
              if (setting?.twi != null && setting!.twi!.isNotEmpty) ...[
                const SizedBox(width: 12),
                _socialIcon(Icons.alternate_email, () => _launch(setting.twi)),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _socialIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _buildImportantLinks(List<FooterLinkModel> links, bool isBangla, AppTranslations tr) {
    final displayLinks = links.isNotEmpty
        ? links
        : [
            FooterLinkModel(titleEn: "Parliament of Bangladesh", titleBn: "বাংলাদেশ জাতীয় সংসদ", link: "http://www.parliament.gov.bd"),
            FooterLinkModel(titleEn: "Bangladesh Supreme Court", titleBn: "বাংলাদেশ সুপ্রিম কোর্ট", link: "http://www.supremecourt.gov.bd"),
            FooterLinkModel(titleEn: "Dhaka Bar Association", titleBn: "ঢাকা বার অ্যাসোসিয়েশন", link: "http://www.dhakabar.org"),
          ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr.importantLinks,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...displayLinks.map((link) => InkWell(
                onTap: () => _launch(link.link),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.arrow_right, color: Colors.white54, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          link.localizedTitle(isBangla),
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildFacebookCard(WebsiteSettingModel? setting, bool isBangla, AppTranslations tr) {
    final fbPage = setting?.fbPage ?? setting?.fb ?? "https://facebook.com";
    final avatarUrl = setting?.fullAdminLogoUrl.isNotEmpty == true
        ? setting!.fullAdminLogoUrl
        : setting?.fullFileUrl.isNotEmpty == true
            ? setting!.fullFileUrl
            : '';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr.facebookPage,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[300]!, width: 1.5),
                        ),
                        child: ClipOval(
                          child: avatarUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: avatarUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: const Color(0xFF0C4B33),
                                    child: const Center(
                                      child: SizedBox(
                                        width: 16,
                                        height: 16,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: const Color(0xFF0C4B33),
                                    child: const Icon(Icons.person, color: Colors.white, size: 22),
                                  ),
                                )
                              : Container(
                                  color: const Color(0xFF0C4B33),
                                  child: const Icon(Icons.person, color: Colors.white, size: 22),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              tr.appTitle,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                            ),
                            Text(
                              isBangla ? "অফিসিয়াল পাবলিক পেইজ" : "Official Public Page",
                              style: const TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _launch(fbPage),
                        icon: const Icon(Icons.facebook, size: 16),
                        label: Text(tr.followUs),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildVisitorStats(Map<String, dynamic>? visitStats, bool isBangla, AppTranslations tr) {
    final todayVisits = (visitStats?['today_visits']?.toString() ?? '2').toBanglaDigits(isBangla);
    final totalVisits = (visitStats?['total_visits']?.toString() ?? '192').toBanglaDigits(isBangla);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, color: AppColors.instance.goldenColor, size: 20),
              const SizedBox(width: 8),
              Text(
                tr.totalVisitsTitle,
                style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        tr.todayVisitor,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        todayVisits,
                        style: TextStyle(
                          color: AppColors.instance.goldenColor,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 38,
                  color: Colors.white24,
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        tr.totalVisitor,
                        style: const TextStyle(color: Colors.white70, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        totalVisits,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
