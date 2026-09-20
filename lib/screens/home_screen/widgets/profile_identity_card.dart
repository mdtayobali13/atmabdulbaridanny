import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:barristerkayserkamal/constant/app_asserts_image_path.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileIdentityCard extends ConsumerWidget {
  const ProfileIdentityCard({super.key});

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);
    final setting = ref.watch(websiteSettingProvider).asData?.value;

    final name = isBangla ? tr.profileNameMp : "Barrister Kayser Kamal, MP";
    final constituency = isBangla ? tr.profileConstituency : "Netrokona-1 (Durgapur-Kalmakanda)";
    final deputySpeaker = isBangla ? tr.profileDeputySpeaker : "Deputy Speaker";
    final parliament = isBangla ? tr.profileParliament : "Bangladesh Parliament";
    final rawMobile = setting?.mobile?.isNotEmpty == true ? setting!.mobile! : tr.profileMobileNumber;
    final mobileNumber = isBangla ? rawMobile.toBanglaDigits(true) : rawMobile;
    final emailAddress = setting?.email?.isNotEmpty == true ? setting!.email! : tr.profileEmailAddress;

    final primaryGreen = AppColors.instance.primaryGreen;
    final goldenColor = AppColors.instance.goldenColor;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: goldenColor.withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryGreen.withValues(alpha: 0.10),
            blurRadius: 18,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.5),
        child: Column(
          children: [
            // ─────────────────────────────────────────────────────────────
            // 1. Premium Top Header Bar
            // ─────────────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryGreen,
                    const Color(0xFF13523C),
                    primaryGreen,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.stars_rounded, color: goldenColor, size: 15),
                  const SizedBox(width: 8),
                  Text(
                    isBangla ? "গণপ্রজাতন্ত্রী বাংলাদেশ জাতীয় সংসদ" : "Parliament of the People's Republic of Bangladesh",
                    style: TextStyle(
                      color: goldenColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.stars_rounded, color: goldenColor, size: 15),
                ],
              ),
            ),
            // Golden accent line
            Container(
              height: 2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    goldenColor.withValues(alpha: 0.3),
                    goldenColor,
                    const Color(0xFFFFF2B2),
                    goldenColor,
                    goldenColor.withValues(alpha: 0.3),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 18),

            // ─────────────────────────────────────────────────────────────
            // 2. Profile Portrait with Luxury Golden Frame
            // ─────────────────────────────────────────────────────────────
            Center(
              child: Container(
                padding: const EdgeInsets.all(3.5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      goldenColor,
                      const Color(0xFFFFF4BF),
                      const Color(0xFFAA771C),
                      goldenColor,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: goldenColor.withValues(alpha: 0.35),
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Container(
                  width: 128,
                  height: 145,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.5),
                    child: setting?.fullAdminLogoUrl.isNotEmpty == true
                        ? CachedNetworkImage(
                            imageUrl: setting!.fullAdminLogoUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (context, url, error) => Image.asset(
                              AppAssertsImagePath.instance.barristerKayserKamal,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Image.asset(
                            AppAssertsImagePath.instance.barristerKayserKamal,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ─────────────────────────────────────────────────────────────
            // 3. Name & Constituency
            // ─────────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryGreen,
                  fontSize: 20.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),
            const SizedBox(height: 6),

            // Constituency Pill Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: goldenColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: goldenColor.withValues(alpha: 0.45), width: 1),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, size: 14, color: primaryGreen),
                  const SizedBox(width: 5),
                  Text(
                    constituency,
                    style: TextStyle(
                      color: primaryGreen,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ─────────────────────────────────────────────────────────────
            // 4. Official Designation Card (Deputy Speaker & Parliament)
            // ─────────────────────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    primaryGreen,
                    const Color(0xFF14533D),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primaryGreen.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: goldenColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: goldenColor.withValues(alpha: 0.6), width: 1),
                    ),
                    child: Icon(Icons.account_balance, color: goldenColor, size: 22),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              deputySpeaker,
                              style: TextStyle(
                                color: goldenColor,
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Icon(Icons.verified, color: goldenColor, size: 16),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          parliament,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ─────────────────────────────────────────────────────────────
            // 5. Interactive Actionable Contact Buttons
            // ─────────────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  // Phone Tile
                  _buildContactCard(
                    icon: Icons.phone_in_talk_rounded,
                    iconBgColor: primaryGreen,
                    iconColor: goldenColor,
                    label: isBangla ? "মোবাইল" : "Mobile",
                    value: mobileNumber,
                    actionText: isBangla ? "কল করুন" : "Call",
                    actionColor: primaryGreen,
                    onTap: () => _launchUrl('tel:${mobileNumber.replaceAll(RegExp(r'[^0-9+]'), '')}'),
                  ),
                  const SizedBox(height: 8),

                  // Email Tile
                  _buildContactCard(
                    icon: Icons.alternate_email_rounded,
                    iconBgColor: goldenColor,
                    iconColor: primaryGreen,
                    label: isBangla ? "ইমেইল" : "Email",
                    value: emailAddress,
                    actionText: isBangla ? "মেইল পাঠান" : "Email",
                    actionColor: const Color(0xFF1A5F45),
                    onTap: () => _launchUrl('mailto:$emailAddress'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ─────────────────────────────────────────────────────────────
            // 6. Bottom Dignity Motto & Seal Ribbon
            // ─────────────────────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 7),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                border: Border(top: BorderSide(color: Colors.grey.shade300, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shield_outlined, size: 13, color: primaryGreen),
                  const SizedBox(width: 6),
                  Text(
                    isBangla ? "জনগণের সেবা ও উন্নয়নে সর্বদা প্রতিশ্রুতিবদ্ধ" : "Committed to public service and development",
                    style: TextStyle(
                      color: primaryGreen,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required String value,
    required String actionText,
    required Color actionColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade300, width: 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 10.5,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: actionColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 3),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 9),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
