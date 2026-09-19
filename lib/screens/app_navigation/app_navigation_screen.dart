import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/constant/app_asserts_image_path.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/screens/app_navigation/widgets/custom_bottom_nav_bar.dart';
import 'package:barristerkayserkamal/screens/app_navigation/widgets/app_drawer.dart';
import 'package:barristerkayserkamal/utils/languages/language_provider.dart';
import 'package:go_router/go_router.dart';

class AppNavigationScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigationScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<AppNavigationScreen> createState() => _AppNavigationScreenState();
}

class _AppNavigationScreenState extends ConsumerState<AppNavigationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onTap(int index) {
    if (_scaffoldKey.currentState?.isDrawerOpen ?? false) {
      _scaffoldKey.currentState?.closeDrawer();
    }
    widget.navigationShell.goBranch(index, initialLocation: index == widget.navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = ref.watch(isBanglaProvider);
    final tr = AppTranslations.of(isBangla);
    final currentRoute = GoRouterState.of(context).uri.toString();
    final hideGlobalAppBar = currentRoute.contains('news_detail_screen') || 
                             currentRoute.contains('contact_screen') || 
                             currentRoute.contains('appointment_screen');

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.instance.primaryGreen,
      appBar: hideGlobalAppBar ? null : AppBar(
        backgroundColor: AppColors.instance.primaryGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 16,
                backgroundImage: AssetImage(AppAssertsImagePath.instance.barristerKayserKamal),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              tr.appTitle,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: widget.navigationShell,
      bottomNavigationBar: CustomBottomNavBar(currentIndex: widget.navigationShell.currentIndex, onTap: _onTap),
    );
  }
}
