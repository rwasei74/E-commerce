import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/route_bottom_navigation.dart';
import '../../../categories/presentation/views/categories_screen.dart';
import '../../../categories/data/models/category.dart';
import '../../../categories/data/repositories/categories_repository.dart';
import '../../../cart/presentation/views/cart_screen.dart';
import '../../../products/data/models/product.dart';
import '../../../products/data/repositories/products_repository.dart';
import '../../../products/presentation/views/product_details_screen.dart';
import '../../../products/presentation/views/search_screen.dart';
import '../../../wishlist/presentation/view_model/wishlist_cubit.dart';
import '../../../wishlist/presentation/view_model/wishlist_state.dart';
import '../../../wishlist/presentation/views/wishlist_screen.dart';
import '../../../profile/presentation/views/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistCubit>().load();
  }

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.ltr,
    child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 24.h),
                children: [
                  _TopBar(),
                  SizedBox(height: 14),
                  _SearchBar(),
                  SizedBox(height: 14),
                  _PromotionBanner(),
                  SizedBox(height: 18),
                  _SectionHeader(title: 'Categories', action: 'view all'),
                  SizedBox(height: 12),
                  _CategoriesList(),
                  SizedBox(height: 18),
                  _SectionHeader(title: 'Home Appliances', action: 'view all'),
                  SizedBox(height: 12),
                  _ProductsGrid(),
                ],
              ),
            ),
            const _BottomNavigation(),
          ],
        ),
      ),
    ),
  );
}

class _TopBar extends StatelessWidget {
  const _TopBar();
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Image.asset(AppAssets.routeLogoBlue, width: 86.w),
      IconButton(
        onPressed: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const CartScreen())),
        icon: Image.asset(AppAssets.cartIcon, width: 24.w),
      ),
    ],
  );
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) => TextField(
    onSubmitted: (value) {
      if (value.trim().isNotEmpty)
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => SearchScreen(initialQuery: value.trim()),
          ),
        );
    },
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.search, color: AppColors.blue),
      hintText: 'what do you search for?',
      hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
      contentPadding: const EdgeInsets.symmetric(vertical: 6),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: AppColors.blue),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
      ),
    ),
  );
}

class _PromotionBanner extends StatelessWidget {
  const _PromotionBanner();
  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(12),
    child: SizedBox(
      height: 176.h,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppAssets.bannerHeadphones, fit: BoxFit.cover),
          Container(color: const Color(0xFFFFC400).withValues(alpha: .12)),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'UP TO',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '25% OFF',
                    style: TextStyle(
                      color: AppColors.blue,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'For all Headphones\n& AirPods',
                    style: TextStyle(color: AppColors.blue, fontSize: 10),
                  ),
                  SizedBox(height: 7),
                  _ShopNowButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _ShopNowButton extends StatelessWidget {
  const _ShopNowButton();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
    decoration: BoxDecoration(
      color: AppColors.blue,
      borderRadius: BorderRadius.circular(7),
    ),
    child: const Text(
      'Shop Now',
      style: TextStyle(color: Colors.white, fontSize: 10),
    ),
  );
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.action});
  final String title;
  final String action;
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          color: Color(0xFF101050),
          fontWeight: FontWeight.w600,
        ),
      ),
      Text(
        action,
        style: const TextStyle(color: Color(0xFF101050), fontSize: 10),
      ),
    ],
  );
}

class _CategoriesList extends StatelessWidget {
  const _CategoriesList();
  @override
  Widget build(BuildContext context) => FutureBuilder<List<Category>>(
    future: CategoriesRepository().getCategories(),
    builder: (context, snapshot) {
      if (!snapshot.hasData) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: CircularProgressIndicator(),
          ),
        );
      }
      if (snapshot.hasError) {
        return const SizedBox.shrink();
      }
      final categories = snapshot.data!.take(8).toList();
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 12.h,
          crossAxisSpacing: 4.w,
          childAspectRatio: .72,
        ),
        itemBuilder: (_, index) {
          final category = categories[index];
          return InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) =>
                    CategoriesScreen(initialCategoryId: category.id),
              ),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 34.r,
                  backgroundColor: const Color(0xFFF0E7DF),
                  backgroundImage: NetworkImage(category.image),
                ),
                SizedBox(height: 5.h),
                Text(
                  category.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 9.sp,
                    color: const Color(0xFF101050),
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

class _ProductsGrid extends StatelessWidget {
  const _ProductsGrid();
  @override
  Widget build(BuildContext context) => FutureBuilder<List<Product>>(
    future: ProductsRepository().getProducts(),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return const Padding(
          padding: EdgeInsets.all(32),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      if (snapshot.hasError || !snapshot.hasData) {
        return const Padding(
          padding: EdgeInsets.all(24),
          child: Center(child: Text('Could not load products')),
        );
      }
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: snapshot.data!.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: .58,
        ),
        itemBuilder: (context, index) =>
            _ProductCard(product: snapshot.data![index]),
      );
    },
  );
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailsScreen(product: product),
      ),
    ),
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFC9D7E5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(9),
                    ),
                    child: Image.network(
                      product.imageCover,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Center(
                        child: Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: BlocBuilder<WishlistCubit, WishlistState>(
                    builder: (context, state) => InkWell(
                      onTap: () =>
                          context.read<WishlistCubit>().toggle(product.id),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Icon(
                          state.contains(product.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: AppColors.blue,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF101050),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'EGP ${product.price}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF101050),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Review (${product.rating})',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF101050),
                        ),
                      ),
                      const Icon(
                        Icons.star,
                        size: 15,
                        color: Color(0xFFFFC107),
                      ),
                      const Spacer(),
                      const CircleAvatar(
                        radius: 13,
                        backgroundColor: AppColors.blue,
                        child: Icon(Icons.add, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _BottomNavigation extends StatelessWidget {
  const _BottomNavigation();
  @override
  Widget build(BuildContext context) => RouteBottomNavigation(
    selectedIndex: 0,
    onHome: () {},
    onCategories: () => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const CategoriesScreen())),
    onWishlist: () => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const WishlistScreen())),
    onProfile: () => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ProfileScreen())),
  );
}
