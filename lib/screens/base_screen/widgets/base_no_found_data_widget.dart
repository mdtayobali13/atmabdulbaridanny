import 'package:flutter/material.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/utils/app_size.dart';
import 'package:atmabdulbaridanny/widgets/app_image/app_image.dart';

class BaseNoFoundDataWidget extends StatelessWidget {
  const BaseNoFoundDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: AppSize.width(value: 20.0)),
      padding: EdgeInsets.symmetric(horizontal: AppSize.width(value: 20.0), vertical: AppSize.width(value: 20.0)),
      width: AppSize.size.width,
      height: AppSize.size.height,
      decoration: BoxDecoration(
        color: AppColors.instance.white50,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(AppSize.width(value: 20.0)), topRight: Radius.circular(AppSize.width(value: 20.0))),
      ),
      child: Center(
        child: AppImage(width: AppSize.size.width * 0.5, height: AppSize.size.width * 0.5, fit: BoxFit.contain, path: "assets/images/not_found.webp"),
      ),
    );
  }
}
