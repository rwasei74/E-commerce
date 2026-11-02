import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../core/theme/app_theme.dart';
import '../features/auth/data/auth_repository.dart';
import '../features/auth/presentation/view_model/sign_in_cubit.dart';
import '../features/auth/presentation/views/sign_in_screen.dart';
import '../features/cart/data/repositories/cart_repository.dart';
import '../features/cart/presentation/view_model/cart_cubit.dart';
import '../features/home/presentation/views/home_screen.dart';
import '../features/wishlist/data/repositories/wishlist_repository.dart';
import '../features/wishlist/presentation/view_model/wishlist_cubit.dart';

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
    designSize: const Size(393, 852),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, _) => MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository()),
        RepositoryProvider(create: (context) => CartRepository(context.read())),
        RepositoryProvider(
          create: (context) => WishlistRepository(context.read()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SignInCubit(context.read())),
          BlocProvider(create: (context) => CartCubit(context.read())),
          BlocProvider(create: (context) => WishlistCubit(context.read())),
        ],
        child: MaterialApp(
          title: 'Route',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          home: const _SessionGate(),
        ),
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
