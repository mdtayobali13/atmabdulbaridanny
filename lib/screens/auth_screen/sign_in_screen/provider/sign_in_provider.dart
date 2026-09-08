import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/services/repository/auth_repository.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

final signInProvider = StateNotifierProvider<_SignInProvider, bool>((ref) {
  return _SignInProvider();
});

class _SignInProvider extends StateNotifier<bool> {
  _SignInProvider() : super(false);

  Future<bool> signIn(String email, String password) async {
    try {
      state = true;
      final response = await AuthRepository.instance.login(
        email: email,
        password: password,
        fcmToken: "",
        deviceId: "",
      );
      state = false;
      return response;
    } catch (e) {
      errorLog("Login", e);
      state = false;
      return false;
    }
  }
}
