import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/services/providers/api_providers.dart';
import 'package:atmabdulbaridanny/services/repository/auth_repository.dart';
import 'package:atmabdulbaridanny/utils/app_log.dart';
import 'package:atmabdulbaridanny/utils/app_snack_bar.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';
import 'package:go_router/go_router.dart';

Future<bool?> showAdminLoginDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => const AdminLoginDialog(),
  );
}

class AdminLoginDialog extends ConsumerStatefulWidget {
  const AdminLoginDialog({super.key});

  @override
  ConsumerState<AdminLoginDialog> createState() => _AdminLoginDialogState();
}

class _AdminLoginDialogState extends ConsumerState<AdminLoginDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin(bool isBangla) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final success = await AuthRepository.instance.login(
        email: email,
        password: password,
        fcmToken: "",
        deviceId: "",
      );

      if (!mounted) return;

      if (success) {
        ref.invalidate(currentUserProvider);

        // Close Dialog
        Navigator.of(context).pop(true);

        // Close Drawer if open
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }

        // Navigate to Admin Dashboard
        context.push('/admin_dashboard_screen');

        AppSnackBar.instance.success(
          isBangla ? "অ্যাডমিন লগইন সফল হয়েছে" : "Admin logged in successfully",
        );
      } else {
        setState(() {
          _errorMessage = isBangla
              ? "ইমেইল বা পাসওয়ার্ড ভুল হয়েছে"
              : "Invalid email or password";
          _isLoading = false;
        });
      }
    } catch (e) {
      errorLog("AdminLoginDialog error", e);
      if (mounted) {
        setState(() {
          _errorMessage = isBangla
              ? "লগইন করতে সমস্যা হয়েছে, পুনরায় চেষ্টা করুন"
              : "Login failed, please try again";
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = ref.watch(isBanglaProvider);
    final primaryGreen = AppColors.instance.primaryGreen;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 10,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top close button and title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: primaryGreen.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(CupertinoIcons.shield_fill, color: primaryGreen, size: 22),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          isBangla ? "অ্যাডমিন লগইন" : "Admin Login",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black87, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  isBangla
                      ? "অ্যাডমিন ড্যাশবোর্ডে প্রবেশের জন্য লগইন করুন।"
                      : "Sign in to access the admin dashboard.",
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
                const SizedBox(height: 20),

                // Error Message Banner
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, size: 18, color: Colors.red.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(fontSize: 12, color: Colors.red.shade700, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Email Field
                Text(
                  isBangla ? "ইমেইল ঠিকানা" : "Email Address",
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: isBangla ? "আপনার ইমেইল লিখুন" : "admin@example.com",
                    hintStyle: const TextStyle(color: Colors.black54, fontSize: 13),
                    prefixIcon: Icon(Icons.email_outlined, color: primaryGreen, size: 20),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryGreen, width: 1.5)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return isBangla ? "ইমেইল দিতে হবে" : "Email is required";
                    }
                    if (!value.contains('@')) {
                      return isBangla ? "সঠিক ইমেইল দিন" : "Enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Password Field
                Text(
                  isBangla ? "পাসওয়ার্ড" : "Password",
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) => _handleLogin(isBangla),
                  style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    hintText: isBangla ? "আপনার পাসওয়ার্ড লিখুন" : "••••••••",
                    hintStyle: const TextStyle(color: Colors.black54, fontSize: 13),
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: primaryGreen, size: 20),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                        color: Colors.black54,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryGreen, width: 1.5)),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return isBangla ? "পাসওয়ার্ড দিতে হবে" : "Password is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Buttons: Cancel & Login
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.grey.shade300),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          isBangla ? "বাতিল" : "Cancel",
                          style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () => _handleLogin(isBangla),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : Text(
                                isBangla ? "লগইন" : "Login",
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
