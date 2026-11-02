import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/product.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: AppColors.blue),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    'Product Details',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 17),
                  ),
                ),
              ),
              const Icon(Icons.search, color: AppColors.blue),
              const SizedBox(width: 18),
              const Icon(Icons.shopping_cart_outlined, color: AppColors.blue),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(13),
            child: SizedBox(
              height: 255,
              width: double.infinity,
              child: Image.network(
                product.imageCover,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(
                  child: Icon(Icons.image_not_supported_outlined, size: 56),
                ),
              ),
            ),
          ),
          const SizedBox(height: 17),
          Row(
            children: [
              Expanded(
                child: Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                'EGP ${product.price}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Chip(label: Text('${product.sold} Sold')),
              const SizedBox(width: 12),
              const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
              Text(' ${product.rating} (${product.ratingCount})'),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            'Description',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            product.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF77709B)),
          ),
          const SizedBox(height: 15),
          const Text(
            'Size',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          Wrap(
            spacing: 12,
            children: [38, 39, 40, 41, 42]
                .map(
                  (size) => ChoiceChip(
                    label: Text('$size'),
                    selected: size == 40,
                    selectedColor: AppColors.blue,
                    labelStyle: TextStyle(
                      color: size == 40
                          ? Colors.white
                          : const Color(0xFF101050),
                    ),
                    onSelected: (_) {},
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 15),
          const Text(
            'Color',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              ColorDot(Color(0xFF30292A)),
              ColorDot(Color(0xFFC53B24), selected: true),
              ColorDot(Color(0xFF167DD8)),
              ColorDot(Color(0xFF00A847)),
              ColorDot(Color(0xFFFF615E)),
            ],
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total price',
                      style: TextStyle(color: Color(0xFF77709B)),
                    ),
                    Text(
                      'EGP ${product.price}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Add to cart'),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class ColorDot extends StatelessWidget {
  const ColorDot(this.color, {super.key, this.selected = false});
  final Color color;
  final bool selected;
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(right: 10),
    width: 31,
    height: 31,
    decoration: BoxDecoration(
      color: color,
      shape: BoxShape.circle,
      border: selected ? Border.all(color: Colors.white, width: 3) : null,
      boxShadow: [
        BoxShadow(
          color: selected ? AppColors.blue : Colors.transparent,
          spreadRadius: 2,
        ),
      ],
    ),
  );
}
