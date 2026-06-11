import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

import '../../../../../services/repository/auth_repository.dart';

final forgotPasswordProvider = StateNotifierProvider<ForgotPasswordProvider, bool>((ref) {
  return ForgotPasswordProvider();
});

class ForgotPasswordProvider extends StateNotifier<bool> {
  ForgotPasswordProvider() : super(false);

  Future forgotPassword({required String email}) async {
    try {
      state = true;
      final response = await AuthRepository.instance.forgotPassword(email: email);
      state = false;
      return response;
    } catch (e) {
      errorLog("email verification", e);
      state = false;
      return false;
    }
  }
}
