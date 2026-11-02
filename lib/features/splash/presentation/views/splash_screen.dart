import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/route_logo.dart';
import '../../../auth/presentation/views/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute<void>(builder: (_) => const SignInScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    backgroundColor: AppColors.blue,
    body: Center(child: RouteLogo(width: 390)),
  );
}
