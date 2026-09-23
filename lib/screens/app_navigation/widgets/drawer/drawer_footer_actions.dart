import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/screens/app_navigation/widgets/drawer/drawer_dialogs.dart';

class DrawerFooterActions extends ConsumerWidget {
  final bool isLoggedIn;
  final bool isBangla;

  const DrawerFooterActions({
    super.key,
    required this.isLoggedIn,
    required this.isBangla,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoggedIn) ...[
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => DrawerDialogs.showDeleteAccountDialog(context, isBangla, ref),
                    icon: Icon(Icons.delete_outline_rounded, size: 17, color: Colors.red.shade700),
                    label: Text(
                      isBangla ? "অ্যাকাউন্ট মুছুন" : "Delete Account",
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      side: BorderSide(color: Colors.red.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.red.shade50.withValues(alpha: 0.4),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => DrawerDialogs.showLogoutDialog(context, isBangla, ref),
                    icon: const Icon(Icons.logout_rounded, size: 17, color: Colors.white),
                    label: Text(
                      isBangla ? "লগআউট" : "Logout",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 11),
                      backgroundColor: Colors.red.shade700,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
          child: Text(
            isBangla ? "ভার্সন ১.০.০" : "Version 1.0.0",
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ),
      ],
    );
  }
}
