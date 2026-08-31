import 'package:flutter/material.dart';
import '../model/cart_model.dart';
import 'network/favorite service.dart';

class Favoritesscreen extends StatefulWidget {
  const  Favoritesscreen({super.key});

  @override
  State<Favoritesscreen> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<Favoritesscreen> {
  final FavoriteService _favoriteService = FavoriteService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(title: const Text("Favorites" , style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xff000000),
      ),),centerTitle: true,backgroundColor: Colors.white,),
      body: StreamBuilder<List<CartModel>>(
        stream: _favoriteService.getFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text(
                "No favorites yet",
                style: TextStyle(fontSize: 16, color: Colors.pink),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return _FavoriteCard(
                item: item,
                onRemove: () => _favoriteService.removeFromFavorite(
                  context: context,
                  productId: item.id,
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final CartModel item;
  final VoidCallback onRemove;

  const _FavoriteCard({required this.item, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffF8F7F7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                item.image,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.itemName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(item.price, style: const TextStyle(   fontWeight: FontWeight.bold,
                      fontSize: 15,color: Colors.pink)),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              onPressed: onRemove,
            ),
          ],
        ),
    );
  }
}