import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/screens/home_screen/widgets/custom_footer.dart';
import 'package:barristerkayserkamal/screens/profile_screen/widgets/guest_profile_view.dart';
import 'package:barristerkayserkamal/screens/profile_screen/widgets/profile_header_card.dart';
import 'package:barristerkayserkamal/screens/profile_screen/widgets/profile_menu_actions.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryGreen = AppColors.instance.primaryGreen;
    final userAsync = ref.watch(currentUserProvider);
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          tr.myAccount,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: primaryGreen,
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(currentUserProvider);
          ref.invalidate(websiteSettingProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              userAsync.when(
                data: (user) {
                  if (user == null || user.id == null) {
                    return GuestProfileView(
                      primaryColor: primaryGreen,
                      tr: tr,
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ProfileHeaderCard(
                          user: user,
                          primaryColor: primaryGreen,
                          isBangla: isBangla,
                        ),
                        const SizedBox(height: 20),
                        ProfileMenuActions(
                          user: user,
                          primaryColor: primaryGreen,
                          isBangla: isBangla,
                          tr: tr,
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 80),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (err, stack) => GuestProfileView(
                  primaryColor: primaryGreen,
                  tr: tr,
                ),
              ),
              const SizedBox(height: 20),
              const CustomFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
