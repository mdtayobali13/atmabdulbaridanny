import 'package:flutter/material.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInfoCard extends StatelessWidget {
  final Color primaryGreen;
  final Color lightGreen;
  final String address;
  final String phone;
  final String email;
  final AppTranslations tr;

  const ContactInfoCard({
    super.key,
    required this.primaryGreen,
    required this.lightGreen,
    required this.address,
    required this.phone,
    required this.email,
    required this.tr,
  });

  Future<void> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url.trim());
      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.platformDefault);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
            decoration: BoxDecoration(
              color: lightGreen,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              tr.officialContactInfo,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[50],
                    child: Icon(Icons.location_on, color: primaryGreen),
                  ),
                  title: Text(tr.addressLabel, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
                  subtitle: Text(address, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[50],
                    child: Icon(Icons.phone, color: primaryGreen),
                  ),
                  title: Text(tr.phone, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
                  subtitle: Text(phone, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                  onTap: () => _launchUrl("tel:$phone"),
                ),
                const Divider(),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green[50],
                    child: Icon(Icons.email, color: primaryGreen),
                  ),
                  title: Text(tr.email, style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500)),
                  subtitle: Text(email, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
                  onTap: () => _launchUrl("mailto:$email"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
