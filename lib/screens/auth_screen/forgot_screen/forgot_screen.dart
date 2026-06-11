import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:flutter_riverpod_template/screens/auth_screen/forgot_screen/screens/forgot_screen_email_input_screen.dart';
import 'package:flutter_riverpod_template/screens/auth_screen/forgot_screen/screens/forgot_screen_otp_input_screen.dart';
import 'package:flutter_riverpod_template/screens/auth_screen/forgot_screen/screens/forgot_screen_password_input_screen.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  late TextEditingController emailTextEditingController;
  late GlobalKey<FormState> emailFormKey;
  late TextEditingController passwordTextEditingController;
  late TextEditingController confirmPasswordTextEditingController;
  late GlobalKey<FormState> passwordFormKey;
  late TextEditingController otpTextEditingController;
  late GlobalKey<FormState> otpFormKey;
  int selectedIndex = 0;

  void onChangedPage(int index) {
    try {
      if (mounted) {
        setState(() {
          selectedIndex = index;
        });
      }
    } catch (e) {
      errorLog("onChangedPage", e);
    }
  }

  void onAppInitial() {
    try {
      emailTextEditingController = .new();
      passwordTextEditingController = .new();
      confirmPasswordTextEditingController = .new();
      otpTextEditingController = .new();
      otpFormKey = .new();
      passwordFormKey = .new();
      emailFormKey = .new();
    } catch (e) {
      errorLog("onAppInitial", e);
    }
  }

  void onAppClose() {
    try {
      emailTextEditingController.dispose();
      passwordTextEditingController.dispose();
      confirmPasswordTextEditingController.dispose();
      otpTextEditingController.dispose();
    } catch (e) {
      errorLog("onAppClose", e);
    }
  }

  @override
  void initState() {
    onAppInitial();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    onAppClose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: selectedIndex,
          children: [
            ForgotScreenEmailInputScreen(onChange: onChangedPage, emailTextEditingController: emailTextEditingController, formKey: emailFormKey),
            ForgotScreenOtpInputScreen(onChange: onChangedPage, formKey: otpFormKey, otpTextEditingController: otpTextEditingController),
            ForgotScreenPasswordInputScreen(
              formKey: passwordFormKey,
              confirmPasswordTextEditingController: confirmPasswordTextEditingController,
              passwordTextEditingController: passwordTextEditingController,
            ),
          ],
        ),
      ),
    );
  }
}
