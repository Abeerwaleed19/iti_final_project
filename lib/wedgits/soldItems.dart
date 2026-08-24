import 'package:flutter/material.dart';
import '../model/cart_model.dart';
import '../network/cartService.dart';
class ProductItem extends StatelessWidget {
  const ProductItem({super.key, required this.items});
  final CartModel items;
  @override
  Widget build(BuildContext context) {
    final CartService cartService = CartService();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child:
      Dismissible(
        key: Key(items.id),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          child: Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) async {
          await cartService.removeFromCart(context: context, id: items.id);
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xffF8F7F7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.asset(
                  items.image,
                  height: 90,
                  width: 90,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: 10),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ItemName : ${items.itemName}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff1E1B17),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "price : ${items.price}",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff6055D8),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "size : ${items.size ?? ''}",
                      style: TextStyle(
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
                  await cartService.removeFromCart(context: context, id: items.id);
                },
                icon: const Icon(Icons.delete_forever, color: Colors.red),
              ),
              IconButton(
                onPressed: () async {
                  await cartService.editFavorite(
                    context: context,
                    id: items.id,
                    newValue: !items.isFavorite,
                  );
                },
                icon: Icon(
                  items.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: items.isFavorite ? Colors.red : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
