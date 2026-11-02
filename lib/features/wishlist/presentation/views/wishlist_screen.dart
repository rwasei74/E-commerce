import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/route_bottom_navigation.dart';
import '../../../cart/presentation/view_model/cart_cubit.dart';
import '../../../cart/presentation/views/cart_screen.dart';
import '../../../categories/presentation/views/categories_screen.dart';
import '../../../home/presentation/views/home_screen.dart';
import '../../../profile/presentation/views/profile_screen.dart';
import '../view_model/wishlist_cubit.dart';
import '../view_model/wishlist_state.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});
  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: RouteBottomNavigation(
      selectedIndex: 2,
      onHome: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
      ),
      onCategories: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const CategoriesScreen()),
      ),
      onWishlist: () {},
      onProfile: () => Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => const ProfileScreen()),
      ),
    ),
    body: SafeArea(
      child: BlocConsumer<WishlistCubit, WishlistState>(
        listener: (context, state) {
          if (state.status == WishlistStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Could not update favourites'),
              ),
            );
          }
        },
        builder: (context, state) => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 15, 18, 12),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Image.asset(AppAssets.routeLogoBlue, width: 86),
                      IconButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const CartScreen(),
                          ),
                        ),
                        icon: Image.asset(AppAssets.cartIcon, width: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.blue,
                      ),
                      hintText: 'what do you search for?',
                      hintStyle: const TextStyle(fontSize: 12),
                      contentPadding: const EdgeInsets.symmetric(vertical: 5),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.blue),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(color: AppColors.blue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child:
                  state.status == WishlistStatus.loading &&
                      state.products.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : state.products.isEmpty
                  ? const Center(child: Text('No favourite products yet'))
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(18, 6, 18, 18),
                      itemCount: state.products.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return Container(
                          height: 94,
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            border: Border.all(color: const Color(0xFFC9D7E5)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: Image.network(
                                  product.imageCover,
                                  width: 78,
                                  height: 78,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF101050),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Favourite product',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Color(0xFF77709B),
                                      ),
                                    ),
                                    const Spacer(),
                                    Row(
                                      children: [
                                        Text(
                                          'EGP ${product.price}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: Color(0xFF101050),
                                          ),
                                        ),
                                        const Spacer(),
                                        SizedBox(
                                          height: 30,
                                          child: FilledButton(
                                            onPressed: () => context
                                                .read<CartCubit>()
                                                .add(product.id),
                                            style: FilledButton.styleFrom(
                                              backgroundColor: AppColors.blue,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                  ),
                                            ),
                                            child: const Text(
                                              'Add to Cart',
                                              style: TextStyle(fontSize: 10),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.favorite,
                                  color: AppColors.blue,
                                  size: 19,
                                ),
                                onPressed: () => context
                                    .read<WishlistCubit>()
                                    .remove(product.id),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}
