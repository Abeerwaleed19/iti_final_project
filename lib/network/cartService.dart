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
    if (uid == null) return  Stream.empty();

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
}