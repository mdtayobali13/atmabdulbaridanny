import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/routes/app_routes.dart';
import 'package:atmabdulbaridanny/routes/app_routes_key.dart';
import 'package:atmabdulbaridanny/screens/splash_screen/widgets/profile_identity_card.dart';
import 'package:atmabdulbaridanny/utils/languages/language_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    Future.delayed(const Duration(milliseconds: 7000), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    if (_navigated || !mounted) return;
    _navigated = true;
    AppRoutes.instance.goNamed(AppRoutesKey.instance.homeScreen);
  }

  @override
  Widget build(BuildContext context) {
    final isBangla = ref.watch(isBanglaProvider);
    final primaryGreen = AppColors.instance.primaryGreen;
    final goldenColor = AppColors.instance.goldenColor;

    return Scaffold(
      backgroundColor: const Color(0xFF023620),
      body: GestureDetector(
        onTap: _navigateToHome,
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF023821),
                primaryGreen,
                const Color(0xFF032214),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Top subtle skip button
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 10.0),
                    child: GestureDetector(
                      onTap: _navigateToHome,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.18),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              isBangla ? "এড়িয়ে যান" : "Skip",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 3),
                            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white70, size: 9),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Centered Profile Identity Card
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: const ProfileIdentityCard(),
                      ),
                    ),
                  ),
                ),

                // Bottom Slogan & Minimal Elegant Progress Bar
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0, top: 8.0, left: 16.0, right: 16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 11),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: goldenColor.withValues(alpha: 0.85),
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: goldenColor.withValues(alpha: 0.25),
                              blurRadius: 18,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Text(
                          "সবার আগে বাংলাদেশ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: goldenColor,
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.8,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.8),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: 44,
                        height: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            backgroundColor: goldenColor.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(goldenColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
