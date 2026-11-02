import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/view_model/sign_in_cubit.dart';
import '../features/auth/presentation/views/sign_in_screen.dart';
import '../features/home/presentation/views/home_screen.dart';

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});
  @override
  Widget build(BuildContext context) => RepositoryProvider(
    create: (_) => AuthRepository(),
    child: BlocProvider(
      create: (context) => SignInCubit(context.read()),
      child: MaterialApp(
        title: 'Route',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const _SessionGate(),
      ),
    ),
  );
}

class _SessionGate extends StatelessWidget {
  const _SessionGate();

  @override
  Widget build(BuildContext context) => FutureBuilder<bool>(
    future: context.read<AuthRepository>().hasActiveSession(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return snapshot.data! ? const HomeScreen() : const SignInScreen();
    },
  );
}
