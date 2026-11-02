import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class RouteBottomNavigation extends StatelessWidget {
  const RouteBottomNavigation({
    super.key,
    required this.selectedIndex,
    required this.onHome,
    required this.onCategories,
    required this.onWishlist,
    required this.onProfile,
  });
  final int selectedIndex;
  final VoidCallback onHome;
  final VoidCallback onCategories;
  final VoidCallback onWishlist;
  final VoidCallback onProfile;

  @override
  Widget build(BuildContext context) {
    final actions = [onHome, onCategories, onWishlist, onProfile];
    final icons = [
      Icons.home_outlined,
      Icons.grid_view_rounded,
      Icons.favorite_border_rounded,
      Icons.person_outline_rounded,
    ];
    return Container(
      height: 66,
      decoration: const BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (index) {
          final selected = index == selectedIndex;
          return InkWell(
            onTap: actions[index],
            borderRadius: BorderRadius.circular(24),
            child: Container(
              width: 39,
              height: 39,
              decoration: BoxDecoration(
                color: selected ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icons[index],
                color: selected ? AppColors.blue : Colors.white,
                size: 25,
              ),
            ),
          );
        }),
      ),
    );
  }
}
