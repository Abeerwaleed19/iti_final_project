import 'package:flutter/material.dart';
import 'model/cart_model.dart';
import 'network/cartService.dart';
import 'wedgits/soldItems.dart';
class cartScreen extends StatelessWidget {
  cartScreen({super.key});
  final CartService _cartService = CartService();
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
        child:
        StreamBuilder<List<CartModel>>(
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
            return ListView.builder(
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                final product = cartProducts[index];
                return ProductItem(items: product);
              },
            );
          },
        ),
      ),
    );
  }
}
