import 'package:flutter/material.dart';
import 'package:flutter_store/models/product.dart';

class CartProvider with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => _items;

  double get totalAmount =>
      _items.fold(0.0, (sum, item) => sum + item.price);

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
