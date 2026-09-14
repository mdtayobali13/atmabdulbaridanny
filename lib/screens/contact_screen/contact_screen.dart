import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_api_url.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/home_screen/widgets/custom_footer.dart';
import 'package:flutter_riverpod_template/services/api/api_services.dart';
import 'package:flutter_riverpod_template/services/providers/api_providers.dart';
import 'package:flutter_riverpod_template/services/repository/home_repository.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/utils/languages/language_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSubmitting = false;

  Map<String, dynamic>? _visitStats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await HomeRepository.instance.recordVisit('/contact');
    if (mounted && stats != null) {
      setState(() => _visitStats = stats);
    }
  }

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
        final isBangla = ref.read(isBanglaProvider);
        final tr = AppTranslations.of(isBangla);
        AppSnackBar.instance.success(tr.messageSentSuccess);
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
    final primaryGreen = AppColors.instance.primaryGreen;
    final lightGreen = AppColors.instance.lightGreen;
    final setting = ref.watch(websiteSettingProvider).asData?.value;
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    final phone = setting?.mobile ?? "01713004673";
    final email = setting?.email ?? "info@barristerkayserkamal.info";
    final address = setting?.address ?? tr.parliamentAddress;

    final todayVisits = (_visitStats?['today_visits']?.toString() ?? '1').toBanglaDigits(isBangla);
    final totalVisits = (_visitStats?['total_visits']?.toString() ?? '80').toBanglaDigits(isBangla);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Green Banner
            Container(
              width: double.infinity,
              color: primaryGreen,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          tr.contactScreenTitle,
                          style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              context.goNamed('homeScreen');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr.contactScreenSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                  // Visitor Stats
                  Container(
                    width: 250,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildStatItem(tr.todayVisitor, todayVisits),
                        Container(
                          width: 1,
                          height: 30,
                          color: Colors.white30,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                        ),
                        _buildStatItem(tr.totalVisitor, totalVisits),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Contact Info Card
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, spreadRadius: 1)
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
            ),

            const SizedBox(height: 24),

            // Send Message Form
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryGreen, width: 1.5),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, spreadRadius: 1),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr.sendDirectMessage,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                      cursorColor: primaryGreen,
                      decoration: InputDecoration(
                        labelText: tr.yourNameLabel,
                        labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
                        floatingLabelStyle: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryGreen, width: 1.5),
                        ),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? tr.nameRequired : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                      cursorColor: primaryGreen,
                      decoration: InputDecoration(
                        labelText: tr.phoneNumberLabel,
                        labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
                        floatingLabelStyle: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryGreen, width: 1.5),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _subjectController,
                      style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                      cursorColor: primaryGreen,
                      decoration: InputDecoration(
                        labelText: tr.subjectLabel,
                        labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
                        floatingLabelStyle: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryGreen, width: 1.5),
                        ),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? tr.subjectRequired : null,
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _messageController,
                      maxLines: 4,
                      style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w500),
                      cursorColor: primaryGreen,
                      decoration: InputDecoration(
                        labelText: tr.messageLabel,
                        labelStyle: const TextStyle(color: Colors.black87, fontSize: 14),
                        floatingLabelStyle: TextStyle(color: primaryGreen, fontWeight: FontWeight.bold, fontSize: 14),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey[400]!, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: primaryGreen, width: 1.5),
                        ),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty ? tr.messageRequired : null,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitContact,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
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
                                tr.sendMessageBtn,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Footer
            const CustomFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
