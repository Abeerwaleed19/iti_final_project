import 'package:flutter/material.dart';
import 'search_result_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();

  void searchProduct() {
    String query = searchController.text.trim();

    if (query.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultScreen(searchText: query),
      ),
    );
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
              padding: const EdgeInsets.symmetric(horizontal: 15),

              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,

                      child: TextField(
                        controller: searchController,

                        autofocus: true,

                        textInputAction: TextInputAction.search,

                        onSubmitted: (value) {
                          searchProduct();
                        },

                        decoration: InputDecoration(
                          hintText: 'Search',

                          prefixIcon: const Icon(Icons.search, size: 20),

                          suffixIcon: IconButton(
                            onPressed: () {
                              searchController.clear();

                              setState(() {});
                            },

                            icon: const Icon(Icons.close, size: 18),
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
                  ),

                  const SizedBox(width: 8),

                  SizedBox(
                    width: 55,

                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },

                      style: TextButton.styleFrom(padding: EdgeInsets.zero),

                      child: const Text(
                        'Cancel',

                        style: TextStyle(
                          color: Color(0xFF6055D8),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Container(
              height: 65,

              decoration: BoxDecoration(
                color: Colors.grey.shade100,

                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,

                children: [
                  Icon(Icons.home_outlined, color: Colors.grey.shade600),

                  const Icon(Icons.search, color: Color(0xFF6055D8), size: 30),

                  Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.grey.shade600,
                  ),

                  Icon(Icons.person_outline, color: Colors.grey.shade600),
                ],
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
