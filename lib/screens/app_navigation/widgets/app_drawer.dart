import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/screens/app_navigation/widgets/drawer/drawer_footer_actions.dart';
import 'package:atmabdulbaridanny/screens/app_navigation/widgets/drawer/drawer_header_card.dart';
import 'package:atmabdulbaridanny/screens/app_navigation/widgets/drawer/drawer_nav_list.dart';
import 'package:atmabdulbaridanny/services/providers/api_providers.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBangla = ref.watch(isBanglaProvider);
    final userAsync = ref.watch(currentUserProvider);
    final isLoggedIn = userAsync.asData?.value != null && userAsync.asData?.value?.id != null;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          DrawerHeaderCard(isBangla: isBangla),
          Expanded(
            child: DrawerNavList(
              isLoggedIn: isLoggedIn,
              isBangla: isBangla,
            ),
          ),
          DrawerFooterActions(
            isLoggedIn: isLoggedIn,
            isBangla: isBangla,
          ),
        ],
      ),
    );
  }
}
