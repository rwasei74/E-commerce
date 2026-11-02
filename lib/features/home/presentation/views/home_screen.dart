import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/data/auth_repository.dart';
import '../../../auth/presentation/views/sign_in_screen.dart';
import '../../../categories/presentation/views/categories_screen.dart';
import '../../../products/data/models/product.dart';
import '../../../products/data/repositories/products_repository.dart';
import '../../../products/presentation/views/product_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                children: const [
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
      Image.asset(AppAssets.routeLogoBlue, width: 86),
      Image.asset(AppAssets.cartIcon, width: 24),
    ],
  );
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();
  @override
  Widget build(BuildContext context) => TextField(
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
      height: 146,
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
  static const _items = [
    'Women’s\nfashion',
    'men’s\nfashion',
    'Laptops &\nElectronics',
    'Baby &\nToys',
    'Beauty',
    'Headphones',
    'Skincare',
    'Cameras',
  ];
  static const _images = [
    AppAssets.categoryWomensFashion,
    AppAssets.categoryMensFashion,
    AppAssets.categoryLaptops,
    AppAssets.categoryBaby,
    AppAssets.categoryBeauty,
    AppAssets.categoryHeadphones,
    AppAssets.categorySkincare,
    AppAssets.categoryCameras,
  ];
  @override
  Widget build(BuildContext context) => SizedBox(
    height: 111,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _items.length,
      separatorBuilder: (_, _) => const SizedBox(width: 13),
      itemBuilder: (_, index) => SizedBox(
        width: 68,
        child: Column(
          children: [
            CircleAvatar(
              radius: 31,
              backgroundColor: const Color(0xFFF0E7DF),
              backgroundImage: AssetImage(_images[index]),
            ),
            const SizedBox(height: 5),
            Text(
              _items[index],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 9, color: Color(0xFF101050)),
            ),
          ],
        ),
      ),
    ),
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
                const Positioned(
                  top: 8,
                  right: 8,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.favorite_border,
                      color: AppColors.blue,
                      size: 18,
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
  Widget build(BuildContext context) => Container(
    height: 66,
    decoration: const BoxDecoration(
      color: AppColors.blue,
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const _NavIcon(asset: AppAssets.homeIcon, selected: true),
        _NavIcon(
          asset: AppAssets.categoriesIcon,
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const CategoriesScreen()),
          ),
        ),
        const _NavIcon(asset: AppAssets.favouritesIcon),
        _NavIcon(
          asset: AppAssets.profileIcon,
          onTap: () => _showAccountSheet(context),
        ),
      ],
    ),
  );
}

void _showAccountSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    builder: (sheetContext) => SafeArea(
      child: ListTile(
        leading: const Icon(Icons.logout, color: AppColors.blue),
        title: const Text('Sign out'),
        onTap: () async {
          await sheetContext.read<AuthRepository>().signOut();
          if (!sheetContext.mounted) return;
          Navigator.of(sheetContext).pushAndRemoveUntil(
            MaterialPageRoute<void>(builder: (_) => const SignInScreen()),
            (_) => false,
          );
        },
      ),
    ),
  );
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.asset, this.selected = false, this.onTap});
  final String asset;
  final bool selected;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(20),
    child: Container(
      width: 33,
      height: 33,
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Image.asset(
        asset,
        color: selected ? AppColors.blue : Colors.white,
      ),
    ),
  );
}
