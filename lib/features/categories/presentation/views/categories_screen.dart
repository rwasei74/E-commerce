import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/route_bottom_navigation.dart';
import '../../../cart/presentation/views/cart_screen.dart';
import '../../../home/presentation/views/home_screen.dart';
import '../../../wishlist/presentation/views/wishlist_screen.dart';
import '../../../profile/presentation/views/profile_screen.dart';
import '../../../products/data/models/product.dart';
import '../../../products/data/repositories/products_repository.dart';
import '../../../products/presentation/views/product_details_screen.dart';
import '../../data/models/category.dart';
import '../../data/repositories/categories_repository.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key, this.initialCategoryId});

  final String? initialCategoryId;

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _categoriesRepository = CategoriesRepository();
  final _productsRepository = ProductsRepository();
  late final Future<List<Category>> _categoriesFuture;
  String? _selectedCategoryId;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _categoriesRepository.getCategories();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: FutureBuilder<List<Category>>(
        future: _categoriesFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data!.isEmpty) {
            return const Center(child: Text('Could not load categories'));
          }
          final categories = snapshot.data!;
          _selectedCategoryId ??=
              widget.initialCategoryId ?? categories.first.id;
          final selected = categories.firstWhere(
            (category) => category.id == _selectedCategoryId,
            orElse: () => categories.first,
          );
          return Column(
            children: [
              _Header(onCart: _openCart),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 112,
                      child: ListView.builder(
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final category = categories[index];
                          return _CategoryTile(
                            title: category.name,
                            selected: category.id == selected.id,
                            onTap: () => setState(
                              () => _selectedCategoryId = category.id,
                            ),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: _CategoryProducts(
                        category: selected,
                        repository: _productsRepository,
                      ),
                    ),
                  ],
                ),
              ),
              _BottomBar(
                onHome: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );

  void _openCart() => Navigator.of(
    context,
  ).push(MaterialPageRoute<void>(builder: (_) => const CartScreen()));
}

class _Header extends StatelessWidget {
  const _Header({required this.onCart});
  final VoidCallback onCart;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(18, 15, 18, 12),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(AppAssets.routeLogoBlue, width: 86),
            IconButton(
              onPressed: onCart,
              icon: Image.asset(AppAssets.cartIcon, width: 24),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: AppColors.blue),
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
  );
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.title,
    required this.selected,
    required this.onTap,
  });
  final String title;
  final bool selected;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    child: Container(
      height: 70,
      color: selected ? const Color(0xFFF0F3F7) : Colors.transparent,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 46,
            decoration: BoxDecoration(
              color: selected ? AppColors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF101050),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _CategoryProducts extends StatelessWidget {
  const _CategoryProducts({required this.category, required this.repository});
  final Category category;
  final ProductsRepository repository;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 10, 10, 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category.name,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: Color(0xFF101050),
          ),
        ),
        const SizedBox(height: 10),
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: SizedBox(
            height: 84,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  category.image,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) =>
                      Container(color: const Color(0xFFB6DAE8)),
                ),
                Container(color: AppColors.blue.withValues(alpha: .2)),
                const Padding(
                  padding: EdgeInsets.all(13),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Shop Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: FutureBuilder<List<Product>>(
            key: ValueKey(category.id),
            future: repository.getProductsByCategory(category.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No products in this category'),
                );
              }
              return GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 14,
                  childAspectRatio: .56,
                ),
                itemBuilder: (context, index) =>
                    _ProductTile(product: snapshot.data![index]),
              );
            },
          ),
        ),
      ],
    ),
  );
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({required this.product});
  final Product product;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProductDetailsScreen(product: product),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              product.imageCover,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  const ColoredBox(color: Color(0xFFE9EEF3)),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 10, color: Color(0xFF101050)),
        ),
        Text(
          'EGP ${product.price}',
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: AppColors.blue,
          ),
        ),
      ],
    ),
  );
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.onHome});
  final VoidCallback onHome;
  @override
  Widget build(BuildContext context) => RouteBottomNavigation(
    selectedIndex: 1,
    onHome: onHome,
    onCategories: () {},
    onWishlist: () => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const WishlistScreen())),
    onProfile: () => Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ProfileScreen())),
  );
}
