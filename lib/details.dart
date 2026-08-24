import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'cartScreen.dart';
import 'model/cart_model.dart';
import 'network/cartService.dart';
import 'snackbar.dart';

class detailsScreen extends StatefulWidget {
  const detailsScreen({super.key, required this.items});
  final CartModel items;

  @override
  State<detailsScreen> createState() => _detailsScreenState();
}

class _detailsScreenState extends State<detailsScreen> {
  String ? selectedSize;
  final List<String> sizes = ["8", "10", "38", "40"];
  bool isAdding = false;
  final CartService _cartService = CartService();
  Future<void> _addToCart(BuildContext context) async {
    if (selectedSize == null) {
      showMySnackBar(
        msg: "Please select the size first .",
        type: AnimatedSnackBarType.warning,
        context: context,
      );
      return;
    }
    setState(() => isAdding = true);
    await _cartService.addToCart(
      context: context,
      product: widget.items,
      size: selectedSize!,
    );
    if (mounted) setState(() => isAdding = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  widget.items.image,
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 64,
                left: 20,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },

                  child: CircleAvatar(
                    backgroundColor: Color(0xffD3D0D0),

                    child: Icon(
                      Icons.arrow_back,
                      color: Color(0xff000000),
                      size: 23,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 64,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.items.isFavorite = !widget.items.isFavorite;
                    });
                  },
                  child: CircleAvatar(
                    backgroundColor: Color(0xffD3D0D0),
                    child: Icon(
                      widget.items.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.items.isFavorite
                          ? Colors.red
                          : Color(0xff7C7979),
                      size: 23,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8, right: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.items.itemName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff000000),
                      ),
                    ),
                    Text(
                      widget.items.price,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff6055D8),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.star, color: Color(0xffFFC107)),
                    Text(
                      '4.5',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff000000),
                      ),
                    ),
                    SizedBox(width: 2),
                    Text(
                      '(20 Review)',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff7D7A7A),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000000),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Culpa aliquam consequuntur veritatis at consequuntur praesentium beatae temporibus nobis. Velit dolorem facilis neque autem. Itaque voluptatem expedita qui eveniet id veritatis eaque. Blanditiis quia placeat nemo. Nobis laudantium nesciunt perspiciatis sit eligendi.",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff9B9999),
                  ),
                ),
                SizedBox(height: 24),
                Text(
                  "size",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff000000),
                  ),
                ),
                Wrap(
                  spacing: 6,
                  children: sizes.map((size) {
                    final bool selected = selectedSize == size;
                    return ChoiceChip(
                      label: Text(size),
                      selected: selected,
                      onSelected: (_) {
                        setState(() {
                          selectedSize = size;
                        });
                      },
                      selectedColor: Color(0xffFFFFFF),
                      backgroundColor: Color(0xffFFFFFF),
                      labelStyle: TextStyle(
                        color: selected ? Color(0xff9E9E9E) : Color(0xff000000),
                        fontWeight: FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Color(0xffCFCDCD)),
                      ),
                      showCheckmark: false,
                    );
                  }).toList(),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: isAdding ? null : () => _addToCart(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff6055D8),
                        fixedSize: Size.fromWidth(250),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: isAdding
                          ? SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : Text(
                              "Buy Now",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xffFFFFFF),
                              ),
                            ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => cartScreen()),
                        );
                      },
                      child: Container(
                        width: 90,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xffF8F7F7),
                        ),
                        child: Icon(
                          Icons.shopping_bag,
                          color: Color(0xff9E9E9E),
                          size: 23,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
