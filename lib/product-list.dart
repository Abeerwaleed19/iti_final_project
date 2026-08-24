import 'package:flutter/material.dart';
import 'model/cart_model.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  static List<CartModel> products = [
    CartModel(
      id: 'f1',
      image: 'assets/images/Watch.jpg',
      itemName: 'Watch',
      price: '\$40',
    ),
    CartModel(
      id: 'f2',
      image: 'assets/images/Nike Shoes.jpg',
      itemName: 'Nike Shoes',
      price: '\$430',
    ),
    CartModel(
      id: 'p1',
      image: 'assets/images/LG TV.jpg',
      itemName: 'LG TV',
      price: '\$330',
    ),
    CartModel(
      id: 'f3',
      image: 'assets/images/Airpods.jpg',
      itemName: 'Airpods',
      price: '\$333',
    ),
    CartModel(
      id: 'p3',
      image: 'assets/images/Jacket.jpg',
      itemName: 'Jacket',
      price: '\$50',
    ),
    CartModel(
      id: 'p2',
      image: 'assets/images/Hoodie.jpg',
      itemName: 'Hoodie',
      price: '\$400',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Products',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 15,
          childAspectRatio: 0.70,
        ),
        itemBuilder: (context, index) {
          return ProductCard(product: products[index]);
        },
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final CartModel product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  bool isAdded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.15), blurRadius: 6),
        ],
      ),

      child: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Image.asset(
                      widget.product.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                // Heart
                Positioned(
                  top: 2,
                  right: 2,
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isFavorite = !isFavorite;
                      });
                    },
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.black,
                    ),
                  ),
                ),

                // Plus / Check
                Positioned(
                  bottom: 5,
                  right: 5,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A148C),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          isAdded = !isAdded;
                        });
                      },
                      icon: Icon(
                        isAdded ? Icons.check : Icons.add,
                        color: Colors.white,
                        size: 21,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.product.itemName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 5),

          Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.product.price,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
