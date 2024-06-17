class Product {
  final int? id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
    };
    if (id != null && id != 0) {
      map['id'] = id!;
    }
    return map;
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      category: map['category'],
      imageUrl: map['imageUrl'] ?? 'https://via.placeholder.com/150',
    );
  }
}
