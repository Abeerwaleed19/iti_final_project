import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:iti_project_final/profile_screen.dart';
import 'cartScreen.dart';
import 'details.dart';
import 'favoritescreen.dart';
import 'model/cart_model.dart';
import 'network/favorite service.dart';
import 'product-list.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static List<CartModel> featuredProducts = [
    CartModel(
      id: 'f1',
      image: 'assets/images/Watch.jpg',
      itemName: 'Watch',
      price: '\$40',
    ),
    CartModel(
      id: 'f2',
      image: 'assets/images/Nike Shoes.jpg',
      itemName: 'Nike Shoes',
      price: '\$430',
    ),
    CartModel(
      id: 'f3',
      image: 'assets/images/Airpods.jpg',
      itemName: 'AirPods',
      price: '\$333',
    ),
  ];

  static List<CartModel> popularProducts = [
    CartModel(
      id: 'p1',
      image: 'assets/images/LG TV.jpg',
      itemName: 'LG TV',
      price: '\$330',
    ),
    CartModel(
      id: 'p2',
      image: 'assets/images/Hoodie.jpg',
      itemName: 'Hoodie',
      price: '\$50',
    ),
    CartModel(
      id: 'p3',
      image: 'assets/images/Jacket.jpg',
      itemName: 'Jacket',
      price: '\$400',
    ),
  ];

  static void resetFavorites() {
    for (var product in featuredProducts) {
      product.isFavorite = false;
    }
    for (var product in popularProducts) {
      product.isFavorite = false;
    }
  }

  String capitalizeWords({String? text = ""}) {
    return text!
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;

          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final PageController bannerController = PageController();

  int currentBanner = 0;

  Timer? bannerTimer;

  File? profileImage;

  @override
  void initState() {
    super.initState();

    loadProfileImage();

    bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;

      int nextPage = currentBanner + 1;

      if (nextPage >= 3) {
        nextPage = 0;
      }

      bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  Future<void> loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) return;

    final String? imagePath = prefs.getString(
      'profileImagePath_${currentUser.uid}',
    );

    if (imagePath != null && imagePath.isNotEmpty) {
      final file = File(imagePath);

      if (await file.exists()) {
        if (!mounted) return;
        setState(() {
          profileImage = file;
        });
      }
    } else {
      if (!mounted) return;
      setState(() {
        profileImage = null;
      });
    }
  }

  @override
  void dispose() {
    bannerTimer?.cancel();
    bannerController.dispose();

    super.dispose();
  }

  void openSearchScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchScreen()),
    );
  }

  Future<void> openProfileScreen() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),
    );

    await loadProfileImage();
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    final String userName = user?.displayName?.trim().isNotEmpty == true
        ? user!.displayName!.trim()
        : (user?.email?.split('@').first ?? 'User');

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              const SizedBox(height: 10),
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,

                    backgroundColor: const Color(0xFF4A148C),

                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : null,

                    child: profileImage == null
                        ? Text(
                            userName.isNotEmpty
                                ? userName[0].toUpperCase()
                                : 'U',

                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "Hello!, ${widget.capitalizeWords(text: userName)}",

                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {},

                    icon: const Icon(Icons.notifications_none, size: 28),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              GestureDetector(
                onTap: openSearchScreen,

                child: Container(
                  height: 50,

                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: const AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',

                        hintStyle: TextStyle(color: Colors.grey),

                        prefixIcon: Icon(Icons.search, color: Colors.grey),

                        border: InputBorder.none,

                        contentPadding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 180,

                child: PageView(
                  controller: bannerController,

                  onPageChanged: (index) {
                    setState(() {
                      currentBanner = index;
                    });
                  },

                  children: const [BannerCard(), BannerCard(), BannerCard()],
                ),
              ),

              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  BannerDot(isActive: currentBanner == 0),

                  BannerDot(isActive: currentBanner == 1),

                  BannerDot(isActive: currentBanner == 2),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Featured',

                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductsScreen(),
                        ),
                      );
                    },

                    child: const Text('See All'),
                  ),
                ],
              ),

              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: HomeProductCard(
                      product: HomeScreen.featuredProducts[0],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: HomeProductCard(
                      product: HomeScreen.featuredProducts[1],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: HomeProductCard(
                      product: HomeScreen.featuredProducts[2],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Most Popular',

                    style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProductsScreen(),
                        ),
                      );
                    },

                    child: const Text('See All'),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: HomeProductCard(
                      product: HomeScreen.popularProducts[0],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: HomeProductCard(
                      product: HomeScreen.popularProducts[1],
                    ),
                  ),

                  const SizedBox(width: 8),

                  Expanded(
                    child: HomeProductCard(
                      product: HomeScreen.popularProducts[2],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 25),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffF8F7F7),
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF4A148C),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,

        onTap: (index) async {
          setState(() {
            currentIndex = index;
          });

          // Search
          if (index == 1) {
            openSearchScreen();
          }

          // Favorites
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Favoritesscreen()),
            );
          }

          // Cart
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => cartScreen()),
            );
          }

          // Profile
          if (index == 4) {
            await openProfileScreen();
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: '',
          ),

          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            activeIcon: Icon(Icons.shopping_bag),
            label: '',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: '',
          ),
        ],
      ),
    );
  }
}

class BannerCard extends StatelessWidget {
  const BannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),

      decoration: BoxDecoration(
        color: const Color(0xFF4A148C),

        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 5),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: const [
                  Text(
                    'Get Winter Discount',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Text(
                    '20% off',

                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),

                  SizedBox(height: 8),

                  Text(
                    'For Children',

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),

              child: Image.asset(
                'assets/images/banner_product.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BannerDot extends StatelessWidget {
  final bool isActive;

  const BannerDot({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),

      margin: const EdgeInsets.symmetric(horizontal: 4),

      width: isActive ? 22 : 8,

      height: 5,

      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF4A148C) : Colors.grey.shade300,

        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}


class HomeProductCard extends StatefulWidget {
  final CartModel product;

  const HomeProductCard({
    super.key,
    required this.product,
  });

  @override
  State<HomeProductCard> createState() => _HomeProductCardState();
}

class _HomeProductCardState extends State<HomeProductCard> {
  final FavoriteService _favoriteService = FavoriteService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                detailsScreen(
                  items: widget.product,
                ),
          ),
        );

        if (mounted) {
          setState(() {});
        }
      },
      child: Container(
        height: 175,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(15),
                    ),
                    child: SizedBox.expand(
                      child: Image.asset(
                        widget.product.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  // Favorite button
                  Positioned(
                    top: 0,
                    right: 0,
                    child: StreamBuilder<bool>(
                      stream: _favoriteService.isFavoriteStream(
                        widget.product.id,
                      ),
                      builder: (context, snapshot) {
                        final isFavorite = snapshot.data ?? false;

                        return IconButton(
                          onPressed: () async {
                            await _favoriteService.toggleFavorite(
                              context: context,
                              product: widget.product,
                              isCurrentlyFavorite: isFavorite,
                            );
                          },
                          icon: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isFavorite
                                ? Colors.red
                                : Colors.grey,
                            size: 24,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                widget.product.itemName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),

            const SizedBox(height: 4),

            Text(
              widget.product.price,
              style: const TextStyle(
                color: Color(0xFF4A148C),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
