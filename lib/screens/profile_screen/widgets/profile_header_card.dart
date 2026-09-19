import 'package:flutter/material.dart';
import 'package:barristerkayserkamal/screens/profile_screen/widgets/edit_profile_dialog.dart';

class ProfileHeaderCard extends StatelessWidget {
  final dynamic user;
  final Color primaryColor;
  final bool isBangla;

  const ProfileHeaderCard({
    super.key,
    required this.user,
    required this.primaryColor,
    required this.isBangla,
  });

  @override
  Widget build(BuildContext context) {
    final name = user.name ?? 'Citizen';
    final email = user.email ?? 'No email';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: const [
          BoxShadow(color: Color(0x0A000000), blurRadius: 10, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: primaryColor,
            child: Text(
              initial,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111827)),
          ),
          const SizedBox(height: 4),
          Text(
            email,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => EditProfileDialog.show(context, user, isBangla),
            icon: const Icon(Icons.edit_outlined, size: 15),
            label: Text(
              isBangla ? "প্রোফাইল সম্পাদনা" : "Edit Profile",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: primaryColor,
              side: BorderSide(color: primaryColor, width: 1.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            ),
          ),
        ],
      ),
    );
  }
}
