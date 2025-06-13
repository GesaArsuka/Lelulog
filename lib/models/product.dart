class Product {
  final int id;
  final String name;
  final int price;
  final int stock;
  final String? topNotes;
  final String? heartNotes;
  final String? baseNotes;
  final String? imagePath;
  final int? discount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    this.topNotes,
    this.heartNotes,
    this.baseNotes,
    this.imagePath,
    this.discount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      stock: json['stock'] ?? 0,
      topNotes: json['top_notes'],
      heartNotes: json['heart_notes'],
      baseNotes: json['base_notes'],
      imagePath: json['image_path'], 
      discount: json['discount'],
    );
  }
}
