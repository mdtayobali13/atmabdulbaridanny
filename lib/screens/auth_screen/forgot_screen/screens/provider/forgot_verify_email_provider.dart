import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/services/repository/auth_repository.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';

final forgotVerifyEmailProvider = StateNotifierProvider<ForgotVerifyEmailProvider, bool>((ref) {
  return ForgotVerifyEmailProvider();
});

class ForgotVerifyEmailProvider extends StateNotifier<bool> {
  ForgotVerifyEmailProvider() : super(false);

  Future<void> verifyEmail({
    required GlobalKey<FormState> formKey,
    required TextEditingController otpController,
    required void Function(int index) onChange,
  }) async {
    try {
      if (formKey.currentState!.validate()) {
        state = true;

        String email = "";
        // String email = await StorageServices.instance.getEmail();
        String otp = otpController.text.trim().replaceAll(RegExp(r'\D'), '');

        String token = await AuthRepository.instance.forgotVerifyEmail(email: email, otp: int.parse(otp));

        state = false;

        if (token.isNotEmpty) {
          // await StorageServices.instance.setResetToken(token);
          AppSnackBar.instance.success("OTP Verification successful");
          onChange(2);
        } else {
          AppSnackBar.instance.error("Verification failed or OTP is incorrect.");
        }
      }
    } catch (e) {
      errorLog("verifyEmail provider", e);
      state = false;
    }
  }

  Future<void> resendOtp() async {
    try {
      state = true;
      // String email = await StorageServices.instance.getEmail();
      String email = "";
      bool success = await AuthRepository.instance.forgotPassword(email: email);
      state = false;
      if (success) {
        AppSnackBar.instance.success("OTP has been resent successfully");
      } else {
        AppSnackBar.instance.error("Failed to resend OTP. Please try again.");
      }
    } catch (e) {
      errorLog("resendOtp provider", e);
      state = false;
    }
  }
}
