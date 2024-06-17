import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_store/db/database_helper.dart';
import 'package:flutter_store/models/user.dart';
import 'package:flutter_store/screens/login_screen.dart';
import 'package:flutter_store/screens/home_screen.dart';
import 'package:flutter_store/screens/orders_screen.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  ProfileScreen({required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _dbHelper = DatabaseHelper();
  final ImagePicker _picker = ImagePicker();
  String _avatarPath = '';

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController(text: widget.user.password);
    _avatarPath = widget.user.avatar;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarPath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(File(_avatarPath)),
                  child: _avatarPath == '' ? Icon(Icons.person, size: 50) : null,
                ),
              ),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _buildButton('Update Profile', () async {
                if (_formKey.currentState!.validate()) {
                  User updatedUser = User(
                    id: widget.user.id,
                    username: _usernameController.text,
                    email: _emailController.text,
                    password: _passwordController.text,
                    avatar: _avatarPath,
                  );
                  await _dbHelper.updateUser(updatedUser);
                  Navigator.pop(context);
                }
              }),
              SizedBox(height: 20),
              _buildButton('My Orders', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersScreen(user: widget.user)),
                );
              }),
              SizedBox(height: 20),
              _buildButton('Home', () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen(user: widget.user)),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          padding: EdgeInsets.symmetric(vertical: 16.0),
          textStyle: TextStyle(fontSize: 18),
        ),
        child: Text(text),
      ),
    );
  }
}
