import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import '../model/cart_model.dart';
import '../snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _cartRef(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("cart");
  }

  CollectionReference<Map<String, dynamic>> _ordersRef(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("orders");
  }

  Future<void> addToCart({
    required BuildContext context,
    required CartModel product,
    required String size,
  }) async {
    final uid = _uid;
    if (uid == null) {
      return;
    }
    try {
      DocumentReference<Map<String, dynamic>> docRef = _cartRef(uid).doc();
      await docRef.set({
        "id": docRef.id,
        "image": product.image,
        "itemName": product.itemName,
        "price": product.price,
        "isFavorite": product.isFavorite,
        "size": size,
        "createdAt": DateTime.now(),
      });

      if (context.mounted) {
        showMySnackBar(
          msg: "Added to cart",
          type: AnimatedSnackBarType.success,
          context: context,
        );
      }
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showMySnackBar(
          msg: e.message ?? "error during add",
          type: AnimatedSnackBarType.error,
          context: context,
        );
      }
    }
  }

  Stream<List<CartModel>> getCartItems() {
    final uid = _uid;
    if (uid == null) return Stream.empty();
    return _cartRef(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => CartModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }

  Future<void> removeFromCart({
    required BuildContext context,
    required String id,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      await _cartRef(uid).doc(id).delete();
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showMySnackBar(
          msg: e.message ?? "An error occurred during deletion.",
          type: AnimatedSnackBarType.error,
          context: context,
        );
      }
    }
  }

  Future<void> editFavorite({
    required BuildContext context,
    required String id,
    required bool newValue,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      await _cartRef(uid).doc(id).update({'isFavorite': newValue});
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showMySnackBar(
          msg: e.message ?? "Error!",
          type: AnimatedSnackBarType.error,
          context: context,
        );
      }
    }
  }

  double parsePrice(String price) {
    final cleaned = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleaned) ?? 0.0;
  }
  double calculateTotal(List<CartModel> items) {
    double total = 0;
    for (final item in items) {
      total += parsePrice(item.price);
    }
    return total;
  }
  Future<bool> placeOrder({
    required BuildContext context,
    required List<CartModel> cartItems,
    required String name,
    required String phone,
    required String address,
    required String paymentMethod,
  }) async {
    final uid = _uid;
    if (uid == null) return false;
    if (cartItems.isEmpty) return false;

    try {
      final total = calculateTotal(cartItems);
      final orderRef = _ordersRef(uid).doc();

      await orderRef.set({
        "id": orderRef.id,
        "items": cartItems
            .map(
              (item) => {
            "id": item.id,
            "itemName": item.itemName,
            "image": item.image,
            "price": item.price,
            "size": item.size,
          },
        )
            .toList(),
        "total": total,
        "name": name,
        "phone": phone,
        "address": address,
        "paymentMethod": paymentMethod,
        "status": "pending",
        "createdAt": DateTime.now(),
      });
      final batch = FirebaseFirestore.instance.batch();
      for (final item in cartItems) {
        batch.delete(_cartRef(uid).doc(item.id));
      }
      await batch.commit();

      if (context.mounted) {
        showMySnackBar(
          msg: "The order has been successfully confirmed.",
          type: AnimatedSnackBarType.success,
          context: context,
        );
      }
      return true;
    } on FirebaseException catch (e) {
      if (context.mounted) {
        showMySnackBar(
          msg: e.message ?? "An error occurred while processing the request.",
          type: AnimatedSnackBarType.error,
          context: context,
        );
      }
      return false;
    }
  }
}