import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/screens/login_screen.dart';
import 'package:flutter_store/screens/register_screen.dart';
import 'package:flutter_store/screens/home_screen.dart';
import 'package:flutter_store/screens/product_list_screen.dart';
import 'package:flutter_store/screens/cart_screen.dart';
import 'package:flutter_store/screens/checkout_screen.dart';
import 'package:flutter_store/screens/delivery_screen.dart';
import 'package:flutter_store/screens/confirmation_screen.dart';
import 'package:flutter_store/screens/success_screen.dart';
import 'package:flutter_store/screens/orders_screen.dart';
import 'package:flutter_store/screens/profile_screen.dart';
import 'package:flutter_store/models/user.dart';
import 'package:flutter_store/providers/cart_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        title: 'Tech Shop',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen(),
        routes: {
          '/login': (context) => LoginScreen(),
          '/register': (context) => RegisterScreen(),
          '/home': (context) {
            final user = ModalRoute.of(context)!.settings.arguments as User;
            return HomeScreen(user: user);
          },
          '/products': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return ProductListScreen(category: args['category'], user: args['user']);
          },
          '/cart': (context) => CartScreen(),
          '/checkout': (context) {
            final user = ModalRoute.of(context)!.settings.arguments as User;
            return CheckoutScreen(user: user);
          },
          '/delivery': (context) {
            final user = ModalRoute.of(context)!.settings.arguments as User;
            return DeliveryScreen(user: user);
          },
          '/confirmation': (context) {
            final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
            if (args == null) {
              return Scaffold(
                body: Center(
                  child: Text('No confirmation data provided.'),
                ),
              );
            }

            final user = args['user'] as User?;
            if (user == null) {
              return Scaffold(
                body: Center(
                  child: Text('No user data provided.'),
                ),
              );
            }

            return ConfirmationScreen(
              deliveryOption: args['deliveryOption'] as String,
              paymentOption: args['paymentOption'] as String,
              address: args['address'] as Map<String, String>,
              instructions: args['instructions'] as String,
              user: user,
            );
          },
          '/success': (context) {
            final user = ModalRoute.of(context)?.settings.arguments as User?;
            if (user == null) {
              return Scaffold(
                body: Center(
                  child: Text('No user data provided.'),
                ),
              );
            }
            return SuccessScreen(user: user);
          },
          '/orders': (context) {
            final user = ModalRoute.of(context)?.settings.arguments as User?;
            if (user == null) {
              return Scaffold(
                body: Center(
                  child: Text('No user data provided.'),
                ),
              );
            }
            return OrdersScreen(user: user);
          },
          '/profile': (context) {
            final user = ModalRoute.of(context)?.settings.arguments as User?;
            if (user == null) {
              return Scaffold(
                body: Center(
                  child: Text('No user data provided.'),
                ),
              );
            }
            return ProfileScreen(user: user);
          },
        },
      ),
    );
  }
}
