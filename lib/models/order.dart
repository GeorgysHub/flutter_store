import 'dart:convert';
import 'package:flutter_store/models/product.dart';

class Order {
  final int id;
  final String userId;
  final List<Product> products;
  final double totalAmount;
  final String date;

  Order({
    required this.id,
    required this.userId,
    required this.products,
    required this.totalAmount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'products': jsonEncode(products.map((product) => product.toMap()).toList()),
      'totalAmount': totalAmount,
      'date': date,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      userId: map['userId'],
      products: (jsonDecode(map['products']) as List<dynamic>)
          .map((productMap) => Product.fromMap(productMap as Map<String, dynamic>))
          .toList(),
      totalAmount: map['totalAmount'],
      date: map['date'],
    );
  }
}
