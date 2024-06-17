import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return ListView.builder(
            itemCount: cart.items.length,
            itemBuilder: (context, index) {
              final product = cart.items[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                trailing: IconButton(
                  icon: Icon(Icons.remove_shopping_cart),
                  onPressed: () {
                    cart.removeProduct(product);
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: Consumer<CartProvider>(
        builder: (context, cart, child) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                
              },
              child: Text('Checkout (\$${cart.totalAmount.toStringAsFixed(2)})'),
            ),
          );
        },
      ),
    );
  }
}
