class CartModel {
  final String id;
  final String image;
  final String itemName;
  final String price;
  bool isFavorite;
  final String? size;
  CartModel({
    required this.id,
    required this.image,
    required this.itemName,
    required this.price,
    this.isFavorite = false,
    this.size,
  });

  factory CartModel.fromMap(String id, Map<String, dynamic> map) {
    return CartModel(
      id: id,
      image: map['image'],
      itemName: map['itemName'],
      price: map['price'],
      isFavorite: map['isFavorite'] ?? false,
      size: map['size'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'itemName': itemName,
      'price': price,
      'isFavorite': isFavorite,
      'size': size,
    };
  }
}
