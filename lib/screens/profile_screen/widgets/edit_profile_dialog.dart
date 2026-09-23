import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/services/providers/api_providers.dart';
import 'package:atmabdulbaridanny/services/repository/auth_repository.dart';
import 'package:atmabdulbaridanny/utils/app_snack_bar.dart';

class EditProfileDialog extends ConsumerStatefulWidget {
  final dynamic user;
  final bool isBangla;

  const EditProfileDialog({
    super.key,
    required this.user,
    required this.isBangla,
  });

  static Future<void> show(BuildContext context, dynamic user, bool isBangla) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => EditProfileDialog(user: user, isBangla: isBangla),
    );
  }

  @override
  ConsumerState<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends ConsumerState<EditProfileDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name ?? '');
    _emailController = TextEditingController(text: widget.user.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final success = await AuthRepository.instance.updateProfile(
      userId: widget.user.id ?? 1,
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
    );

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context);
    }

    if (success) {
      ref.invalidate(currentUserProvider);
      AppSnackBar.instance.success(
        widget.isBangla ? "প্রোফাইল সফলভাবে আপডেট হয়েছে" : "Profile updated successfully",
      );
    } else {
      AppSnackBar.instance.error(
        widget.isBangla ? "প্রোফাইল আপডেট ব্যর্থ হয়েছে" : "Failed to update profile",
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
            child: Icon(Icons.person_outline_rounded, color: primaryColor, size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.isBangla ? "প্রোফাইল সম্পাদনা" : "Edit Profile",
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
              widget.isBangla ? "পূর্ণ নাম" : "Full Name",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nameController,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              decoration: _inputDecoration(widget.isBangla ? "আপনার নাম লিখুন" : "Enter full name", primaryColor),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return widget.isBangla ? "নাম দিতে হবে" : "Name is required";
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Text(
              widget.isBangla ? "ইমেইল ঠিকানা" : "Email Address",
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(fontSize: 14, color: Colors.black),
              decoration: _inputDecoration(widget.isBangla ? "আপনার ইমেইল লিখুন" : "Enter email", primaryColor),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return widget.isBangla ? "ইমেইল দিতে হবে" : "Email is required";
                }
                if (!val.contains('@')) {
                  return widget.isBangla ? "সঠিক ইমেইল দিন" : "Enter a valid email";
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
              : Text(widget.isBangla ? "সংরক্ষণ করুন" : "Save Changes"),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint, Color primaryColor) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: primaryColor, width: 1.5)),
    );
  }
}
