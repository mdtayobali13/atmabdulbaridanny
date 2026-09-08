import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/models/content_models.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomFooter extends ConsumerWidget {
  const CustomFooter({super.key});

  Future<void> _launch(String? url) async {
    if (url == null || url.trim().isEmpty) return;
    try {
      final uri = Uri.parse(url.trim());
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final setting = ref.watch(websiteSettingProvider).asData?.value;
    final footerLinks = ref.watch(footerLinksProvider).asData?.value ?? [];

    return Container(
      width: double.infinity,
      color: primaryGreen,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Profile & Contact Info
          _buildProfileInfo(setting),
          const SizedBox(height: 32),

          // Section 2: Important Links from API
          _buildImportantLinks(footerLinks),
          const SizedBox(height: 32),

          // Section 3: Facebook Page Section
          _buildFacebookCard(setting),
          const SizedBox(height: 32),

          // Copyright
          const Divider(color: Colors.white24),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              "© 2026 Barrister Kayser Kamal. All rights reserved.",
              style: TextStyle(color: Colors.white54, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(WebsiteSettingModel? setting) {
    final avatarUrl = setting?.fullAdminLogoUrl.isNotEmpty == true
        ? setting!.fullAdminLogoUrl
        : setting?.fullFileUrl.isNotEmpty == true
            ? setting!.fullFileUrl
            : 'https://ui-avatars.com/api/?name=Kayser+Kamal&background=0C4B33&color=fff&size=100';

    final title = setting?.titleEn?.isNotEmpty == true ? setting!.titleEn! : "Barrister Kayser Kamal";
    final address = setting?.address?.isNotEmpty == true
        ? setting!.address!
        : "Law Affairs Secretary, BNP\nAdvocate, Bangladesh Supreme Court\nDhaka, Bangladesh.";

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
                    const SizedBox(width: 80, height: 80, child: Center(child: CircularProgressIndicator(strokeWidth: 2))),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.person, color: Colors.white, size: 60),
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
              style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
              textAlign: TextAlign.center,
            ),
          ),
          if (setting?.mobile != null && setting!.mobile!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Center(
              child: Text(
                "Phone: ${setting.mobile}",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
          if (setting?.email != null && setting!.email!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Center(
              child: Text(
                "Email: ${setting.email}",
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
          ],
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

  Widget _buildImportantLinks(List<FooterLinkModel> links) {
    final displayLinks = links.isNotEmpty
        ? links
        : const [
            FooterLinkModel(titleEn: "Parliament of Bangladesh", link: "http://www.parliament.gov.bd"),
            FooterLinkModel(titleEn: "Bangladesh Supreme Court", link: "http://www.supremecourt.gov.bd"),
            FooterLinkModel(titleEn: "Dhaka Bar Association", link: "http://www.dhakabar.org"),
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
          const Text(
            "Important Links",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                          link.localizedTitle(false),
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

  Widget _buildFacebookCard(WebsiteSettingModel? setting) {
    final fbPage = setting?.fbPage ?? setting?.fb ?? "https://facebook.com";
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Facebook Page",
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!, width: 1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF0C4B33),
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Barrister Kayser Kamal",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                            ),
                            Text(
                              "Official Public Page",
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _launch(fbPage),
                        icon: const Icon(Icons.facebook, size: 16),
                        label: const Text("Follow"),
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
}
