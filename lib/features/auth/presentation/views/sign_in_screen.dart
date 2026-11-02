import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/route_logo.dart';
import '../../../home/presentation/views/home_screen.dart';
import '../view_model/sign_in_cubit.dart';
import '../view_model/sign_in_state.dart';
import 'sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<SignInCubit, SignInState>(
    listener: (context, state) {
      if (state.status == SignInStatus.success) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
          (_) => false,
        );
      }
      if (state.status == SignInStatus.failure && state.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
      }
    },
    child: Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: AppColors.blue,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(child: RouteLogo(width: 190)),
                    const SizedBox(height: 36),
                    const Text('Welcome Back To Route', style: _titleStyle),
                    const Text(
                      'Please sign in with your mail',
                      style: _hintStyle,
                    ),
                    const SizedBox(height: 24),
                    const FieldLabel(text: 'E-mail address'),
                    const SizedBox(height: 8),
                    AppTextField(
                      hint: 'enter your email',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 18),
                    const FieldLabel(text: 'Password'),
                    const SizedBox(height: 8),
                    BlocBuilder<SignInCubit, SignInState>(
                      builder: (context, state) => AppTextField(
                        hint: 'enter your password',
                        controller: _passwordController,
                        obscureText: state.isPasswordHidden,
                        suffix: IconButton(
                          onPressed: context
                              .read<SignInCubit>()
                              .togglePasswordVisibility,
                          icon: Icon(
                            state.isPasswordHidden
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Forgot password'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    BlocBuilder<SignInCubit, SignInState>(
                      builder: (context, state) => PrimaryAuthButton(
                        title: 'Login',
                        isLoading: state.status == SignInStatus.submitting,
                        onPressed: () => context.read<SignInCubit>().signIn(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const SignUpScreen(),
                          ),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          "Don't have an account? Create Account",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

const _titleStyle = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontWeight: FontWeight.w600,
);
const _hintStyle = TextStyle(color: Colors.white, fontSize: 12);

class FieldLabel extends StatelessWidget {
  const FieldLabel({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      color: Colors.white,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
  );
}

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.hint,
    this.controller,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
  });
  final String hint;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscureText,
    style: const TextStyle(color: AppColors.blue),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFF888888), fontSize: 13),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    ),
  );
}

class PrimaryAuthButton extends StatelessWidget {
  const PrimaryAuthButton({
    super.key,
    required this.title,
    required this.isLoading,
    required this.onPressed,
  });
  final String title;
  final bool isLoading;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: 52,
    child: FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.blue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: isLoading
          ? const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
    ),
  );
}
