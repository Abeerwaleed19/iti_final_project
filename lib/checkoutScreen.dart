import 'package:flutter/material.dart';
import 'model/cart_model.dart';
import 'network/cartService.dart';

class checkoutScreen extends StatefulWidget {
  const checkoutScreen({
    super.key,
    required this.cartItems,
    required this.total,
  });

  final List<CartModel> cartItems;
  final double total;

  @override
  State<checkoutScreen> createState() => _checkoutScreenState();
}

class _checkoutScreenState extends State<checkoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final CartService _cartService = CartService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _paymentMethod = "Cash on Delivery";
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isPlacingOrder = true);

    final success = await _cartService.placeOrder(
      context: context,
      cartItems: widget.cartItems,
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
      paymentMethod: _paymentMethod,
    );

    if (!mounted) return;
    setState(() => _isPlacingOrder = false);

    if (success) {
      Navigator.popUntil(context, (route) => route.isFirst);
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Color(0xffF8F7F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Checkout",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xff000000),
          ),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          children: [
            Text(
              "Delivery Details",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                  color: Colors.pink
              ),
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration("Full Name"),
              validator: (value) =>
              (value == null || value.trim().isEmpty) ? "Please write your name." : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputDecoration("Phone number"),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? "Please write your phone number."
                  : null,
            ),
            SizedBox(height: 12),
            TextFormField(
              controller: _addressController,
              maxLines: 2,
              decoration: _inputDecoration("Detailed address"),
              validator: (value) =>
              (value == null || value.trim().isEmpty) ? "Please write your title." : null,
            ),
            SizedBox(height: 24),
            Text(
              "payment method",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                  color: Colors.pink
              ),
            ),
            RadioListTile<String>(
              value: "Cash on Delivery",
              groupValue: _paymentMethod,
              activeColor: Color(0xff6055D8),
              title: Text("Cash on Delivery"),
              onChanged: (value) => setState(() => _paymentMethod = value!),
            ),
            RadioListTile<String>(
              value: "Card",
              groupValue: _paymentMethod,
              activeColor: Color(0xff6055D8),
              title: Text("credit card"),
              onChanged: (value) => setState(() => _paymentMethod = value!),
            ),
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xffF8F7F7),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ...widget.cartItems.map(
                        (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${item.itemName}${item.size != null ? ' (${item.size})' : ''}",
                              style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff6055D8)),
                            ),
                          ),
                          Text(item.price,style: TextStyle(fontWeight: FontWeight.w500, color: Color(0xff6055D8))),
                        ],
                      ),
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total", style: TextStyle(fontWeight: FontWeight.w700)),
                      Text(
                        widget.total.toStringAsFixed(2),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xff6055D8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isPlacingOrder ? null : _placeOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff6055D8),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isPlacingOrder
                    ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  "Order Confirmation",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}