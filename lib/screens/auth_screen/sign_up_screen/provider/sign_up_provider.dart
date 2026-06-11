import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:flutter_riverpod_template/screens/auth_screen/sign_up_screen/provider/sign_up_provider_state.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';

final signUpProvider = StateNotifierProvider<_SignUpProvider, SignUpProviderState>((ref) => _SignUpProvider());

class _SignUpProvider extends StateNotifier<SignUpProviderState> {
  _SignUpProvider() : super(SignUpProviderState());

  void stateUpdate({
    final String? name,
    final String? email,
    final String? phoneNumber,
    final String? password,
    final String? confirmPassword,
    final String? idCardFrontendPart,
    final String? idCardBackendPart,
    final String? storeName,
    final String? storeBio,
    final String? storeAddress,
    final String? storePhoto,
    final String? kycDocument,
    final bool? isLoading,
    final bool? isCustomer,
  }) {
    try {
      if (mounted) {
        state = state.copyWith(
          name: name ?? state.name,
          email: email ?? state.email,
          phoneNumber: phoneNumber ?? state.phoneNumber,
          password: password ?? state.password,
          confirmPassword: confirmPassword ?? state.confirmPassword,
          idCardFrontendPart: idCardFrontendPart ?? state.idCardFrontendPart,
          idCardBackendPart: idCardBackendPart ?? state.idCardBackendPart,
          storeName: storeName ?? state.storeName,
          storeBio: storeBio ?? state.storeBio,
          storeAddress: storeAddress ?? state.storeAddress,
          storePhoto: storePhoto ?? state.storePhoto,
          kycDocument: kycDocument ?? state.kycDocument,
          isLoading: isLoading ?? state.isLoading,
          isCustomer: isCustomer ?? state.isCustomer,
        );
      }
    } catch (e) {
      errorLog("stateUpdate", e);
    }
  }

  void clearAll() {
    if (mounted) {
      state = SignUpProviderState(isCustomer: state.isCustomer);
    }
  }

  Future<void> customerSignUp({required GlobalKey<FormState> formKey}) async {
    try {
      if (!formKey.currentState!.validate()) return;

      if (state.isCustomer) {
        stateUpdate(isLoading: true);
        // bool success = await AuthRepository.instance.customerSignUp(
        //   fullName: state.name,
        //   email: state.email,
        //   phoneNumber: state.phoneNumber,
        //   password: state.password,
        //   frontImage: state.idCardFrontendPart,
        //   backImage: state.idCardBackendPart,
        // );
        stateUpdate(isLoading: false);
        // if (success) {
        // await StorageServices.instance.setEmail(state.email);
        // appLog("////////////////${state.email}");
        // AppSnackBar.instance.success(
        //   "Customer signup successful,\n Verify your account",
        // );

        // AppRoutes.instance.pushNamed(
        //   AppRoutesKey.instance.signUpVerifyScreen,
        // );
        //   clearAll();
        // }
      } else {
        // AppRoutes.instance.pushNamed(
        //   AppRoutesKey.instance.kycVerificationScreen,
        // );
      }
    } catch (e) {
      errorLog("customerSignUp provider", e);
      stateUpdate(isLoading: false);
    }
  }

  Future<void> vendorSignup() async {
    // try {
    //   stateUpdate(isLoading: true);

    //   bool success = await AuthRepository.instance.vendorSignUp(
    //     name: state.name,
    //     email: state.email,
    //     phoneNumber: state.phoneNumber,
    //     password: state.password,
    //     storeName: state.storeName,
    //     storeBio: state.storeBio,
    //     storeAddress: state.storeAddress,
    //     frontImage: state.idCardFrontendPart,
    //     backImage: state.idCardBackendPart,
    //     storePhoto: state.storePhoto,
    //     kycDocument: state.kycDocument,
    //   );
    //   stateUpdate(isLoading: false);
    //   if (success) {
    //     await StorageServices.instance.setEmail(state.email);
    //     AppSnackBar.instance.success(
    //       "Vendor signup successful,\n Verify your account",
    //     );

    //     AppRoutes.instance.pushNamed(AppRoutesKey.instance.signUpVerifyScreen);
    //     clearAll();
    //   } else {
    //     AppSnackBar.instance.error(" signup failed,\n Try again");
    //   }
    // } catch (e) {
    //   errorLog("vendor Signup", e);
    //   stateUpdate(isLoading: false);
    // }
  }
}
