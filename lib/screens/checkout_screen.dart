import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/providers/cart_provider.dart';
import 'package:flutter_store/models/user.dart';
import 'delivery_screen.dart';

class CheckoutScreen extends StatelessWidget {
  final User user;

  CheckoutScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final product = cart.items[index];
                  return ListTile(
                    leading: Image.network(product.imageUrl),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: Text('x1'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total: \$${cart.totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeliveryScreen(user: user)),
                );
              },
              child: Center(
                child: Text('Proceed to Payment'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
