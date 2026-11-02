import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/route_logo.dart';
import '../../../home/presentation/views/home_screen.dart';
import '../view_model/sign_up_cubit.dart';
import 'sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidePassword = true;
  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => SignUpCubit(context.read()),
    child: BlocListener<SignUpCubit, SignUpState>(
      listener: (context, state) {
        if (state.status == SignUpStatus.success) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
            (_) => false,
          );
        }
        if (state.status == SignUpStatus.failure &&
            state.errorMessage != null) {
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 430),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(child: RouteLogo(width: 190)),
                      const SizedBox(height: 28),
                      const FieldLabel(text: 'Full Name'),
                      const SizedBox(height: 8),
                      AppTextField(
                        hint: 'enter your full name',
                        controller: _name,
                      ),
                      const SizedBox(height: 18),
                      const FieldLabel(text: 'Mobile Number'),
                      const SizedBox(height: 8),
                      AppTextField(
                        hint: 'enter your mobile no.',
                        controller: _phone,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 18),
                      const FieldLabel(text: 'E-mail address'),
                      const SizedBox(height: 8),
                      AppTextField(
                        hint: 'enter your email address',
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 18),
                      const FieldLabel(text: 'Password'),
                      const SizedBox(height: 8),
                      AppTextField(
                        hint: 'enter your password',
                        controller: _password,
                        obscureText: _hidePassword,
                        suffix: IconButton(
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(
                            _hidePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<SignUpCubit, SignUpState>(
                        builder: (context, state) => PrimaryAuthButton(
                          title: 'Sign up',
                          isLoading: state.status == SignUpStatus.submitting,
                          onPressed: () => context.read<SignUpCubit>().signUp(
                            name: _name.text,
                            email: _email.text,
                            password: _password.text,
                            phone: _phone.text,
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
    ),
  );
}
