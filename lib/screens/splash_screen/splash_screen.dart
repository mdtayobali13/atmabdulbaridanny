import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';

import 'package:flutter_riverpod_template/services/storage/storage_services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    try {
      final token = await StorageServices.instance.getToken();
      if (token.isNotEmpty) {
        AppRoutes.instance.goNamed(AppRoutesKey.instance.homeScreen);
      } else {
        AppRoutes.instance.goNamed(AppRoutesKey.instance.signInScreen);
      }
    } catch (_) {
      AppRoutes.instance.goNamed(AppRoutesKey.instance.signInScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.instance.primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.gavel, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              "Barrister Kayser Kamal",
              style: TextStyle(
                color: AppColors.instance.goldenColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
