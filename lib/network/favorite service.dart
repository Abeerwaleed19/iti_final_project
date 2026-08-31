import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import '../model/cart_model.dart';
import '../snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  CollectionReference<Map<String, dynamic>> _favRef(String uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("favorites");
  }

  Future<void> addToFavorite({
    required BuildContext context,
    required CartModel product,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      final data = product.toMap();
      data['isFavorite'] = true;
      data['createdAt'] = DateTime.now();

      await _favRef(uid).doc(product.id).set(data);

      if (context.mounted) {
        showMySnackBar(
          msg: "Added to favorites",
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

  Future<void> removeFromFavorite({
    required BuildContext context,
    required String productId,
  }) async {
    final uid = _uid;
    if (uid == null) return;

    try {
      await _favRef(uid).doc(productId).delete();
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
  Future<void> toggleFavorite({
    required BuildContext context,
    required CartModel product,
    required bool isCurrentlyFavorite,
  }) async {
    if (isCurrentlyFavorite) {
      await removeFromFavorite(context: context, productId: product.id);
    } else {
      await addToFavorite(context: context, product: product);
    }
  }

  Future<bool> isFavorite(String productId) async {
    final uid = _uid;
    if (uid == null) return false;
    final doc = await _favRef(uid).doc(productId).get();
    return doc.exists;
  }

  Stream<bool> isFavoriteStream(String productId) {
    final uid = _uid;
    if (uid == null) return Stream.value(false);
    return _favRef(uid).doc(productId).snapshots().map((doc) => doc.exists);
  }

  Stream<List<CartModel>> getFavorites() {
    final uid = _uid;
    if (uid == null) return Stream.empty();
    return _favRef(uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map((doc) => CartModel.fromMap(doc.id, doc.data()))
          .toList(),
    );
  }
}