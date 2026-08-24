import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iti_project_final/utills/snackbar_service.dart';
import 'package:iti_project_final/wedgits/button_wedgit.dart';
import 'package:iti_project_final/wedgits/text_input.dart';
import 'home.dart';
import 'login.dart';
import 'network/firebae_auth_service.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              spacing: 32,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFF6055D8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Get Winter Discount",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: "Roboto",
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              "20% Off",
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                fontFamily: "Roboto",
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "For Children",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                          ),
                          child: Image.asset(
                            "assets/images/banner_product.png",
                            height: 130,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _formKey,
                  child: Column(
                    spacing: 4,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Enter your name ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: "Roboto",
                        ),
                      ),
                      TextInput(
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter name";
                          }
                          return null;
                        },
                        controller: _nameController,
                        hintTextValue: "user@gmail.com",
                      ),
                      Text(
                        "Email ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: "Roboto",
                        ),
                      ),
                      TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }

                          final emailRegex = RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );

                          if (!emailRegex.hasMatch(value)) {
                            return 'Please enter a valid email';
                          }

                          return null;
                        },
                        controller: _emailController,
                        hintTextValue: "user@gmail.com",
                      ),

                      Text(
                        "Password  ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: "Roboto",
                        ),
                      ),
                      TextInput(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }

                          final passwordRegex = RegExp(
                            r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>]).{8,}$',
                          );

                          if (!passwordRegex.hasMatch(value)) {
                            return 'Password must contain 8+ characters,\n'
                                'uppercase, lowercase, number and special character';
                          }

                          return null;
                        },
                        controller: _passwordController,

                        hintTextValue: "*********",
                        suffixIcon: const Icon(Icons.visibility_off_outlined),
                        isPassword: true,
                      ),

                      Text(
                        "Confirm Password  ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: "Roboto",
                        ),
                      ),
                      TextInput(
                        validator: (value) {
                          if (value != _passwordController.text) {
                            return "Passwords Don't Match";
                          }
                          return null;
                        },
                        controller: _confirmPasswordController,
                        hintTextValue: "*********",
                        suffixIcon: const Icon(Icons.visibility_off_outlined),
                        isPassword: true,
                      ),

                      SizedBox(height: 32),
                      ButtonWidget(
                        btnText: "Create account",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            EasyLoading.show();
                            FirebaseAuthService.createAccount(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text,
                            ).then((value) {
                              EasyLoading.dismiss();
                              if (value) {
                                HomeScreen.resetFavorites();
                                BotToastService.showSuccessMessage(
                                  "Account Had been created Successfully!",
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (builder) => Login(),
                                  ),
                                );
                              }
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Colors.black.withValues(alpha: 0.5),
                              fontFamily: "Roboto",
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (builder) => Login(),
                                ),
                              );
                            },
                            child: Text(
                              "Login ",
                              style: TextStyle(
                                color: Color(0xFF233B26),
                                decoration: TextDecoration.underline,
                                decorationColor: Color(0xFF233B26),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Divider(
                              indent: 40,
                              color: Colors.black.withValues(alpha: 0.2),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text("Or"),
                          ),

                          Expanded(
                            child: Divider(
                              endIndent: 40,
                              color: Colors.black.withValues(alpha: 0.2),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),

                      ButtonWidget(
                        onPressed: () async {
                          try {
                            final UserCredential userCredential =
                                await FirebaseAuthService.signInWithGoogle();

                            if (!context.mounted) return;

                            if (userCredential.user != null) {
                              HomeScreen.resetFavorites();
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            print("Google Sign In Error: $e");
                          }
                        },
                        btnText: "Sign up with Google",
                        img: Image.asset("assets/images/google.png"),

                        btnColor: Colors.white,
                        borderColor: Colors.black.withValues(alpha: 0.1),
                        btnTextColor: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
