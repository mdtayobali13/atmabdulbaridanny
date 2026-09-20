import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/screens/app_navigation/widgets/app_drawer.dart';
import 'package:barristerkayserkamal/screens/contact_screen/widgets/contact_form_card.dart';
import 'package:barristerkayserkamal/screens/contact_screen/widgets/contact_header_banner.dart';
import 'package:barristerkayserkamal/screens/contact_screen/widgets/contact_info_card.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/custom_footer.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';
import 'package:barristerkayserkamal/services/repository/home_repository.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
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
  Widget build(BuildContext context) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final lightGreen = AppColors.instance.lightGreen;
    final setting = ref.watch(websiteSettingProvider).asData?.value;
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    final hasBengaliAddress = setting?.address != null &&
        RegExp(r'[\u0980-\u09FF]').hasMatch(setting!.address!);
    final address = (isBangla || !hasBengaliAddress) && setting?.address?.isNotEmpty == true
        ? setting!.address!
        : tr.parliamentAddress;

    final rawPhone = setting?.mobile ?? "01713046783";
    final phone = isBangla ? rawPhone.toBanglaDigits(true) : rawPhone;
    final email = setting?.email ?? "netrokona.1@parliament.gov.bd";

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ContactHeaderBanner(
              primaryGreen: primaryGreen,
              tr: tr,
              visitStats: _visitStats,
              isBangla: isBangla,
            ),
            const SizedBox(height: 24),
            ContactInfoCard(
              primaryGreen: primaryGreen,
              lightGreen: lightGreen,
              address: address,
              phone: phone,
              email: email,
              tr: tr,
            ),
            const SizedBox(height: 24),
            ContactFormCard(
              primaryGreen: primaryGreen,
              tr: tr,
            ),
            const SizedBox(height: 32),
            const CustomFooter(),
          ],
        ),
      ),
    );
  }
}
