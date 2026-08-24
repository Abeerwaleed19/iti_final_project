import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:iti_project_final/signup.dart';
import 'package:iti_project_final/wedgits/button_wedgit.dart';
import 'package:iti_project_final/wedgits/text_input.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'network/firebae_auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool rememberMe = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
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
                        "Email ",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontFamily: "Roboto",
                        ),
                      ),
                      TextInput(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Your Email";
                          }
                          return null;
                        },
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
                        controller: _passwordController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please Enter Your Password";
                          }
                          return null;
                        },
                        hintTextValue: "Enter your password",
                        suffixIcon: const Icon(Icons.visibility_off_outlined),
                        isPassword: true,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            side: BorderSide(color: Color(0xFF0A97B0)),
                            activeColor: Color(0xFF0A97B0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadiusGeometry.circular(4),
                            ),
                            onChanged: (value) {
                              setState(() {
                                rememberMe = value ?? false;
                              });
                            },
                          ),
                          Text(
                            "Remember Me",
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          Text(
                            "Forget password? ",
                            style: TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF233B26),
                              decoration: TextDecoration.underline,
                              decorationColor: Color(0xFF233B26),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      ButtonWidget(
                        btnText: "Login",
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            EasyLoading.show();

                            final value = await FirebaseAuthService.login(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                            );
                            EasyLoading.dismiss();
                            if (value) {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              await prefs.setBool('rememberMe', rememberMe);
                              HomeScreen.resetFavorites();
                              if (!context.mounted) return;
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don’t  have an account?  ",
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
                                  builder: (builder) => Signup(),
                                ),
                              );
                            },
                            child: Text(
                              "Sign up ",
                              style: TextStyle(
                                fontFamily: "Roboto",
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
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
                                  builder: (context) => const HomeScreen(),
                                ),
                                (route) => false,
                              );
                            }
                          } catch (e) {
                            print("Google Sign In Error: $e");
                          }
                        },
                        btnText: "Login with Google",
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
