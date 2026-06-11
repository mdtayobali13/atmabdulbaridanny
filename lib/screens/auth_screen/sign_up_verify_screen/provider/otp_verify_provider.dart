import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/services/repository/auth_repository.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';

final otpVerifyProvider = StateNotifierProvider<OtpVerifyProvider, bool>((ref) {
  return OtpVerifyProvider();
});

class OtpVerifyProvider extends StateNotifier<bool> {
  OtpVerifyProvider() : super(false);

  Future<bool> verifyOtp(String code) async {
    try {
      state = true;
      // String email = await StorageServices.instance.getEmail();
      String email = "";
      final response = await AuthRepository.instance.authOtpVerify(email: email, otp: int.parse(code));

      state = false;
      return response;
    } catch (e) {
      errorLog("verifyOtp", e);
      state = false;
      return false;
    }
  }

  Future<void> resendOtp() async {
    try {
      state = true;
      // String email = await StorageServices.instance.getEmail();
      String email = "";
      bool success = await AuthRepository.instance.authResendOTP(email: email);
      state = false;
      if (success) {
        AppSnackBar.instance.success("OTP has been resent successfully");
      } else {
        AppSnackBar.instance.error("Failed to resend OTP. Please try again.");
      }
    } catch (e) {
      errorLog("resendOtp", e);
      state = false;
    }
  }
}
