import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/routes/app_routes.dart';
import 'package:barristerkayserkamal/routes/app_routes_key.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';
import 'package:barristerkayserkamal/services/repository/auth_repository.dart';
import 'package:barristerkayserkamal/services/storage/storage_services.dart';

class DrawerDialogs {
  static void showLogoutDialog(BuildContext context, bool isBangla, WidgetRef ref) {
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
              ref.invalidate(currentUserProvider);
              AppRoutes.instance.go(AppRoutesKey.instance.homeScreen);
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

  static void showDeleteAccountDialog(BuildContext context, bool isBangla, WidgetRef ref) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    bool obscurePassword = true;

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
                  ref.invalidate(currentUserProvider);
                  AppRoutes.instance.go(AppRoutesKey.instance.homeScreen);
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
}
