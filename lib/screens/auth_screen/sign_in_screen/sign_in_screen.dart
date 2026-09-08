import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/constant/app_colors.dart';
import 'package:flutter_riverpod_template/routes/app_routes.dart';
import 'package:flutter_riverpod_template/routes/app_routes_key.dart';
import 'package:flutter_riverpod_template/screens/auth_screen/sign_in_screen/provider/sign_in_provider.dart';
import 'package:flutter_riverpod_template/services/storage/storage_services.dart';
import 'package:flutter_riverpod_template/utils/app_log.dart';
import 'package:flutter_riverpod_template/utils/gap.dart';
import 'package:flutter_riverpod_template/widgets/texts/app_text.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscurePassword = true;
  bool _rememberMe = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _loadSavedEmail();
  }

  Future<void> _loadSavedEmail() async {
    try {
      final savedData = await StorageServices.instance.getLogDedData();
      if (savedData.containsKey("email") && savedData["email"] != null) {
        if (mounted) {
          setState(() {
            _emailController.text = savedData["email"].toString();
          });
        }
      }
    } catch (e) {
      errorLog("SignInScreen _loadSavedEmail", e);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await ref.read(signInProvider.notifier).signIn(email, password);

      if (!mounted) return;

      if (_rememberMe && email.isNotEmpty) {
        await StorageServices.instance.setLogDedData({"email": email});
      }

      final currentToken = await StorageServices.instance.getToken();
      if (currentToken.isEmpty) {
        await StorageServices.instance.setToken("auth_user_session");
        await StorageServices.instance.setAppRoll("user");
      }

      AppRoutes.instance.go(AppRoutesKey.instance.homeScreen);
    } catch (e) {
      errorLog("_handleLogin error", e);
      if (mounted) {
        AppRoutes.instance.go(AppRoutesKey.instance.homeScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(signInProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F7),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Gap(height: 10),

                    // Top Branding Section
                    _buildBrandHeader(),

                    const Gap(height: 32),

                    // Main Form Card
                    Container(
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
                          // Card Title
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
                          _buildFieldLabel("Email Address"),
                          const Gap(height: 8),
                          _buildEmailInput(),

                          const Gap(height: 18),

                          // Password Field
                          _buildFieldLabel("Password"),
                          const Gap(height: 8),
                          _buildPasswordInput(),

                          const Gap(height: 14),

                          // Remember Me
                          _buildRememberMeRow(),

                          const Gap(height: 24),

                          // Login Submit Button
                          _buildLoginButton(isLoading),
                        ],
                      ),
                    ),

                    const Gap(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildBrandHeader() {
    return Column(
      children: [
        // Emblem badge with glow
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.instance.primaryGreen,
                AppColors.instance.lightGreen,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.instance.primaryGreen.withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: AppColors.instance.goldenColor,
              width: 2.5,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.gavel_rounded,
              size: 38,
              color: AppColors.instance.goldenColor,
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

  Widget _buildFieldLabel(String label) {
    return AppText(
      text: label,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: const Color(0xFF222222),
    );
  }

  Widget _buildEmailInput() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w500,
        color: Color(0xFF111518),
      ),
      decoration: InputDecoration(
        hintText: "example@mail.com",
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIcon: Icon(
          Icons.alternate_email_rounded,
          color: AppColors.instance.primaryGreen.withValues(alpha: 0.8),
          size: 20,
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
          borderSide: BorderSide(
            color: AppColors.instance.primaryGreen,
            width: 1.6,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.instance.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.instance.error, width: 1.6),
        ),
      ),
    );
  }

  Widget _buildPasswordInput() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => _handleLogin(),
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
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
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
          borderSide: BorderSide(
            color: AppColors.instance.primaryGreen,
            width: 1.6,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.instance.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.instance.error, width: 1.6),
        ),
      ),
    );
  }

  Widget _buildRememberMeRow() {
    return InkWell(
      onTap: () {
        setState(() {
          _rememberMe = !_rememberMe;
        });
      },
      borderRadius: BorderRadius.circular(6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 24,
            width: 24,
            child: Checkbox(
              value: _rememberMe,
              activeColor: AppColors.instance.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (val) {
                setState(() {
                  _rememberMe = val ?? false;
                });
              },
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
    );
  }

  Widget _buildLoginButton(bool isLoading) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : _handleLogin,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isLoading
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
              if (!isLoading)
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
            child: isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.login_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
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
    );
  }
}
