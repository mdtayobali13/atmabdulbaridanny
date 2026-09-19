import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:barristerkayserkamal/routes/app_routes.dart';
import 'package:barristerkayserkamal/screens/auth_screen/sign_in_screen/provider/sign_in_provider.dart';
import 'package:barristerkayserkamal/screens/auth_screen/sign_in_screen/widgets/sign_in_brand_header.dart';
import 'package:barristerkayserkamal/screens/auth_screen/sign_in_screen/widgets/sign_in_form_card.dart';
import 'package:barristerkayserkamal/services/providers/api_providers.dart';
import 'package:barristerkayserkamal/services/storage/storage_services.dart';
import 'package:barristerkayserkamal/utils/app_log.dart';
import 'package:barristerkayserkamal/utils/gap.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
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
    FocusScope.of(context).unfocus();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      final success = await ref.read(signInProvider.notifier).signIn(email, password);

      if (!mounted) return;
      if (!success) return;

      if (_rememberMe && email.isNotEmpty) {
        await StorageServices.instance.setLogDedData({"email": email});
      }

      ref.invalidate(currentUserProvider);

      if (!mounted) return;

      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      } else {
        AppRoutes.instance.go('/admin_dashboard_screen');
      }
    } catch (e) {
      errorLog("_handleLogin error", e);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Gap(height: 10),
                  const SignInBrandHeader(),
                  const Gap(height: 32),
                  SignInFormCard(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    rememberMe: _rememberMe,
                    onRememberMeChanged: (val) => setState(() => _rememberMe = val),
                    isLoading: isLoading,
                    onLogin: _handleLogin,
                  ),
                  const Gap(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
