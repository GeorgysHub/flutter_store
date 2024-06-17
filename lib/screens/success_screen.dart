import 'package:flutter/material.dart';
import 'package:flutter_store/models/user.dart';
import 'orders_screen.dart';

class SuccessScreen extends StatelessWidget {
  final User user;

  SuccessScreen({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Successful'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            SizedBox(height: 20),
            Text(
              'Payment Successful!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersScreen(user: user)),
                );
              },
              child: Text('Go to My Orders'),
            ),
          ],
        ),
      ),
    );
  }
}
