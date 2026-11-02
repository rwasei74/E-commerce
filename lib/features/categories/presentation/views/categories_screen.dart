import 'package:flutter/material.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/views/home_screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  static const _categories = [
    'Men’s Fashion',
    'Women’s Fashion',
    'Skincare',
    'Beauty',
    'Headphones',
    'Cameras',
    'Laptops &\nElectronics',
    'Baby & Toys',
  ];

  static const _subCategories = [
    [
      'T-shirts',
      'Shorts',
      'Jeans',
      'Pants',
      'Footwear',
      'Suits',
      'Watches',
      'Bags',
      'Eyewears',
    ],
    [
      'Dresses',
      'Jeans',
      'skirts',
      'pijamas',
      'Bags',
      'T-shirts',
      'Footwear',
      'Eyewear',
      'Watches',
    ],
    ['Cleansers', 'Serums', 'Masks', 'Sunscreen', 'Toners', 'Moisturizers'],
    ['Makeup', 'Brushes', 'Lipstick', 'Nails', 'Perfume', 'Creams'],
    ['Headphones', 'Earbuds', 'Speakers', 'Cables'],
    ['DSLR', 'Lenses', 'Tripods', 'Accessories'],
    ['Laptops', 'Mobiles', 'Tablets', 'Accessories'],
    ['Toys', 'Kidswear', 'Baby care', 'Games'],
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final selected = _categories[_selectedIndex];
    final items = _subCategories[_selectedIndex];

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const _CategoriesHeader(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 132,
                      child: ListView.builder(
                        itemCount: _categories.length,
                        itemBuilder: (context, index) => _CategoryTile(
                          title: _categories[index],
                          selected: _selectedIndex == index,
                          onTap: () => setState(() => _selectedIndex = index),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selected.replaceAll('\n', ' '),
                              style: const TextStyle(
                                color: Color(0xFF101050),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _CategoryBanner(
                              title: selected.replaceAll('\n', ' '),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: GridView.builder(
                                itemCount: items.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 13,
                                      childAspectRatio: .74,
                                    ),
                                itemBuilder: (context, index) =>
                                    _SubCategoryCard(
                                      title: items[index],
                                      icon: _icons[index % _icons.length],
                                      color:
                                          _cardColors[index %
                                              _cardColors.length],
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const _CategoriesBottomNavigation(),
            ],
          ),
        ),
      ),
    );
  }
}

const _icons = [
  Icons.checkroom_outlined,
  Icons.shopping_bag_outlined,
  Icons.watch_outlined,
  Icons.face_retouching_natural_outlined,
  Icons.headphones_outlined,
  Icons.camera_alt_outlined,
];
const _cardColors = [
  Color(0xFFDCEBFA),
  Color(0xFFF0E2D8),
  Color(0xFFE1E9E1),
  Color(0xFFF9E3E7),
  Color(0xFFE2EDF4),
  Color(0xFFF2E6CE),
];

class _CategoriesHeader extends StatelessWidget {
  const _CategoriesHeader();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(18, 15, 18, 12),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(AppAssets.routeLogoBlue, width: 86),
            Image.asset(AppAssets.cartIcon, width: 24),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search, color: AppColors.blue),
            hintText: 'what do you search for?',
            hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF777777)),
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: AppColors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: const BorderSide(color: AppColors.blue, width: 1.5),
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
      height: 66,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: selected ? const Color(0xFFF0F3F7) : Colors.transparent,
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 5,
            height: 44,
            decoration: BoxDecoration(
              color: selected ? AppColors.blue : Colors.transparent,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Color(0xFF101050),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _CategoryBanner extends StatelessWidget {
  const _CategoryBanner({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) => Container(
    height: 77,
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
      color: const Color(0xFFB6DAE8),
      borderRadius: BorderRadius.circular(9),
      image: const DecorationImage(
        image: AssetImage(AppAssets.routeLogoBlue),
        opacity: .06,
        fit: BoxFit.cover,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFF101050),
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(7),
          ),
          child: const Text(
            'Shop Now',
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
        ),
      ],
    ),
  );
}

class _SubCategoryCard extends StatelessWidget {
  const _SubCategoryCard({
    required this.title,
    required this.icon,
    required this.color,
  });
  final String title;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Center(child: Icon(icon, size: 34, color: AppColors.blue)),
        ),
      ),
      const SizedBox(height: 5),
      Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 10, color: Color(0xFF101050)),
      ),
    ],
  );
}

class _CategoriesBottomNavigation extends StatelessWidget {
  const _CategoriesBottomNavigation();
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
        _BottomIcon(
          asset: AppAssets.homeIcon,
          onTap: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
          ),
        ),
        const _BottomIcon(asset: AppAssets.categoriesIcon, selected: true),
        const _BottomIcon(asset: AppAssets.favouritesIcon),
        const _BottomIcon(asset: AppAssets.profileIcon),
      ],
    ),
  );
}

class _BottomIcon extends StatelessWidget {
  const _BottomIcon({required this.asset, this.selected = false, this.onTap});
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
