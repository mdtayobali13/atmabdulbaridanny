import 'package:flutter/material.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/services/repository/auth_repository.dart';
import 'package:barristerkayserkamal/utils/app_snack_bar.dart';

class ChangePasswordDialog extends StatefulWidget {
  final dynamic user;
  final bool isBangla;

  const ChangePasswordDialog({
    super.key,
    required this.user,
    required this.isBangla,
  });

  static Future<void> show(BuildContext context, dynamic user, bool isBangla) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ChangePasswordDialog(user: user, isBangla: isBangla),
    );
  }

  @override
  State<ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<ChangePasswordDialog> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final success = await AuthRepository.instance.changePassword(
      userId: widget.user.id ?? 1,
      name: widget.user.name,
      email: widget.user.email,
      newPassword: _newPasswordController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context);
    }

    if (success) {
      AppSnackBar.instance.success(
        widget.isBangla ? "পাসওয়ার্ড সফলভাবে পরিবর্তন হয়েছে" : "Password changed successfully",
      );
    } else {
      AppSnackBar.instance.error(
        widget.isBangla ? "পাসওয়ার্ড পরিবর্তন ব্যর্থ হয়েছে" : "Failed to change password",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.instance.primaryGreen;

    return AlertDialog(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_outline_rounded, color: primaryColor, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.isBangla ? "পাসওয়ার্ড পরিবর্তন" : "Change Password",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black54, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.isBangla ? "নতুন পাসওয়ার্ড" : "New Password",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _newPasswordController,
              obscureText: _obscureNew,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              decoration: _passwordDecoration(
                hint: widget.isBangla ? "কমপক্ষে ৬ অক্ষর লিখুন" : "••••••••",
                obscure: _obscureNew,
                onToggle: () => setState(() => _obscureNew = !_obscureNew),
                primaryColor: primaryColor,
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return widget.isBangla ? "পাসওয়ার্ড দিতে হবে" : "Password is required";
                }
                if (val.trim().length < 6) {
                  return widget.isBangla ? "কমপক্ষে ৬ অক্ষরের পাসওয়ার্ড দিন" : "Must be at least 6 characters";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              widget.isBangla ? "পাসওয়ার্ড নিশ্চিত করুন" : "Confirm Password",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _confirmPasswordController,
              obscureText: _obscureConfirm,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              decoration: _passwordDecoration(
                hint: widget.isBangla ? "পুনরায় পাসওয়ার্ড লিখুন" : "••••••••",
                obscure: _obscureConfirm,
                onToggle: () => setState(() => _obscureConfirm = !_obscureConfirm),
                primaryColor: primaryColor,
              ),
              validator: (val) {
                if (val != _newPasswordController.text) {
                  return widget.isBangla ? "পাসওয়ার্ড দুটি মিলছে না" : "Passwords do not match";
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.pop(context),
          child: Text(
            widget.isBangla ? "বাতিল" : "Cancel",
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
        ),
        ElevatedButton(
          onPressed: _isSaving ? null : _handleSave,
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: _isSaving
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(widget.isBangla ? "পরিবর্তন করুন" : "Update Password"),
        ),
      ],
    );
  }

  InputDecoration _passwordDecoration({
    required String hint,
    required bool obscure,
    required VoidCallback onToggle,
    required Color primaryColor,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      suffixIcon: IconButton(
        icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: Colors.black54),
        onPressed: onToggle,
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryColor, width: 1.5)),
    );
  }
}
