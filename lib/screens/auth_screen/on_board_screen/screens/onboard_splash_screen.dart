import 'package:flutter/material.dart';
import 'package:atmabdulbaridanny/constant/app_asserts_image_path.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/utils/app_size.dart';
import 'package:atmabdulbaridanny/utils/gap.dart';
import 'package:atmabdulbaridanny/widgets/app_image/app_image.dart';
import 'package:atmabdulbaridanny/widgets/buttons/app_button.dart';
import 'package:atmabdulbaridanny/widgets/texts/app_text.dart';

class OnboardSplashScreen extends StatelessWidget {
  const OnboardSplashScreen({super.key, required this.getStart});
  final void Function() getStart;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: AppSize.size.width,
        height: AppSize.size.height,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              SizedBox(
                width: AppSize.size.width,
                height: AppSize.size.height * 0.14,
                child: Center(
                  child: AppImage(width: AppSize.size.width * 0.8, path: AppAssertsImagePath.instance.logo),
                ),
              ),

              SizedBox(
                width: AppSize.size.width,
                height: AppSize.size.height * 0.55,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentGeometry.center,
                  child: Column(
                    spacing: AppSize.size.height * 0.05,
                    children: [
                      AppImage(path: AppAssertsImagePath.instance.logo, height: AppSize.size.height * 0.4, width: AppSize.size.width * 0.8),
                      Gap(height: 5),
                      SizedBox(
                        width: AppSize.size.width,
                        child: AppText(
                          text: "EVERYTHING YOU NEED,ONE TRUSTED APP",
                          fontSize: AppSize.size.width * 0.075,
                          height: 1.5,
                          textAlign: TextAlign.center,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: AppSize.size.width,
                        child: AppText(
                          text: "Discover products, connect with verified vendors, and enjoy seamless ordering in one place.",
                          fontSize: AppSize.size.width * 0.05,
                          height: 1.5,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(
                width: AppSize.size.width,
                height: AppSize.size.height * 0.2,
                child: Center(
                  child: AppButton(
                    onTap: getStart,
                    title: "Get Start",
                    height: AppSize.size.width * 0.15,
                    backgroundColor: AppColors.instance.success,
                    borderColor: AppColors.instance.success,
                    loaderColor: AppColors.instance.white50,
                    margin: EdgeInsets.symmetric(horizontal: AppSize.size.width * 0.1),
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
