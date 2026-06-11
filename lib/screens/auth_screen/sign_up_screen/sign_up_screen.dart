import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_asserts_image_path.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/screens/auth_screen/sign_up_screen/provider/sign_up_provider.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:flutter_riverpod_template/utils/app_size.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/app_image/app_image.dart';
import 'package:flutter_riverpod_template/widgets/buttons/app_button.dart';
import 'package:flutter_riverpod_template/widgets/image_userPick/image_user_pick.dart';
import 'package:flutter_riverpod_template/widgets/inputs/app_input_widget_tow.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';
import '../../../routes/app_routes_key.dart';
import '../../../widgets/inputs/app_input_widget.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  late GlobalKey<FormState> formKey;
  late TextEditingController nameTextEditingController;
  late TextEditingController emailTextEditingController;
  late TextEditingController phoneNumberTextEditingController;
  late TextEditingController passwordTextEditingController;
  late TextEditingController confirmPasswordTextEditingController;
  late TextEditingController storeNameTextEditingController;
  late TextEditingController storeBioTextEditingController;
  late TextEditingController storeAddressTextEditingController;
  late TextEditingController storeImageController;

  late TextEditingController fontImageController;
  late TextEditingController backImageController;

  void onAppInitial() {
    try {
      nameTextEditingController = TextEditingController();
      emailTextEditingController = TextEditingController();
      phoneNumberTextEditingController = TextEditingController();
      passwordTextEditingController = TextEditingController();
      confirmPasswordTextEditingController = TextEditingController();
      storeNameTextEditingController = TextEditingController();
      storeBioTextEditingController = TextEditingController();
      storeAddressTextEditingController = TextEditingController();
      fontImageController = TextEditingController();
      backImageController = TextEditingController();
      storeImageController = TextEditingController();
      var provider = ref.read(signUpProvider);
      nameTextEditingController.text = provider.name;
      emailTextEditingController.text = provider.email;
      phoneNumberTextEditingController.text = provider.phoneNumber;
      passwordTextEditingController.text = provider.password;
      confirmPasswordTextEditingController.text = provider.confirmPassword;
      fontImageController.text = provider.idCardFrontendPart;
      backImageController.text = provider.idCardBackendPart;
      storeNameTextEditingController.text = provider.storeName;
      storeBioTextEditingController.text = provider.storeBio;
      storeAddressTextEditingController.text = provider.storeAddress;
      storeImageController.text = provider.storePhoto;
      formKey = GlobalKey<FormState>();
    } catch (e) {
      errorLog("onAppInitial", e);
    }
  }

  void onAppClose() {
    try {
      nameTextEditingController.dispose();
      emailTextEditingController.dispose();
      phoneNumberTextEditingController.dispose();
      passwordTextEditingController.dispose();
      confirmPasswordTextEditingController.dispose();
      fontImageController.dispose();
      backImageController.dispose();
      storeAddressTextEditingController.dispose();
      storeBioTextEditingController.dispose();
      storeNameTextEditingController.dispose();
      storeImageController.dispose();
    } catch (e) {
      errorLog("onAppClose", e);
    }
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
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: AppSize.size.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20)),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      text: "Welcome back! Create your account.",
                      textAlign: TextAlign.center,

                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      fontSize: AppSize.width(value: 18),
                    ),
                  ),
                  Gap(height: 20),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: AppText(
                      text: "Sign up as",
                      textAlign: TextAlign.start,

                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      fontSize: AppSize.width(value: 18),
                    ),
                  ),
                  Gap(height: 20),
                  Consumer(
                    builder: (context, ref, child) {
                      final isCustomer = ref.watch(signUpProvider.select((p) => p.isCustomer));
                      return Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                ref.read(signUpProvider.notifier).stateUpdate(isCustomer: true);
                              },
                              overlayColor: WidgetStatePropertyAll(Colors.transparent),
                              child: AnimatedContainer(
                                duration: Durations.long1,
                                padding: EdgeInsets.all(AppSize.width(value: 10)),
                                decoration: BoxDecoration(
                                  color: isCustomer ? AppColors.instance.success : AppColors.instance.white100,
                                  border: Border.all(color: isCustomer ? AppColors.instance.success : AppColors.instance.dark300),
                                  borderRadius: BorderRadius.circular(AppSize.width(value: 10)),
                                ),
                                alignment: Alignment.center,
                                child: AppText(
                                  text: "Customer",
                                  color: isCustomer ? AppColors.instance.white50 : AppColors.instance.dark500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          Gap(width: 20),
                          Expanded(
                            child: InkWell(
                              onTap: () async {
                                ref.read(signUpProvider.notifier).stateUpdate(isCustomer: false);
                              },
                              overlayColor: WidgetStatePropertyAll(Colors.transparent),
                              child: AnimatedContainer(
                                duration: Durations.long1,
                                padding: EdgeInsets.all(AppSize.width(value: 10)),
                                decoration: BoxDecoration(
                                  color: !isCustomer ? AppColors.instance.success : AppColors.instance.white100,
                                  border: Border.all(color: !isCustomer ? AppColors.instance.success : AppColors.instance.dark300),
                                  borderRadius: BorderRadius.circular(AppSize.width(value: 10)),
                                ),
                                alignment: Alignment.center,
                                child: AppText(
                                  text: "Vendor",
                                  color: !isCustomer ? AppColors.instance.white50 : AppColors.instance.dark500,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Gap(height: 10),
                  AppInputWidgetTwo(
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your name";
                      }
                      return null;
                    },
                    title: "Name",
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    controller: nameTextEditingController,
                    onChanged: (v) {
                      ref.read(signUpProvider.notifier).stateUpdate(name: v);
                    },
                    hintText: "Enter your name",
                  ),
                  AppInputWidgetTwo(
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Enter your email";
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                    title: "Email",
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    isEmail: true,
                    controller: emailTextEditingController,
                    onChanged: (v) {
                      ref.read(signUpProvider.notifier).stateUpdate(email: v);
                    },
                    hintText: "Enter your email",
                  ),
                  AppInputWidgetTwo(
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your phone number";
                      }
                      return null;
                    },
                    title: "Phone Number",
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    controller: phoneNumberTextEditingController,
                    onChanged: (v) {
                      ref.read(signUpProvider.notifier).stateUpdate(phoneNumber: v);
                    },
                    hintText: "Enter your phone number",
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final isCustomer = ref.watch(signUpProvider.select((p) => p.isCustomer));
                      if (!isCustomer) {
                        return Column(
                          children: [
                            AppInputWidgetTwo(
                              controller: storeNameTextEditingController,
                              title: "Store Name",
                              onChanged: (v) {
                                ref.read(signUpProvider.notifier).stateUpdate(storeName: v);
                              },
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return " enter your store name";
                                }
                                return null;
                              },
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              // controller: phoneNumberTextEditingController,
                              hintText: "Enter store name",
                            ),
                            AppInputWidgetTwo(
                              controller: storeBioTextEditingController,
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return " enter your store Bio";
                                }
                                return null;
                              },
                              title: "Store Bio",
                              onChanged: (v) {
                                ref.read(signUpProvider.notifier).stateUpdate(storeBio: v);
                              },
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              // controller: phoneNumberTextEditingController,
                              hintText: "Enter store bio",
                            ),
                            AppInputWidgetTwo(
                              controller: storeAddressTextEditingController,
                              validator: (String? value) {
                                if (value?.isEmpty ?? true) {
                                  return " enter your store address";
                                }
                                return null;
                              },
                              onChanged: (v) {
                                ref.read(signUpProvider.notifier).stateUpdate(storeAddress: v);
                              },
                              title: "Store Address",
                              padding: EdgeInsets.symmetric(horizontal: 0),
                              // controller: phoneNumberTextEditingController,
                              hintText: "Enter store address",
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 2,
                        child: AppInputWidgetTwo(
                          maxLines: 1,
                          controller: fontImageController,
                          readOnly: true,
                          onTap: () {
                            appImageUserTake(
                              callBack: (v) {
                                ref.read(signUpProvider.notifier).stateUpdate(idCardFrontendPart: v);
                                fontImageController.text = v;
                              },
                            );
                          },
                          validator: (String? value) {
                            if (value?.isEmpty ?? true) {
                              return "Enter your image";
                            }
                            return null;
                          },
                          title: "Resident Card",
                          hintText: "Upload font side photo",
                          padding: EdgeInsets.symmetric(horizontal: 0),
                        ),
                      ),
                      Gap(width: AppSize.size.width * 0.02),
                      Expanded(
                        flex: 1,
                        child: AppButton(
                          onTap: () {
                            appImageUserTake(
                              callBack: (v) {
                                ref.read(signUpProvider.notifier).stateUpdate(idCardFrontendPart: v);
                                fontImageController.text = v;
                              },
                            );
                          },
                          height: AppSize.size.width * 0.13,
                          backgroundColor: AppColors.instance.success,
                          borderColor: AppColors.instance.success,
                          title: "Upload",
                        ),
                      ),
                    ],
                  ),
                  Gap(height: AppSize.size.width * 0.015),
                  Consumer(
                    builder: (context, ref, child) {
                      final backImage = ref.watch(signUpProvider.select((p) => p.idCardBackendPart));
                      return Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: AppInputWidget(
                              maxLines: 1,
                              controller: backImageController,
                              readOnly: true,
                              onTap: () {
                                appImageUserTake(
                                  callBack: (v) {
                                    ref.read(signUpProvider.notifier).stateUpdate(idCardBackendPart: v);
                                  },
                                );
                              },
                              validator: (String? value) {
                                if (backImage.isEmpty) {
                                  return "Enter your image";
                                }
                                return null;
                              },
                              borderColor: AppColors.instance.success,
                              hintText: backImage.isEmpty ? "Upload back side photo" : backImage.split("/").last,
                            ),
                          ),
                          Gap(width: AppSize.size.width * 0.02),
                          Expanded(
                            flex: 1,
                            child: AppButton(
                              onTap: () {
                                appImageUserTake(
                                  callBack: (v) {
                                    ref.read(signUpProvider.notifier).stateUpdate(idCardBackendPart: v);
                                  },
                                );
                              },
                              height: AppSize.size.width * 0.13,
                              backgroundColor: AppColors.instance.success,
                              borderColor: AppColors.instance.success,
                              title: "Upload",
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      final isCustomer = ref.watch(signUpProvider.select((p) => p.isCustomer));
                      final storePhoto = ref.watch(signUpProvider.select((p) => p.storePhoto));
                      if (!isCustomer) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              flex: 2,
                              child: AppInputWidgetTwo(
                                maxLines: 1,
                                controller: storeImageController,
                                readOnly: true,
                                onTap: () {
                                  appImageUserTake(
                                    callBack: (v) {
                                      ref.read(signUpProvider.notifier).stateUpdate(storePhoto: v);
                                    },
                                  );
                                },
                                validator: (String? value) {
                                  if (storePhoto.isEmpty) {
                                    return "Enter your image";
                                  }
                                  return null;
                                },
                                title: "Store Photo",
                                hintText: storePhoto.isEmpty ? "Upload store photo" : storePhoto.split("/").last,
                                padding: EdgeInsets.symmetric(horizontal: 0),
                              ),
                            ),
                            Gap(width: AppSize.size.width * 0.02),
                            Expanded(
                              flex: 1,
                              child: AppButton(
                                onTap: () {
                                  appImageUserTake(
                                    callBack: (v) {
                                      ref.read(signUpProvider.notifier).stateUpdate(storePhoto: v);
                                    },
                                  );
                                },
                                height: AppSize.size.width * 0.13,
                                backgroundColor: AppColors.instance.success,
                                borderColor: AppColors.instance.success,
                                title: "Upload",
                              ),
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  AppInputWidgetTwo(
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your password";
                      }
                      if (value!.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                    title: "Password",
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    isPassWord: true,
                    controller: passwordTextEditingController,
                    onChanged: (v) {
                      ref.read(signUpProvider.notifier).stateUpdate(password: v);
                    },
                    hintText: "Enter your password",
                  ),
                  AppInputWidgetTwo(
                    validator: (String? value) {
                      if (value?.isEmpty ?? true) {
                        return "Enter your password";
                      }
                      if (value!.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      if (value != passwordTextEditingController.text) {
                        return "Password not matching";
                      }
                      return null;
                    },
                    title: "Confirm Password",
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    isPassWord: true,
                    controller: confirmPasswordTextEditingController,
                    hintText: "Enter Confirm Password",
                  ),
                  Gap(height: 20),
                  Consumer(
                    builder: (context, ref, child) {
                      final isLoading = ref.watch(signUpProvider.select((p) => p.isLoading));
                      return AppButton(
                        onTap: () async {
                          await ref.read(signUpProvider.notifier).customerSignUp(formKey: formKey);
                        },
                        isLoading: isLoading,
                        backgroundColor: AppColors.instance.success,
                        borderColor: AppColors.instance.success,
                        title: "Create Account",
                        padding: EdgeInsets.all(AppSize.width(value: 10)),
                      );
                    },
                  ),
                  Gap(height: 15),
                  Center(
                    child: Wrap(
                      children: [
                        AppText(text: "Already have an account?"),
                        Gap(width: 10),
                        InkWell(
                          onTap: () {
                            AppRoutes.instance.go(AppRoutesKey.instance.signInScreen);
                          },
                          overlayColor: WidgetStatePropertyAll(Colors.transparent),
                          child: AppText(text: "Sign In", fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  Gap(height: 70),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
