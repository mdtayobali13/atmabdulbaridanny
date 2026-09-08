import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/app_navigation/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter_riverpod_template/screens/app_navigation/widgets/app_drawer.dart';
import 'package:go_router/go_router.dart';

class AppNavigationScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavigationScreen({super.key, required this.navigationShell});

  void _onTap(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.toString();
    final hideGlobalAppBar = currentRoute.contains('news_detail_screen') || 
                             currentRoute.contains('contact_screen') || 
                             currentRoute.contains('appointment_screen');

    return Scaffold(
      backgroundColor: AppColors.instance.primaryGreen,
      appBar: hideGlobalAppBar ? null : AppBar(
        backgroundColor: AppColors.instance.primaryGreen,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: Icon(Icons.gavel, color: AppColors.instance.primaryGreen, size: 20),
            ),
            const SizedBox(width: 10),
            const Text(
              "Barrister Kayser Kamal",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: navigationShell,
      bottomNavigationBar: CustomBottomNavBar(currentIndex: navigationShell.currentIndex, onTap: _onTap),
    );
  }
}
