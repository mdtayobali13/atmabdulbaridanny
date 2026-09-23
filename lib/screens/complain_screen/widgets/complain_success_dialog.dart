import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:atmabdulbaridanny/utils/app_snack_bar.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class ComplainSuccessDialog {
  static void show(BuildContext context, String trackingNo, AppTranslations tr) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.check_circle, color: Color(0xFF0C4B33), size: 28),
              const SizedBox(width: 8),
              Text(tr.complaintSubmittedTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr.complaintSubmittedMessage,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF0C4B33), width: 1.5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        trackingNo,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0C4B33),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy, size: 20, color: Color(0xFF0C4B33)),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: trackingNo));
                        AppSnackBar.instance.success(tr.trackingCopied);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0C4B33),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(tr.done, style: const TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
