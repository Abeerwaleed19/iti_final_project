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
    String query = searchController.text
        .trim(); // Get the search query from the TextField
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
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 21),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      autofocus: true,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        searchProduct();
                      },
                      decoration: InputDecoration(
                        hintText: "Search",
                        prefixIcon: Icon(Icons.search, size: 20),
                        suffixIcon: IconButton(
                          onPressed: () {
                            searchController.clear();
                          },
                          icon: Icon(Icons.close, size: 18),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            color: Color(0xFF577CD9),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: Color(0xFF0E0AB1),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),

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
                  Icon(Icons.search, color: Color(0xFF6055D8), size: 30),
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
