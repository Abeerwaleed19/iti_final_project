import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:iti_project_final/wedgits/profile_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  File? profileImage;

  @override
  void initState() {
    super.initState();
    loadSavedImage();
  }

  Future<void> loadSavedImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? path = prefs.getString('profileImagePath_${user?.uid}');

    if (path != null && path.isNotEmpty) {
      final file = File(path);
      if (await file.exists()) {
        setState(() {
          profileImage = file;
        });
      }
    }
  }

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final String? imagePath = prefs.getString('profileImagePath');
    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);
      if (await file.exists()) {
        if (!mounted) return;
        setState(() {
          profileImage = file;
        });
      }
    }
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        profileImage = File(image.path);
      });

      final prefs = await SharedPreferences.getInstance();
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        await prefs.setString(
          'profileImagePath_${currentUser.uid}',
          image.path,
        );
      }
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('rememberMe', false);

    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(builder: (context) => const Login()),

      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: SafeArea(
          child: Column(
            spacing: 16,

            children: [
              GestureDetector(
                onTap: pickImage,

                child: CircleAvatar(
                  radius: 50,

                  backgroundColor: Color(0xFF4A148C),

                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : const AssetImage('assets/images/profile_img.png')
                            as ImageProvider,
                ),
              ),
              Text(
                "${user?.displayName ?? 'User'}",

                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: "Poppins",
                ),
              ),

              SizedBox(height: 16),
              ProfileItem(textValue: "Profile", icon: "assets/icon/user.svg"),
              ProfileItem(
                textValue: "Setting",
                icon: "assets/icon/setting.svg",
              ),
              ProfileItem(
                textValue: "Contact",
                icon: "assets/icon/contact.svg",
              ),
              ProfileItem(
                textValue: "Share App",
                icon: "assets/icon/share.svg",
              ),
              ProfileItem(textValue: "Help", icon: "assets/icon/help.svg"),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  logout(context);
                },
                child: const Text(
                  "Sign Out",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF55F1F),
                    fontFamily: "Poppins",
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
