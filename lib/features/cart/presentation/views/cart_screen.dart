import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../view_model/cart_cubit.dart';
import '../view_model/cart_state.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: const BackButton(color: AppColors.blue),
      title: const Text('Cart', style: TextStyle(fontWeight: FontWeight.w600)),
      centerTitle: true,
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(Icons.shopping_cart_outlined, color: AppColors.blue),
        ),
      ],
    ),
    body: BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        if (state.status == CartStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? 'Cart error')),
          );
        }
      },
      builder: (context, state) {
        if (state.status == CartStatus.loading && state.cart.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.cart.items.isEmpty) {
          return const Center(child: Text('Your cart is empty'));
        }
        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.cart.items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = state.cart.items[index];
                  return Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFC9D7E5)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: Image.network(
                            item.product.imageCover,
                            width: 78,
                            height: 78,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF101050),
                                ),
                              ),
                              const SizedBox(height: 7),
                              Text(
                                'EGP ${item.product.price}',
                                style: const TextStyle(
                                  color: Color(0xFF101050),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _QuantityButton(
                                    icon: Icons.remove,
                                    onTap: () => context
                                        .read<CartCubit>()
                                        .changeQuantity(
                                          item.product.id,
                                          item.count - 1,
                                        ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text('${item.count}'),
                                  ),
                                  _QuantityButton(
                                    icon: Icons.add,
                                    onTap: () => context
                                        .read<CartCubit>()
                                        .changeQuantity(
                                          item.product.id,
                                          item.count + 1,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.blue,
                          ),
                          onPressed: () =>
                              context.read<CartCubit>().remove(item.product.id),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
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
                          'EGP ${state.cart.totalPrice}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                    onPressed: () => _checkout(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 15,
                      ),
                    ),
                    child: const Text('Check Out'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ),
  );
}

void _checkout(BuildContext context) {
  final details = TextEditingController();
  final phone = TextEditingController();
  final city = TextEditingController();
  showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Shipping address'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: details,
            decoration: const InputDecoration(labelText: 'Address details'),
          ),
          TextField(
            controller: phone,
            decoration: const InputDecoration(labelText: 'Phone'),
          ),
          TextField(
            controller: city,
            decoration: const InputDecoration(labelText: 'City'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () async {
            if (details.text.isEmpty || phone.text.isEmpty || city.text.isEmpty)
              return;
            await context.read<CartCubit>().checkout(
              details: details.text,
              phone: phone.text,
              city: city.text,
            );
            if (dialogContext.mounted) Navigator.pop(dialogContext);
            if (context.mounted)
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Order placed successfully')),
              );
          },
          child: const Text('Place order'),
        ),
      ],
    ),
  );
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: Container(
      width: 28,
      height: 28,
      decoration: const BoxDecoration(
        color: AppColors.blue,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 17),
    ),
  );
}
