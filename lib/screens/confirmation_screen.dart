import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/providers/cart_provider.dart';
import 'package:flutter_store/models/user.dart';
import 'package:flutter_store/models/order.dart';
import 'package:flutter_store/db/database_helper.dart';
import 'success_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final String deliveryOption;
  final String paymentOption;
  final Map<String, String> address;
  final String instructions;
  final User user;

  ConfirmationScreen({
    required this.deliveryOption,
    required this.paymentOption,
    required this.address,
    required this.instructions,
    required this.user,
  });

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Confirm Your Order'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Delivery Option'),
            _buildInfoCard(deliveryOption),
            SizedBox(height: 10),
            _buildSectionTitle('Payment Option'),
            _buildInfoCard(paymentOption),
            SizedBox(height: 10),
            _buildSectionTitle('Delivery Address'),
            _buildInfoCard(
              '${address['City']}, ${address['Region']}\n'
              '${address['Street']}, ${address['Building']}, ${address['Apartment']}\n'
              'Entrance: ${address['Entrance']}, Intercom: ${address['Intercom']}',
            ),
            SizedBox(height: 10),
            _buildSectionTitle('Special Instructions'),
            _buildInfoCard(instructions),
            SizedBox(height: 20),
            _buildSectionTitle('Order Summary'),
            Expanded(
              child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) {
                  final product = cart.items[index];
                  return Card(
                    child: ListTile(
                      leading: Image.network(product.imageUrl),
                      title: Text(product.name),
                      subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                      trailing: Text('x1'),
                    ),
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
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  
                  final newOrder = Order(
                    id: DateTime.now().millisecondsSinceEpoch,
                    userId: user.id.toString(),
                    products: cart.items,
                    totalAmount: cart.totalAmount,
                    date: DateTime.now().toString(),
                  );

                  
                  await _dbHelper.insertOrder(newOrder);

                  
                  cart.clearCart();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SuccessScreen(user: user)),
                  );
                },
                child: Text('Оплатить'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoCard(String content) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          content,
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
