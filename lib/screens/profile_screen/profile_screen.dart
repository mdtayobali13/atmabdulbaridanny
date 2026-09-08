import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';
import 'package:flutter_riverpod_template/services/repository/auth_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("My Account", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: primaryGreen,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            userAsync.when(
              data: (user) {
                if (user == null || user.id == null) {
                  return _buildGuestView(context, primaryGreen);
                }
                return _buildAuthenticatedView(context, ref, user, primaryGreen);
              },
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 80),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => _buildGuestView(context, primaryGreen),
            ),
            const SizedBox(height: 20),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestView(BuildContext context, Color primaryColor) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_outline, size: 64, color: primaryColor),
          ),
          const SizedBox(height: 20),
          const Text(
            "Welcome to Kayser Kamal App",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            "Sign in or create an account to track your complaints, book appointments, and manage profile settings.",
            style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.5),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pushNamed(AppRoutesKey.instance.signInScreen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: const Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pushNamed(AppRoutesKey.instance.signUpScreen);
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: primaryColor, width: 1.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("Register New Account", style: TextStyle(color: primaryColor, fontSize: 15, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticatedView(BuildContext context, WidgetRef ref, dynamic user, Color primaryColor) {
    final name = user.name ?? 'Citizen';
    final email = user.email ?? 'No email';
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Profile Info Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
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
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action Items
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.report_problem_outlined, color: primaryColor),
                  title: const Text("Citizen Complaint Box", style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(AppRoutesKey.instance.complainScreen);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.calendar_month_outlined, color: primaryColor),
                  title: const Text("Appointment & Meeting Request", style: TextStyle(fontWeight: FontWeight.w500)),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pushNamed(AppRoutesKey.instance.appointmentScreen);
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.redAccent),
                  title: const Text("Sign Out", style: TextStyle(fontWeight: FontWeight.w500, color: Colors.redAccent)),
                  onTap: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text("Sign Out"),
                        content: const Text("Are you sure you want to sign out?"),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
                          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Sign Out", style: TextStyle(color: Colors.red))),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      await AuthRepository.instance.logout();
                      ref.invalidate(currentUserProvider);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
