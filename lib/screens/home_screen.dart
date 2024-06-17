import 'package:flutter/material.dart';
import 'package:flutter_store/db/database_helper.dart';
import 'package:flutter_store/models/user.dart';
import 'package:flutter_store/screens/profile_screen.dart';
import 'package:flutter_store/screens/product_list_screen.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({required this.user});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _initializeProducts();
  }

  Future<void> _initializeProducts() async {
    await _dbHelper.insertSampleProducts(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: widget.user),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCategoryButton('Headphones', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(category: 'Headphones', user: widget.user),
                ),
              );
            }),
            SizedBox(height: 20),
            _buildCategoryButton('Smartphones', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(category: 'Smartphones', user: widget.user),
                ),
              );
            }),
            SizedBox(height: 20),
            _buildCategoryButton('Laptops', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(category: 'Laptops', user: widget.user),
                ),
              );
            }),
            SizedBox(height: 20),
            _buildCategoryButton('Home Appliances', () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductListScreen(category: 'Home Appliances', user: widget.user),
                ),
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/cart');
        },
        child: Icon(Icons.shopping_cart),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildCategoryButton(String category, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.all(20.0),
          textStyle: TextStyle(fontSize: 18),
        ),
        child: Text(category),
      ),
    );
  }
}
