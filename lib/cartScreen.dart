import 'package:flutter/material.dart';
import 'model/cart_model.dart';
import 'network/cartService.dart';
import 'network/favorite service.dart';
import 'wedgits/soldItems.dart';
import 'checkoutScreen.dart';

class cartScreen extends StatelessWidget {
  cartScreen({super.key});
  final CartService _cartService = CartService();
  final FavoriteService _favoriteService = FavoriteService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Your Cart",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xff000000),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: StreamBuilder<List<CartModel>>(
          stream: _cartService.getCartItems(),
          builder: (context, snapShot) {
            if (snapShot.hasError) {
              print("Firestore Error: ${snapShot.error}");
              return Center(child: Text("Error occured"));
            }
            if (snapShot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final cartProducts = snapShot.data ?? [];
            if (cartProducts.isEmpty) {
              return Center(
                child: Text(
                  "Cart Is Empty",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff6055D8),
                  ),
                ),
              );
            }

            final total = _cartService.calculateTotal(cartProducts);

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = cartProducts[index];
                      return ProductItem(items: product);
                    },
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff000000),
                      ),
                    ),
                    Text(
                      total.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff6055D8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => checkoutScreen(
                            cartItems: cartProducts,
                            total: total,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff6055D8),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Checkout",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
