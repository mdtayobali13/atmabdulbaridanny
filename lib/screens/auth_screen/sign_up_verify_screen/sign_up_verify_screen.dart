import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/screens/auth_screen/sign_up_screen/provider/sign_up_provider.dart';
import 'package:flutter_riverpod_template/screens/auth_screen/sign_up_verify_screen/provider/otp_verify_provider.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/app_snack_bar.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';

import '../../../constant/app_asserts_image_path.dart';
import '../../../routes/app_routes.dart';
import '../../../routes/app_routes_key.dart';
import '../../../widgets/app_image/app_image.dart';
import '../../../widgets/texts/app_text.dart';

class SignUpVerifyScreen extends ConsumerStatefulWidget {
  const SignUpVerifyScreen({super.key});

  @override
  ConsumerState<SignUpVerifyScreen> createState() => _SignUpVerifyScreenState();
}

class _SignUpVerifyScreenState extends ConsumerState<SignUpVerifyScreen> {
  late TextEditingController otpController;
  late GlobalKey<FormState> formKey;

  void onAppInitial() {
    try {
      otpController = TextEditingController();
      formKey = GlobalKey<FormState>();
    } catch (e) {
      errorLog("onAppInitial", e);
    }
  }

  void onAppClose() {
    otpController.dispose();
  }

  @override
  void initState() {
    super.initState();
    onAppInitial();
  }

  @override
  void dispose() {
    onAppClose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(otpVerifyProvider);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(
                  width: AppSize.size.width * 0.8,
                  height: AppSize.size.height * 0.14,
                  child: Center(
                    child: AppImage(width: AppSize.size.width * 0.8, path: AppAssertsImagePath.instance.logo),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(
                  width: AppSize.size.width * 0.8,
                  child: AppText(
                    text: "Sent to code your Gmail\n**@gmail.com",
                    textAlign: TextAlign.center,

                    fontWeight: FontWeight.w500,
                    height: 1.5,
                    fontSize: AppSize.width(value: 18),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: AppInputWidgetTwo(
                  controller: otpController,
                  validator: (String? value) {
                    if (value?.isEmpty ?? true) {
                      return "Enter Otp";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  title: "Code",
                  hintText: "* * * * *",
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(right: 25, top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      AppText(text: "If you didn't receive a code"),
                      Gap(width: AppSize.size.width * 0.021),
                      GestureDetector(
                        onTap: () {
                          ref.read(otpVerifyProvider.notifier).resendOtp();
                        },
                        child: AppText(text: "Resend", fontSize: AppSize.size.width * 0.04, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.04, vertical: AppSize.size.width * 0.04),
                  child: AppButton(
                    onTap: isLoading
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              final isSuccess = await ref.read(otpVerifyProvider.notifier).verifyOtp(otpController.text.trim());
                              if (isSuccess) {
                                AppSnackBar.instance.success("Verified successfully!");
                                final provider = ref.read(signUpProvider);
                                if (provider.isCustomer) {
                                  AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
                                } else {
                                  // AppRoutes.instance.go(
                                  //   AppRoutesKey
                                  //       .instance
                                  //       .verificationInProgressScreen,
                                  // );
                                }
                              } else {
                                AppSnackBar.instance.error("Invalid OTP");
                              }
                            }
                          },
                    isLoading: isLoading,
                    title: "Verify",
                    height: AppSize.size.height * 0.06,
                    backgroundColor: AppColors.instance.success,
                    borderColor: AppColors.instance.success,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
