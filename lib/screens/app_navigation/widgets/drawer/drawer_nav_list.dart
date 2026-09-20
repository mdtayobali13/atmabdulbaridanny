import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/routes/app_routes_key.dart';
import 'package:barristerkayserkamal/widgets/dialogs/admin_login_dialog.dart';
import 'package:go_router/go_router.dart';

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
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        if (isLoggedIn)
          _buildItem(
            context: context,
            icon: CupertinoIcons.person_crop_circle,
            title: isBangla ? "অ্যাডমিন প্রোফাইল" : "Admin Profile",
            onTap: () => _navigateTo(context, '/${AppRoutesKey.instance.profileScreen}', isPush: true),
          ),
        _buildItem(
          context: context,
          icon: CupertinoIcons.house_fill,
          title: isBangla ? "হোম" : "Home",
          onTap: () => _navigateTo(context, '/${AppRoutesKey.instance.homeScreen}'),
        ),
        _buildDropdown(
          context: context,
          icon: CupertinoIcons.person_2_fill,
          title: isBangla ? "আমাদের সম্পর্কে" : "About Us",
          children: [
            _buildSubItem(
              context: context,
              title: isBangla ? "আমার সম্পর্কে" : "About Me",
              onTap: () => _navigateTo(context, '/${AppRoutesKey.instance.aboutScreen}'),
            ),
            _buildSubItem(
              context: context,
              title: isBangla ? "জীবনবৃত্তান্ত" : "Biography",
              onTap: () => _navigateTo(context, '/biography_screen'),
            ),
            _buildSubItem(
              context: context,
              title: isBangla ? "জীবন ও সংগ্রামের ইতিহাস" : "History of Life and Struggle",
              onTap: () => _navigateTo(context, '/history_of_life_screen'),
            ),
            _buildSubItem(
              context: context,
              title: isBangla ? "অর্জন" : "Achievement",
              onTap: () => _navigateTo(context, '/achievement_screen'),
            ),
            _buildSubItem(
              context: context,
              title: isBangla ? "যাত্রা ও পথচলা" : "Journey",
              onTap: () => _navigateTo(context, '/journey_screen'),
            ),
          ],
        ),
        _buildItem(
          context: context,
          icon: CupertinoIcons.news_solid,
          title: isBangla ? "সংবাদ" : "News",
          onTap: () => _navigateTo(context, '/news_screen'),
        ),
        _buildItem(
          context: context,
          icon: CupertinoIcons.book_fill,
          title: isBangla ? "ব্লগ" : "Blog",
          onTap: () => _navigateTo(context, '/blog_screen'),
        ),
        _buildItem(
          context: context,
          icon: CupertinoIcons.photo_fill_on_rectangle_fill,
          title: isBangla ? "ফটো গ্যালারি" : "Photo Gallery",
          onTap: () => _navigateTo(context, '/photo_gallery_screen'),
        ),
        _buildItem(
          context: context,
          icon: CupertinoIcons.play_rectangle_fill,
          title: isBangla ? "ভিডিও গ্যালারি" : "Video Gallery",
          onTap: () => _navigateTo(context, '/video_gallery_screen'),
        ),
        _buildDropdown(
          context: context,
          icon: CupertinoIcons.building_2_fill,
          title: isBangla ? "উন্নয়নমূলক কাজ" : "Development Works",
          children: [
            _buildSubItem(
              context: context,
              title: isBangla ? "কলমাকান্দা উপজেলা" : "Kalmakanda Upazila",
              onTap: () => _navigateTo(context, '/kalmakanda_upazila_screen'),
            ),
            _buildSubItem(
              context: context,
              title: isBangla ? "দুর্গাপুর উপজেলা" : "Durgapur Upazila",
              onTap: () => _navigateTo(context, '/durgapur_upazila_screen'),
            ),
            _buildSubItem(
              context: context,
              title: isBangla ? "অন্যান্য" : "Others",
              onTap: () => _navigateTo(context, '/others_screen'),
            ),
          ],
        ),
        _buildDropdown(
          context: context,
          icon: CupertinoIcons.tv_fill,
          title: isBangla ? "মিডিয়া" : "Media",
          children: [
            _buildSubItem(
              context: context,
              title: isBangla ? "প্রিন্ট মিডিয়া" : "Print Media",
              onTap: () => _navigateTo(context, '/print_media_screen'),
            ),
            _buildSubItem(
              context: context,
              title: isBangla ? "ইলেকট্রনিক মিডিয়া" : "Electronic Media",
              onTap: () => _navigateTo(context, '/electronic_media_screen'),
            ),
          ],
        ),
        _buildItem(
          context: context,
          icon: CupertinoIcons.calendar,
          title: isBangla ? "সাক্ষাৎকার" : "Appointment",
          onTap: () => _navigateTo(context, '/appointment_screen', isPush: true),
        ),
        _buildItem(
          context: context,
          icon: CupertinoIcons.exclamationmark_bubble,
          title: isBangla ? "অভিযোগ" : "Complaint",
          onTap: () => _navigateTo(context, '/complain_screen', isPush: true),
        ),
        _buildItem(
          context: context,
          icon: CupertinoIcons.phone_fill,
          title: isBangla ? "যোগাযোগ" : "Contact",
          onTap: () => _navigateTo(context, '/contact_screen'),
        ),
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
