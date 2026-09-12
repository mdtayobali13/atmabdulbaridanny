import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/services/repository/auth_repository.dart';
import 'package:flutter_riverpod_template/services/storage/storage_services.dart';
import 'package:flutter_riverpod_template/utils/languages/language_provider.dart';
import 'package:go_router/go_router.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

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
    final isBangla = ref.watch(isBanglaProvider);

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Drawer Header
          Container(
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
                    const _LanguageToggle(),
                  ],
                ),
                const SizedBox(height: 24),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 30,
                  child: Icon(Icons.gavel, color: AppColors.instance.primaryGreen, size: 36),
                ),
                const SizedBox(height: 16),
                Text(
                  isBangla ? "ব্যারিস্টার কায়সার কামাল" : "Barrister Kayser Kamal",
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  isBangla ? "সেকেন্ডারি ক্যাটাগরি" : "Secondary Categories",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          // Drawer Items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.person_crop_circle,
                  title: isBangla ? "আমার প্রোফাইল" : "My Account",
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/${AppRoutesKey.instance.profileScreen}');
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.info_circle,
                  title: isBangla ? "আমার সম্পর্কে" : "About Me",
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/${AppRoutesKey.instance.aboutScreen}');
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.book,
                  title: isBangla ? "জীবনবৃত্তান্ত" : "Biography",
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/biography_screen');
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.time,
                  title: isBangla ? "জীবন ও সংগ্রামের ইতিহাস" : "History of Life & Struggle",
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/history_of_life_screen');
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.phone,
                  title: isBangla ? "যোগাযোগ" : "Contact",
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    context.go('/contact_screen');
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.calendar,
                  title: isBangla ? "সাক্ষাৎকার" : "Appointment",
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    context.go('/appointment_screen');
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.exclamationmark_bubble,
                  title: isBangla ? "অভিযোগ" : "Complaint",
                  onTap: () {
                    Navigator.pop(context); // Close the drawer
                    context.go('/complain_screen');
                  },
                ),
                _buildDrawerDropdown(
                  context: context,
                  icon: CupertinoIcons.building_2_fill,
                  title: isBangla ? "উন্নয়নমূলক কাজ" : "Development Works",
                  children: [
                    _buildSubDrawerItem(
                      context: context,
                      title: isBangla ? "কলমাকান্দা উপজেলা" : "Kalmakanda Upazila",
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/kalmakanda_upazila_screen');
                      },
                    ),
                    _buildSubDrawerItem(
                      context: context,
                      title: isBangla ? "দুর্গাপুর উপজেলা" : "Durgapur Upazila",
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/durgapur_upazila_screen');
                      },
                    ),
                    _buildSubDrawerItem(
                      context: context,
                      title: isBangla ? "অন্যান্য" : "Others",
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/others_screen');
                      },
                    ),
                  ],
                ),
                _buildDrawerDropdown(
                  context: context,
                  icon: CupertinoIcons.news,
                  title: isBangla ? "মিডিয়া" : "Media",
                  children: [
                    _buildSubDrawerItem(
                      context: context,
                      title: isBangla ? "প্রিন্ট মিডিয়া" : "Print Media",
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/print_media_screen');
                      },
                    ),
                    _buildSubDrawerItem(
                      context: context,
                      title: isBangla ? "ইলেকট্রনিক মিডিয়া" : "Electronic Media",
                      onTap: () {
                        Navigator.pop(context);
                        context.go('/electronic_media_screen');
                      },
                    ),
                  ],
                ),
                const Divider(),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.doc_text,
                  title: isBangla ? "শর্তাবলী ও নীতিমালা" : "Terms and Conditions",
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/${AppRoutesKey.instance.termsAndConditionsScreen}');
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.shield,
                  title: isBangla ? "গোপনীয়তা নীতি" : "Privacy Policy",
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/${AppRoutesKey.instance.privacyPolicyScreen}');
                  },
                ),
                _buildDrawerItem(
                  context: context,
                  icon: CupertinoIcons.question_circle,
                  title: isBangla ? "সাধারণ জিজ্ঞাসা (FAQ)" : "FAQ",
                  onTap: () {
                    Navigator.pop(context);
                    context.go('/${AppRoutesKey.instance.faqsScreen}');
                  },
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Action Buttons: Delete Account & Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showDeleteAccountDialog(context, isBangla),
                    icon: Icon(Icons.delete_outline_rounded, size: 17, color: Colors.red.shade700),
                    label: Text(
                      isBangla ? "অ্যাকাউন্ট মুছুন" : "Delete Account",
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      side: BorderSide(color: Colors.red.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.red.shade50.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showLogoutDialog(context, isBangla),
                    icon: const Icon(Icons.logout_rounded, size: 17, color: Colors.white),
                    label: Text(
                      isBangla ? "লগআউট" : "Logout",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      backgroundColor: Colors.red.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // App Version
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              isBangla ? "ভার্সন ১.০.০" : "Version 1.0.0",
              style: TextStyle(color: Colors.grey[500], fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isBangla) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.logout_rounded, color: Colors.red.shade700, size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              isBangla ? "লগআউট" : "Logout",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111518)),
            ),
          ],
        ),
        content: Text(
          isBangla
              ? "আপনি কি নিশ্চিত যে আপনার অ্যাকাউন্ট থেকে লগআউট করতে চান?"
              : "Are you sure you want to logout from your account?",
          style: const TextStyle(fontSize: 14, color: Color(0xFF333333)),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              isBangla ? "বাতিল" : "Cancel",
              style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              Navigator.pop(context);
              await StorageServices.instance.logout();
              AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text(isBangla ? "লগআউট" : "Logout"),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, bool isBangla) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool obscurePassword = true;

    // Load saved email if available
    StorageServices.instance.getLogDedData().then((data) {
      if (data.containsKey("email") && data["email"] != null) {
        emailController.text = data["email"].toString();
      }
    });

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.warning_amber_rounded, color: Colors.red.shade700, size: 22),
                ),
                const SizedBox(width: 12),
                Text(
                  isBangla ? "অ্যাকাউন্ট মুছুন" : "Delete Account",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111518)),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isBangla
                        ? "আপনার অ্যাকাউন্টটি স্থায়ীভাবে মুছে ফেলতে ইমেইল এবং পাসওয়ার্ড দিন। এই প্রক্রিয়াটি অপরিবর্তনীয়।"
                        : "Please enter your email and password to permanently delete your account. This action cannot be undone.",
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isBangla ? "ইমেইল ঠিকানা" : "Email Address",
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF111518)),
                    decoration: InputDecoration(
                      hintText: isBangla ? "ইমেইল লিখুন" : "Enter your email",
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      prefixIcon: Icon(Icons.alternate_email_rounded, color: Colors.grey.shade600, size: 18),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.instance.primaryGreen, width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isBangla ? "পাসওয়ার্ড" : "Password",
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF222222)),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    style: const TextStyle(fontSize: 14, color: Color(0xFF111518)),
                    decoration: InputDecoration(
                      hintText: isBangla ? "পাসওয়ার্ড লিখুন" : "Enter your password",
                      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.grey.shade600, size: 18),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: Colors.grey.shade600,
                          size: 18,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF9FAFB),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.instance.primaryGreen, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  isBangla ? "বাতিল" : "Cancel",
                  style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  final password = passwordController.text.trim();
                  Navigator.pop(dialogContext);
                  Navigator.pop(context);
                  try {
                    await AuthRepository.instance.accountDelete(password: password);
                  } catch (_) {}
                  await StorageServices.instance.logout();
                  AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                child: Text(isBangla ? "মুছে ফেলুন" : "Delete"),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.instance.primaryGreen, size: 24),
      title: Text(
        title,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: titleColor ?? Colors.black87),
      ),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      onTap: onTap,
    );
  }

  Widget _buildDrawerDropdown({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Widget> children,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        leading: Icon(icon, color: AppColors.instance.primaryGreen, size: 24),
        title: Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        ),
        iconColor: Colors.grey[400],
        collapsedIconColor: Colors.grey[400],
        tilePadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
        children: children,
      ),
    );
  }

  Widget _buildSubDrawerItem({required BuildContext context, required String title, required VoidCallback onTap}) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800]),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[300]),
      contentPadding: const EdgeInsets.only(left: 64.0, right: 24.0, top: 0.0, bottom: 0.0),
      onTap: onTap,
    );
  }
}

class _LanguageToggle extends ConsumerWidget {
  const _LanguageToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBangla = ref.watch(isBanglaProvider);

    return Material(
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                ref.read(languageProvider.notifier).setLanguage('en_US');
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: !isBangla ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "Eng",
                  style: TextStyle(
                    color: !isBangla ? AppColors.instance.primaryGreen : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                ref.read(languageProvider.notifier).setLanguage('bn_BD');
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: isBangla ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "বাংলা",
                  style: TextStyle(
                    color: isBangla ? AppColors.instance.primaryGreen : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
