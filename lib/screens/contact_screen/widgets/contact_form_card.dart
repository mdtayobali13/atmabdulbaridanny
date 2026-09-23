import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_api_url.dart';
import 'package:atmabdulbaridanny/services/api/api_services.dart';
import 'package:atmabdulbaridanny/utils/app_snack_bar.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class ContactFormCard extends ConsumerStatefulWidget {
  final Color primaryGreen;
  final AppTranslations tr;

  const ContactFormCard({
    super.key,
    required this.primaryGreen,
    required this.tr,
  });

  @override
  ConsumerState<ContactFormCard> createState() => _ContactFormCardState();
}

class _ContactFormCardState extends ConsumerState<ContactFormCard> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitContact() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final body = {
        'name': _nameController.text.trim(),
        'number': _phoneController.text.trim(),
        'subject': _subjectController.text.trim(),
        'message': _messageController.text.trim(),
        'type': 'contact',
      };

      final response = await ApiServices.instance.postServices(
        url: AppApiUrl.instance.appointment,
        body: body,
      );

      if (!mounted) return;

      if (response != null) {
        AppSnackBar.instance.success(widget.tr.messageSentSuccess);
        _formKey.currentState?.reset();
        _nameController.clear();
        _phoneController.clear();
        _subjectController.clear();
        _messageController.clear();
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: widget.primaryGreen, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.tr.sendDirectMessage,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
              cursorColor: widget.primaryGreen,
              decoration: _buildInputDecoration(widget.tr.yourNameLabel),
              validator: (v) => v == null || v.trim().isEmpty ? widget.tr.nameRequired : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
              cursorColor: widget.primaryGreen,
              decoration: _buildInputDecoration(widget.tr.phoneNumberLabel),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _subjectController,
              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
              cursorColor: widget.primaryGreen,
              decoration: _buildInputDecoration(widget.tr.subjectLabel),
              validator: (v) => v == null || v.trim().isEmpty ? widget.tr.subjectRequired : null,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _messageController,
              maxLines: 4,
              style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
              cursorColor: widget.primaryGreen,
              decoration: _buildInputDecoration(widget.tr.messageLabel),
              validator: (v) => v == null || v.trim().isEmpty ? widget.tr.messageRequired : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : Text(
                        widget.tr.sendMessageBtn,
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
      floatingLabelStyle: TextStyle(color: widget.primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: widget.primaryGreen, width: 1.5),
      ),
    );
  }
}
