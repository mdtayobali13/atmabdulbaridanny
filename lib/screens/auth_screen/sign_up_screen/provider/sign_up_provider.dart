import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:atmabdulbaridanny/screens/auth_screen/sign_up_screen/provider/sign_up_provider_state.dart';
import 'package:atmabdulbaridanny/services/repository/auth_repository.dart';
import 'package:atmabdulbaridanny/utils/app_log.dart';

final signUpProvider = StateNotifierProvider<_SignUpProvider, SignUpProviderState>((ref) => _SignUpProvider());

class _SignUpProvider extends StateNotifier<SignUpProviderState> {
  _SignUpProvider() : super(const SignUpProviderState());

  void stateUpdate({
    final String? name,
    final String? email,
    final String? phoneNumber,
    final String? password,
    final String? confirmPassword,
    final bool? isLoading,
  }) {
    try {
      if (mounted) {
        state = state.copyWith(
          name: name ?? state.name,
          email: email ?? state.email,
          phoneNumber: phoneNumber ?? state.phoneNumber,
          password: password ?? state.password,
          confirmPassword: confirmPassword ?? state.confirmPassword,
          isLoading: isLoading ?? state.isLoading,
        );
      }
    } catch (e) {
      errorLog("stateUpdate", e);
    }
  }

  void clearAll() {
    if (mounted) {
      state = const SignUpProviderState();
    }
  }

  Future<bool> register({required GlobalKey<FormState> formKey}) async {
    try {
      if (!formKey.currentState!.validate()) return false;

      stateUpdate(isLoading: true);
      final success = await AuthRepository.instance.register(
        name: state.name,
        email: state.email,
        password: state.password,
      );
      stateUpdate(isLoading: false);
      return success;
    } catch (e) {
      errorLog("register provider error", e);
      stateUpdate(isLoading: false);
      return false;
    }
  }

  // Alias for backward compatibility
  Future<bool> customerSignUp({required GlobalKey<FormState> formKey}) => register(formKey: formKey);
}
