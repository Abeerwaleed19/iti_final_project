import 'package:flutter/material.dart';
import '../model/cart_model.dart';
import '../network/cartService.dart';
import '../network/favorite service.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.items});

  final CartModel items;

  @override
  Widget build(BuildContext context) {
    final CartService cartService = CartService();
    final FavoriteService favoriteService = FavoriteService();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Dismissible(
        key: Key(items.id),
        direction: DismissDirection.endToStart,

        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),

        onDismissed: (_) async {
          await cartService.removeFromCart(context: context, id: items.id);
        },

        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xffF8F7F7),
            borderRadius: BorderRadius.circular(20),
          ),

          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  items.image,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ItemName : ${items.itemName}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1E1B17),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "price : ${items.price}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff6055D8),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      "size : ${items.size ?? ''}",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.pink,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () async {
                  await cartService.removeFromCart(
                    context: context,
                    id: items.id,
                  );
                },
                icon: const Icon(Icons.delete_forever, color: Colors.red),
              ),
              
              StreamBuilder<bool>(
                stream: favoriteService.isFavoriteStream(items.id),
                builder: (context, snapshot) {
                  final isFavorite = snapshot.data ?? false;

                  return IconButton(
                    onPressed: () async {
                      await favoriteService.toggleFavorite(
                        context: context,
                        product: items,
                        isCurrentlyFavorite: isFavorite,
                      );
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.grey,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
