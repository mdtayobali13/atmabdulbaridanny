import 'package:flutter/material.dart';
import 'package:atmabdulbaridanny/constant/app_colors.dart';
import 'package:atmabdulbaridanny/utils/gap.dart';
import 'package:atmabdulbaridanny/widgets/texts/app_text.dart';

class SignInFormCard extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final bool isLoading;
  final VoidCallback onLogin;

  const SignInFormCard({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.isLoading,
    required this.onLogin,
  });

  @override
  State<SignInFormCard> createState() => _SignInFormCardState();
}

class _SignInFormCardState extends State<SignInFormCard> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: AppColors.instance.primaryGreen.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: AppColors.instance.primaryGreen.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppText(
            text: "Sign In",
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111518),
          ),
          const Gap(height: 6),
          AppText(
            text: "Access your account and explore services",
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
          const Gap(height: 24),

          // Email Field
          const AppText(
            text: "Email Address",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
          const Gap(height: 8),
          TextFormField(
            controller: widget.emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111518),
            ),
            decoration: _inputDecoration(
              hint: "example@mail.com",
              icon: Icons.alternate_email_rounded,
            ),
          ),

          const Gap(height: 18),

          // Password Field
          const AppText(
            text: "Password",
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF222222),
          ),
          const Gap(height: 8),
          TextFormField(
            controller: widget.passwordController,
            obscureText: _obscurePassword,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => widget.onLogin(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF111518),
            ),
            decoration: InputDecoration(
              hintText: "Enter your password",
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Icon(
                Icons.lock_outline_rounded,
                color: AppColors.instance.primaryGreen.withValues(alpha: 0.8),
                size: 20,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              ),
              filled: true,
              fillColor: const Color(0xFFF9FAFB),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade200),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.instance.primaryGreen, width: 1.6),
              ),
            ),
          ),

          const Gap(height: 14),

          // Remember Me
          InkWell(
            onTap: () => widget.onRememberMeChanged(!widget.rememberMe),
            borderRadius: BorderRadius.circular(6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: widget.rememberMe,
                    activeColor: AppColors.instance.primaryGreen,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (val) => widget.onRememberMeChanged(val ?? false),
                  ),
                ),
                const Gap(width: 6),
                AppText(
                  text: "Remember me",
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),

          const Gap(height: 24),

          // Login Submit Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoading ? null : widget.onLogin,
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: widget.isLoading
                        ? [
                            AppColors.instance.primaryGreen.withValues(alpha: 0.6),
                            AppColors.instance.lightGreen.withValues(alpha: 0.6),
                          ]
                        : [
                            AppColors.instance.primaryGreen,
                            AppColors.instance.lightGreen,
                          ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    if (!widget.isLoading)
                      BoxShadow(
                        color: AppColors.instance.primaryGreen.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Container(
                  height: 52,
                  alignment: Alignment.center,
                  child: widget.isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.login_rounded, color: Colors.white, size: 20),
                            Gap(width: 8),
                            Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14, fontWeight: FontWeight.w400),
      prefixIcon: Icon(icon, color: AppColors.instance.primaryGreen.withValues(alpha: 0.8), size: 20),
      filled: true,
      fillColor: const Color(0xFFF9FAFB),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.instance.primaryGreen, width: 1.6)),
    );
  }
}
