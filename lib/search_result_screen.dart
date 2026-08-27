import 'package:flutter/material.dart';
import 'package:iti_project_final/model/cart_model.dart';
import 'package:iti_project_final/product-list.dart';

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
    CartModel(
      itemName: "Nike Shoes",
      id: "1",
      price: "430",
      image: "assets/images/Nike Shoes.jpg",
    ),

    CartModel(
      itemName: "ٍRunning Shoes",
      id: "2",
      price: "400",
      image: "assets/images/red.jpg",
    ),

    CartModel(
      itemName: "Classic Shoes",
      id: "3",
      price: "430",
      image: "assets/images/black.jpg",
    ),

    CartModel(
      itemName: "Platform Heels",
      id: "4",
      price: "350",
      image: "assets/images/heels1.jpeg",
    ),

    CartModel(
      itemName: "Stiletto Heels",
      id: "5",
      price: "500",
      image: "assets/images/heels2.jpeg",
    ),

    CartModel(
      itemName: "Jacket",
      id: "6",
      price: "150",
      image: "assets/images/Jacket.jpeg",
    ),

    CartModel(
      itemName: "White Hoodie",
      id: "7",
      price: "400",
      image: "assets/images/White Hoodie.jpeg",
    ),

    CartModel(
      itemName: "Green Hoodie",
      id: "8",
      price: "400",
      image: "assets/images/green hoodie.jpeg",
    ),

    CartModel(
      itemName: "Airpods",
      id: "9",
      price: "200",
      image: "assets/images/Airpods.jpg",
    ),

    CartModel(
      itemName: "Girls Airpods",
      id: "10",
      price: "333",
      image: "assets/images/girls airpods.jpeg",
    ),

    CartModel(
      itemName: "LG TV",
      id: "11",
      price: "330",
      image: "assets/images/LG TV.jpg",
    ),
  ];
  @override
  void initState() {
    super.initState();
    searchController = TextEditingController(text: widget.searchText);
    filterProducts(widget.searchText);
  }

  // Function to filter products based on the search query
  void filterProducts(String query) {
    final searchQuery = query.toLowerCase().trim();

    setState(() {
      if (searchQuery.isEmpty) {
        filteredProducts = [];
      } else {
        filteredProducts = products.where((product) {
          final productName = product.itemName.toLowerCase();

          return productName.contains(searchQuery);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: (value) {
                        filterProducts(value);
                      },
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.close, size: 18),
                          onPressed: () {
                            searchController.clear();
                            filterProducts("");
                          },
                        ),
                        filled: true,
                        fillColor: Color(0xffF8F7F7),
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
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Results for "${searchController.text}"',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    "${filteredProducts.length} Results Found",
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6055D8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: filteredProducts.isEmpty
                  ? Center(
                child: Text(
                  "No products found",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              )
                  : GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 5,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
