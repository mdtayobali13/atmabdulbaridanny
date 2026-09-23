import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:atmabdulbaridanny/constant/app_asserts_image_path.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/screens/app_navigation/widgets/drawer/language_toggle.dart';
import 'package:atmabdulbaridanny/services/providers/api_providers.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class DrawerHeaderCard extends ConsumerWidget {
  final bool isBangla;

  const DrawerHeaderCard({
    super.key,
    required this.isBangla,
  });

  String _getFormattedDate(bool isBangla) {
    final now = DateTime.now();
    if (isBangla) {
      const banglaDays = ['সোমবার', 'মঙ্গলবার', 'বুধবার', 'বৃহস্পতিবার', 'শুক্রবার', 'শনিবার', 'রবিবার'];
      const banglaMonths = [
        'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
        'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
      ];
      const banglaDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
      String toBanglaDigits(int n) => n.toString().split('').map((c) => banglaDigits[int.parse(c)]).join('');

      final dayName = banglaDays[now.weekday - 1];
      final monthName = banglaMonths[now.month - 1];
      final dayNum = toBanglaDigits(now.day);
      final yearNum = toBanglaDigits(now.year);
      return '$dayName, $dayNum $monthName, $yearNum';
    } else {
      const englishDays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      const englishMonths = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      final dayName = englishDays[now.weekday - 1];
      final monthName = englishMonths[now.month - 1];
      return '$dayName, $monthName ${now.day}, ${now.year}';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = AppTranslations.of(isBangla);
    final setting = ref.watch(websiteSettingProvider).asData?.value;

    final name = isBangla ? tr.profileNameMp : "ATM Abdul Bari Danny";
    final designation = isBangla
        ? "চেয়ারম্যান, বিআইডব্লিউটিসি"
        : "Chairman, BIWTC";
    final addressText = isBangla
        ? "২৪ কাজী নজরুল ইসলাম এভিনিউ, ঢাকা-১০০০"
        : "24 Kazi Nazrul Islam Avenue, Dhaka-1000";

    final phone = isBangla ? "০২২২৩৩৬০৬৭১ (অফিস)" : "02223360671 (Office)";
    final email = setting?.email?.isNotEmpty == true ? setting!.email! : tr.profileEmailAddress;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 50, bottom: 20, left: 16, right: 16),
      decoration: BoxDecoration(color: AppColors.instance.primaryGreen),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.center,
                    child: Text(
                      _getFormattedDate(isBangla),
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const LanguageToggle(),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipOval(
              child: setting?.fullFileUrl.isNotEmpty == true
                  ? CachedNetworkImage(
                      imageUrl: setting!.fullFileUrl,
                      fit: BoxFit.cover,
                      width: 64,
                      height: 64,
                      placeholder: (context, url) => Image.asset(
                        AppAssertsImagePath.instance.atmAdminLogo,
                        fit: BoxFit.cover,
                        width: 64,
                        height: 64,
                      ),
                      errorWidget: (context, url, error) => Image.asset(
                        AppAssertsImagePath.instance.atmAdminLogo,
                        fit: BoxFit.cover,
                        width: 64,
                        height: 64,
                      ),
                    )
                  : Image.asset(
                      AppAssertsImagePath.instance.atmAdminLogo,
                      fit: BoxFit.cover,
                      width: 64,
                      height: 64,
                    ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: const TextStyle(color: Colors.white, fontSize: 18.5, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            addressText,
            style: TextStyle(
              color: AppColors.instance.goldenColor,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.instance.goldenColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
            child: Text(
              designation,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(Icons.phone, size: 12, color: Colors.white.withValues(alpha: 0.75)),
              const SizedBox(width: 5),
              Text(
                phone,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 11.5),
              ),
              const SizedBox(width: 12),
              Icon(Icons.email, size: 12, color: Colors.white.withValues(alpha: 0.75)),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  email,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 10.5),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
