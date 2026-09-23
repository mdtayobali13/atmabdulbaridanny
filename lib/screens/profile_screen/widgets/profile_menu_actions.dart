import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:atmabdulbaridanny/screens/appointment_screen/appointment_screen.dart';
import 'package:atmabdulbaridanny/screens/complain_screen/complain_screen.dart';
import 'package:atmabdulbaridanny/screens/profile_screen/widgets/change_password_dialog.dart';
import 'package:atmabdulbaridanny/screens/profile_screen/widgets/edit_profile_dialog.dart';
import 'package:atmabdulbaridanny/services/providers/api_providers.dart';
import 'package:atmabdulbaridanny/services/repository/auth_repository.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class ProfileMenuActions extends ConsumerWidget {
  final dynamic user;
  final Color primaryColor;
  final bool isBangla;
  final AppTranslations tr;

  const ProfileMenuActions({
    super.key,
    required this.user,
    required this.primaryColor,
    required this.isBangla,
    required this.tr,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          // Edit Profile Info
          _buildItem(
            context: context,
            icon: Icons.person_outline_rounded,
            iconColor: primaryColor,
            bgColor: primaryColor.withValues(alpha: 0.1),
            title: isBangla ? "প্রোফাইল তথ্য পরিবর্তন" : "Edit Profile Info",
            subtitle: isBangla ? "আপনার নাম ও ইমেইল আপডেট করুন" : "Update your name & email address",
            onTap: () => EditProfileDialog.show(context, user, isBangla),
          ),
          _divider(),

          // Change Password
          _buildItem(
            context: context,
            icon: Icons.lock_reset_rounded,
            iconColor: primaryColor,
            bgColor: primaryColor.withValues(alpha: 0.1),
            title: isBangla ? "পাসওয়ার্ড পরিবর্তন" : "Change Password",
            subtitle: isBangla ? "নতুন সিকিউরিটি পাসওয়ার্ড সেট করুন" : "Set a new secure password",
            onTap: () => ChangePasswordDialog.show(context, user, isBangla),
          ),
          _divider(),

          // Admin Dashboard
          _buildItem(
            context: context,
            icon: CupertinoIcons.shield_fill,
            iconColor: primaryColor,
            bgColor: primaryColor.withValues(alpha: 0.1),
            title: isBangla ? "অ্যাডমিন ড্যাশবোর্ড" : "Admin Dashboard",
            subtitle: isBangla ? "আবেদন, ইউজার ও সেটিংস পরিচালনা" : "Manage requests, users & content",
            onTap: () => context.push('/admin_dashboard_screen'),
          ),
          _divider(),

          // Citizen Complaint Box
          _buildItem(
            context: context,
            icon: Icons.assignment_late_rounded,
            iconColor: primaryColor,
            bgColor: primaryColor.withValues(alpha: 0.1),
            title: tr.complaintCardTitle,
            subtitle: tr.complaintBoxSubtitle,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const ComplainScreen()),
              );
            },
          ),
          _divider(),

          // Appointment & Meeting Request
          _buildItem(
            context: context,
            icon: Icons.calendar_month_rounded,
            iconColor: primaryColor,
            bgColor: primaryColor.withValues(alpha: 0.1),
            title: tr.appointmentRequestTitle,
            subtitle: tr.appointmentRequestSubtitle,
            onTap: () {
              Navigator.of(context, rootNavigator: true).push(
                MaterialPageRoute(builder: (context) => const AppointmentScreen()),
              );
            },
          ),
          _divider(),

          // Sign Out
          _buildItem(
            context: context,
            icon: Icons.logout_rounded,
            iconColor: Colors.red.shade700,
            bgColor: Colors.red.shade50,
            title: tr.signOut,
            titleColor: Colors.red.shade700,
            subtitle: tr.signOutSubtitle,
            arrowColor: Colors.red.shade700,
            arrowBgColor: Colors.red.shade50,
            onTap: () => _handleSignOut(context, ref),
          ),
        ],
      ),
    );
  }

  Widget _divider() => Divider(height: 1, color: Colors.grey.shade200);

  Widget _buildItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String title,
    Color? titleColor,
    required String subtitle,
    Color? arrowColor,
    Color? arrowBgColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: titleColor ?? const Color(0xFF1E293B),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
      ),
      trailing: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: arrowBgColor ?? Colors.grey.shade100,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: arrowColor ?? Colors.grey.shade600),
      ),
      onTap: onTap,
    );
  }

  Future<void> _handleSignOut(BuildContext context, WidgetRef ref) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          tr.signOutConfirmTitle,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF111518)),
        ),
        content: Text(
          tr.signOutConfirmMessage,
          style: const TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              tr.cancel,
              style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: Text(tr.signOut),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await AuthRepository.instance.logout();
      ref.invalidate(currentUserProvider);
    }
  }
}
