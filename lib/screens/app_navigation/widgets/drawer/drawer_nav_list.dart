import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/routes/app_routes_key.dart';
import 'package:atmabdulbaridanny/widgets/dialogs/admin_login_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class DrawerNavList extends StatelessWidget {
  final bool isLoggedIn;
  final bool isBangla;

  const DrawerNavList({
    super.key,
    required this.isLoggedIn,
    required this.isBangla,
  });

  void _navigateTo(BuildContext context, String path, {bool isPush = false}) {
    final router = GoRouter.of(context);
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Scaffold.maybeOf(context)?.closeDrawer();
    }

    Future.delayed(const Duration(milliseconds: 250), () {
      if (isPush) {
        router.push(path);
      } else {
        router.go(path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppTranslations.of(isBangla);
    return Material(
      color: Colors.transparent,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
        if (isLoggedIn)
          _buildItem(
            context: context,
            icon: CupertinoIcons.person_crop_circle,
            title: isBangla ? "অ্যাডমিন প্রোফাইল" : "Admin Profile",
            onTap: () => _navigateTo(context, '/${AppRoutesKey.instance.profileScreen}', isPush: true),
          ),
        // 1. প্রথম পাতা / Home
        _buildItem(
          context: context,
          icon: CupertinoIcons.house_fill,
          title: tr.navHome,
          onTap: () => _navigateTo(context, '/${AppRoutesKey.instance.homeScreen}'),
        ),
        // 2. আমাদের সম্পর্কে / About Us
        _buildDropdown(
          context: context,
          icon: CupertinoIcons.person_2_fill,
          title: tr.menuAboutUs,
          children: [
            _buildSubItem(
              context: context,
              title: tr.menuAboutMe,
              onTap: () => _navigateTo(context, '/${AppRoutesKey.instance.aboutScreen}'),
            ),
            _buildSubItem(
              context: context,
              title: tr.menuBiography,
              onTap: () => _navigateTo(context, '/biography_screen'),
            ),
            _buildSubItem(
              context: context,
              title: tr.menuHistoryOfLifeAndStruggle,
              onTap: () => _navigateTo(context, '/history_of_life_screen'),
            ),
            _buildSubItem(
              context: context,
              title: tr.menuAchievement,
              onTap: () => _navigateTo(context, '/achievement_screen'),
            ),
            _buildSubItem(
              context: context,
              title: tr.menuJourney,
              onTap: () => _navigateTo(context, '/journey_screen'),
            ),
          ],
        ),
        // 3. উন্নয়নমূলক কাজ / Development Works
        _buildDropdown(
          context: context,
          icon: CupertinoIcons.building_2_fill,
          title: tr.menuDevelopmentWorks,
          children: [
            _buildSubItem(
              context: context,
              title: tr.menuNetrokonaSadar,
              onTap: () => _navigateTo(context, '/netrokona_sadar_upazila_screen'),
            ),
            _buildSubItem(
              context: context,
              title: tr.menuBarhatta,
              onTap: () => _navigateTo(context, '/barhatta_upazila_screen'),
            ),
            _buildSubItem(
              context: context,
              title: tr.menuOthers,
              onTap: () => _navigateTo(context, '/others_screen'),
            ),
          ],
        ),
        // 4. মিডিয়া / Media
        _buildDropdown(
          context: context,
          icon: CupertinoIcons.tv_fill,
          title: tr.menuMedia,
          children: [
            _buildSubItem(
              context: context,
              title: tr.menuPrintMedia,
              onTap: () => _navigateTo(context, '/print_media_screen'),
            ),
            _buildSubItem(
              context: context,
              title: tr.menuElectronicMedia,
              onTap: () => _navigateTo(context, '/electronic_media_screen'),
            ),
          ],
        ),
        // 5. গ্যালারি / Gallery
        _buildDropdown(
          context: context,
          icon: CupertinoIcons.photo_fill_on_rectangle_fill,
          title: tr.menuGallery,
          children: [
            _buildSubItem(
              context: context,
              title: tr.menuPhotoGallery,
              onTap: () => _navigateTo(context, '/photo_gallery_screen'),
            ),
            _buildSubItem(
              context: context,
              title: tr.menuVideoGallery,
              onTap: () => _navigateTo(context, '/video_gallery_screen'),
            ),
          ],
        ),
        // 6. সংবাদ / News
        _buildItem(
          context: context,
          icon: CupertinoIcons.news_solid,
          title: tr.menuNews,
          onTap: () => _navigateTo(context, '/news_screen'),
        ),
        // 7. ব্লগ / Blog
        _buildItem(
          context: context,
          icon: CupertinoIcons.book_fill,
          title: tr.menuBlog,
          onTap: () => _navigateTo(context, '/blog_screen'),
        ),
        // 8. যোগাযোগ / Contact
        _buildItem(
          context: context,
          icon: CupertinoIcons.phone_fill,
          title: tr.menuContact,
          onTap: () => _navigateTo(context, '/contact_screen'),
        ),
        // 9. অ্যাপয়েন্টমেন্ট / Appointment
        _buildItem(
          context: context,
          icon: CupertinoIcons.calendar,
          title: tr.menuAppointment,
          onTap: () => _navigateTo(context, '/appointment_screen', isPush: true),
        ),
        // 10. অভিযোগ / Complaint
        _buildItem(
          context: context,
          icon: CupertinoIcons.exclamationmark_bubble,
          title: tr.menuComplaint,
          onTap: () => _navigateTo(context, '/complain_screen', isPush: true),
        ),
        // 11. অ্যাডমিন / Admin
        _buildItem(
          context: context,
          icon: CupertinoIcons.shield_fill,
          title: isBangla ? "অ্যাডমিন" : "Admin",
          onTap: () {
            if (isLoggedIn) {
              _navigateTo(context, '/admin_dashboard_screen', isPush: true);
            } else {
              showAdminLoginDialog(context);
            }
          },
        ),
        const Divider(),
        _buildItem(
          context: context,
          icon: CupertinoIcons.doc_text,
          title: isBangla ? "শর্তাবলী ও নীতিমালা" : "Terms and Conditions",
          onTap: () => _navigateTo(context, '/${AppRoutesKey.instance.termsAndConditionsScreen}', isPush: true),
        ),
        _buildItem(
          context: context,
          icon: CupertinoIcons.shield,
          title: isBangla ? "গোপনীয়তা নীতি" : "Privacy Policy",
          onTap: () => _navigateTo(context, '/${AppRoutesKey.instance.privacyPolicyScreen}', isPush: true),
        ),
        _buildItem(
          context: context,
          icon: CupertinoIcons.question_circle,
          title: isBangla ? "সাধারণ জিজ্ঞাসা (FAQ)" : "FAQ",
          onTap: () => _navigateTo(context, '/${AppRoutesKey.instance.faqsScreen}', isPush: true),
        ),
      ],
    ),
  );
}

  Widget _buildItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.instance.primaryGreen, size: 24),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey[400]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      onTap: onTap,
    );
  }

  Widget _buildDropdown({
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

  Widget _buildSubItem({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[800]),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey[300]),
      contentPadding: const EdgeInsets.only(left: 64.0, right: 24.0),
      onTap: onTap,
    );
  }
}
