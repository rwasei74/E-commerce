import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/route_bottom_navigation.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../auth/presentation/views/sign_in_screen.dart';
import '../../../categories/presentation/views/categories_screen.dart';
import '../../../home/presentation/views/home_screen.dart';
import '../../../wishlist/presentation/views/wishlist_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: RouteBottomNavigation(
      selectedIndex: 3,
      onHome: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      ),
      onCategories: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const CategoriesScreen()),
      ),
      onWishlist: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const WishlistScreen()),
      ),
      onProfile: () {},
    ),
    body: SafeArea(
      child: FutureBuilder<UserProfile>(
        future: context.read<AuthRepository>().getProfile(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final profile = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(18),
            children: [
              Image.asset(
                AppAssets.routeLogoBlue,
                width: 86,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 18),
              Text(
                'Welcome, ${profile.name}',
                style: const TextStyle(
                  color: Color(0xFF101050),
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                profile.email,
                style: const TextStyle(color: Color(0xFF77709B), fontSize: 12),
              ),
              const SizedBox(height: 24),
              _ProfileField(label: 'Your full name', value: profile.name),
              _ProfileField(label: 'Your E-mail', value: profile.email),
              const _ProfileField(
                label: 'Your password',
                value: '••••••••••••••••',
              ),
              _ProfileField(label: 'Your mobile number', value: profile.phone),
              const _ProfileField(
                label: 'Your Address',
                value: 'Add your address',
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () async {
                  await context.read<AuthRepository>().signOut();
                  if (!context.mounted) return;
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute<void>(
                      builder: (_) => const SignInScreen(),
                    ),
                    (_) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF101050),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 13),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFC9D7E5)),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF101050),
                  ),
                ),
              ),
              const Icon(Icons.edit_outlined, color: AppColors.blue, size: 18),
            ],
          ),
        ),
      ],
    ),
  );
}
