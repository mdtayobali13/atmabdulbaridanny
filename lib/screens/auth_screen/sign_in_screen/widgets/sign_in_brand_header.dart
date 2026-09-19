import 'package:flutter/material.dart';
import 'package:barristerkayserkamal/constant/app_asserts_image_path.dart';
import 'package:barristerkayserkamal/constant/app_colors.dart';
import 'package:barristerkayserkamal/utils/gap.dart';

class SignInBrandHeader extends StatelessWidget {
  const SignInBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 90,
          height: 90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.instance.goldenColor,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.instance.primaryGreen.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: AppColors.instance.goldenColor.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.asset(
              AppAssertsImagePath.instance.barristerKayserKamal,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const Gap(height: 16),
        Text(
          "Barrister Kayser Kamal",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppColors.instance.primaryGreen,
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        const Gap(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.instance.goldenColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.instance.goldenColor.withValues(alpha: 0.4),
              width: 1,
            ),
          ),
          child: Text(
            "Advocate, Supreme Court of Bangladesh",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.instance.goldenColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
