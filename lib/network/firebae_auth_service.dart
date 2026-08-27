import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../utills/snackbar_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class FirebaseAuthService {
  static Future<bool> createAccount(
    String email,
    String password,
    String name,
  ) async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(name);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(credential.user!.uid)
          .set({
        "name": name,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      });

      return Future.value(true);

    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        BotToastService.showErrorMessage("The password provided is too weak.");

        return Future.value(false);
      } else if (e.code == 'email-already-in-use') {
        BotToastService.showErrorMessage(
          'The account already exists for that email.',
        );
        return Future.value(false);
      }
      return Future.value(false);
    } catch (e) {
      BotToastService.showErrorMessage('Something Went Wrong.');
      return Future.value(false);
    }
  }

  static Future<bool> login(String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Future.value(true);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        BotToastService.showErrorMessage('No user found for that email.');
        return Future.value(false);
      } else if (e.code == 'invalid-credential') {
        BotToastService.showErrorMessage('Email or password is incorrect');
        return Future.value(false);
      }
      return Future.value(false);
    } catch (e) {
      BotToastService.showErrorMessage('Something Went Wrong..');
      return Future.value(false);
    }
  }

  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
    static Future<UserCredential> signInWithGoogle() async {
      await _googleSignIn.initialize(
        serverClientId: dotenv.env["CLIENT_SERVER_ID"],
      );
      final GoogleSignInAccount result = await _googleSignIn.authenticate();
      final googleAuth = result.authentication;
      final credentials = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );
      final userCredential = await FirebaseAuth.instance.signInWithCredential(
        credentials,
      );

      final userDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set({
          "name": userCredential.user!.displayName ?? "",
          "email": userCredential.user!.email ?? "",
          "createdAt": FieldValue.serverTimestamp(),
        });
      }
      return userCredential;
    }
}
