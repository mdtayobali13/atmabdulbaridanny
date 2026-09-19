import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barristerkayserkamal/screens/app_navigation/widgets/app_drawer.dart';
import 'package:barristerkayserkamal/widgets/dialogs/admin_login_dialog.dart';

class AdminAccessDeniedView extends StatelessWidget {
  final bool isBangla;
  final Color primaryColor;

  const AdminAccessDeniedView({
    super.key,
    required this.isBangla,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FA),
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(
          isBangla ? "অ্যাডমিন প্যানেল" : "Admin Panel",
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: primaryColor,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            tooltip: isBangla ? "মেনু" : "Menu",
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(CupertinoIcons.lock_shield_fill, size: 44, color: primaryColor),
                ),
                const SizedBox(height: 20),
                Text(
                  isBangla ? "অ্যাডমিন অ্যাক্সেস আবশ্যক" : "Admin Access Required",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  isBangla
                      ? "এই বিভাগটি কেবল অ্যাডমিনিস্ট্রেটরদের জন্য সংরক্ষিত। অনুগ্রহ করে আপনার অ্যাডমিন অ্যাকাউন্টে সাইন ইন করুন।"
                      : "This section is restricted to authorized administrators only. Please sign in with your admin account.",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: () => showAdminLoginDialog(context),
                    icon: const Icon(Icons.login_rounded, size: 18),
                    label: Text(
                      isBangla ? "অ্যাডমিন সাইন ইন" : "Admin Sign In",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
