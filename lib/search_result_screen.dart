import 'package:flutter/material.dart';
import 'model/cart_model.dart';
import 'product_card.dart';

class SearchResultScreen extends StatefulWidget {
  final String searchText;

  const SearchResultScreen({super.key, required this.searchText});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late TextEditingController searchController;

  List<CartModel> filteredProducts = [];

  final List<CartModel> products = [
    // 👟 Shoes
    CartModel(
      id: '1',
      itemName: 'Nike Air Force 1',
      price: '430',
      image: 'assets/images/black.jpg',
    ),

    CartModel(
      id: '2',
      itemName: 'Nike Pink Air Max',
      price: '400',
      image: 'assets/images/pink.jpg',
    ),

    CartModel(
      id: '3',
      itemName: 'Nike Grey Runner',
      price: '400',
      image: 'assets/images/gray.jpg',
    ),

    CartModel(
      id: '4',
      itemName: 'Nike Blue Air Max',
      price: '430',
      image: 'assets/images/blue.jpg',
    ),

    CartModel(
      id: '5',
      itemName: 'Nike Shoes',
      price: '350',
      image: 'assets/images/Nike Shoes.jpg',
    ),

    CartModel(
      id: '6',
      itemName: 'Nike Red Runner',
      price: '500',
      image: 'assets/images/red.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();

    searchController = TextEditingController(text: widget.searchText);

    filterProducts(widget.searchText);
  }

  void filterProducts(String query) {
    final searchQuery = query.toLowerCase().trim();

    setState(() {
      if (searchQuery.isEmpty) {
        filteredProducts = [];
        return;
      }

      if (searchQuery == 'shoes' || searchQuery == 'shoe') {
        filteredProducts = products.where((product) {
          return product.itemName.toLowerCase().contains('nike');
        }).toList();

        return;
      }

      filteredProducts = products.where((product) {
        final itemName = product.itemName.toLowerCase();

        return itemName.contains(searchQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),

              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.arrow_back),
                  ),

                  Expanded(
                    child: TextField(
                      controller: searchController,

                      onChanged: (value) {
                        filterProducts(value);

                        setState(() {});
                      },

                      textInputAction: TextInputAction.search,

                      decoration: InputDecoration(
                        hintText: 'Search',

                        prefixIcon: const Icon(Icons.search, size: 20),

                        suffixIcon: IconButton(
                          icon: const Icon(Icons.close, size: 18),

                          onPressed: () {
                            searchController.clear();

                            filterProducts('');

                            setState(() {});
                          },
                        ),

                        filled: true,

                        fillColor: const Color(0xffF8F7F7),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),

                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Expanded(
                    child: Text(
                      'Results for "${searchController.text}"',

                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),

                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Text(
                    '${filteredProducts.length} Results Found',

                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6055D8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'No products found',

                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 5,
                      ),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,

                            crossAxisSpacing: 12,

                            mainAxisSpacing: 15,

                            childAspectRatio: 0.72,
                          ),

                      itemCount: filteredProducts.length,

                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];

                        return ProductCard(product: product);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();

    super.dispose();
  }
}
