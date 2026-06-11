import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/screens/auth_screen/on_board_screen/screens/onboard_language_screen.dart';
import 'package:flutter_riverpod_template/screens/auth_screen/on_board_screen/screens/onboard_splash_screen.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({super.key});

  @override
  State<OnBoardScreen> createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  int pageIndex = 0;
  void onPageChange() {
    setState(() {
      pageIndex = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: [
          OnboardSplashScreen(getStart: onPageChange),
          OnboardLanguageScreen(),
        ],
      ),
    );
  }
}
