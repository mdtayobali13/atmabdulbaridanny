import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/constant/app_constant.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import 'package:flutter_riverpod_template/screens/auth_screen/forgot_screen/screens/provider/forgot_reset_password_provider.dart';

class ForgotScreenPasswordInputScreen extends ConsumerWidget {
  const ForgotScreenPasswordInputScreen({
    super.key,
    required this.formKey,
    required this.confirmPasswordTextEditingController,
    required this.passwordTextEditingController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController passwordTextEditingController;
  final TextEditingController confirmPasswordTextEditingController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(forgotResetPasswordProvider);

    return SizedBox(
      width: AppSize.size.width,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                width: AppSize.size.width * 0.8,
                height: AppSize.size.height * 0.14,
                child: Center(
                  child: AppImage(width: AppSize.size.width * 0.8, path: AppAssertsImagePath.instance.logo),
                ),
              ),

              SizedBox(
                width: AppSize.size.width * 0.8,
                child: AppText(
                  text: "New password",
                  textAlign: TextAlign.center,
                  fontFamily: AppConstant.instance.fontFamilyPoppins,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  fontSize: AppSize.width(value: 18),
                ),
              ),
              AppInputWidgetTwo(
                title: "Password",
                isPassWord: true,
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                controller: passwordTextEditingController,
                textInputAction: TextInputAction.next,
              ),

              AppInputWidgetTwo(
                title: "Confirm Password",
                isPassWord: true,
                isPassWordSecondValidation: true,
                isPassWordSecondValidationController: passwordTextEditingController,
                maxLines: 1,
                keyboardType: TextInputType.visiblePassword,
                controller: confirmPasswordTextEditingController,
                textInputAction: TextInputAction.next,
              ),

              Gap(height: 25),
              AppButton(
                onTap: () {
                  ref
                      .read(forgotResetPasswordProvider.notifier)
                      .resetPassword(
                        formKey: formKey,
                        passwordController: passwordTextEditingController,
                        confirmPasswordController: confirmPasswordTextEditingController,
                      );
                },
                isLoading: isLoading,
                backgroundColor: AppColors.instance.success,
                borderColor: AppColors.instance.success,
                title: "Save & Update",
                margin: EdgeInsetsDirectional.symmetric(horizontal: AppSize.width(value: 20)),
                padding: EdgeInsets.all(AppSize.width(value: 8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
