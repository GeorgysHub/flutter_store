import 'package:flutter/material.dart';
import 'package:flutter_store/models/user.dart';
import 'package:flutter_store/models/order.dart';
import 'package:flutter_store/db/database_helper.dart';
import 'profile_screen.dart';

class OrdersScreen extends StatelessWidget {
  final User user;

  OrdersScreen({required this.user});

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(user: user)),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Order>>(
        future: _dbHelper.getOrdersByUserId(user.id.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found.'));
          } else {
            final orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  child: ListTile(
                    title: Text('Order #${order.id}'),
                    subtitle: Text('Date: ${order.date}\nTotal: \$${order.totalAmount.toStringAsFixed(2)}'),
                    onTap: () {
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
