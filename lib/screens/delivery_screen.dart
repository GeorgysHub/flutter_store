import 'package:flutter/material.dart';
import 'package:flutter_store/models/user.dart';

class DeliveryScreen extends StatefulWidget {
  final User user;

  DeliveryScreen({required this.user});

  @override
  _DeliveryScreenState createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  String _selectedDeliveryOption = 'standard';
  String _selectedPaymentOption = 'creditCard';

  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _regionController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _apartmentController = TextEditingController();
  final _entranceController = TextEditingController();
  final _intercomController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    _regionController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _apartmentController.dispose();
    _entranceController.dispose();
    _intercomController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Delivery Option'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Delivery Options',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text('Standard Delivery'),
                subtitle: Text('3-5 business days'),
                trailing: Text('\$5.00'),
                leading: Radio<String>(
                  value: 'standard',
                  groupValue: _selectedDeliveryOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedDeliveryOption = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Express Delivery'),
                subtitle: Text('1-2 business days'),
                trailing: Text('\$10.00'),
                leading: Radio<String>(
                  value: 'express',
                  groupValue: _selectedDeliveryOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedDeliveryOption = value!;
                    });
                  },
                ),
              ),
              ListTile(
                title: Text('Next-Day Delivery'),
                subtitle: Text('Next business day'),
                trailing: Text('\$20.00'),
                leading: Radio<String>(
                  value: 'nextDay',
                  groupValue: _selectedDeliveryOption,
                  onChanged: (value) {
                    setState(() {
                      _selectedDeliveryOption = value!;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Payment Options',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Container(
                height: 120,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildPaymentOption('Credit Card', 'creditCard'),
                    _buildPaymentOption('PayPal', 'paypal'),
                    _buildPaymentOption('Google Pay', 'googlePay'),
                    _buildPaymentOption('Apple Pay', 'applePay'),
                    _buildPaymentOption('При получении', 'cashOnDelivery'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Delivery Address',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildAddressField('City', _cityController),
              SizedBox(height: 10),
              _buildAddressField('Region', _regionController),
              SizedBox(height: 10),
              _buildAddressField('Street', _streetController),
              SizedBox(height: 10),
              _buildAddressField('Building', _buildingController),
              SizedBox(height: 10),
              _buildAddressField('Apartment', _apartmentController),
              SizedBox(height: 10),
              _buildAddressField('Entrance', _entranceController),
              SizedBox(height: 10),
              _buildAddressField('Intercom', _intercomController),
              SizedBox(height: 20),
              Text(
                'Special Instructions for the Courier',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _instructionsController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Instructions',
                ),
                maxLines: 3,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(
                      context,
                      '/confirmation',
                      arguments: {
                        'deliveryOption': _selectedDeliveryOption,
                        'paymentOption': _selectedPaymentOption,
                        'address': {
                          'City': _cityController.text,
                          'Region': _regionController.text,
                          'Street': _streetController.text,
                          'Building': _buildingController.text,
                          'Apartment': _apartmentController.text,
                          'Entrance': _entranceController.text,
                          'Intercom': _intercomController.text,
                        },
                        'instructions': _instructionsController.text,
                        'user': widget.user,
                      },
                    );
                  }
                },
                child: Center(
                  child: Text('Proceed to Payment'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressField(String label, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  Widget _buildPaymentOption(String name, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentOption = value;
        });
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: _selectedPaymentOption == value ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.payment,
              color: _selectedPaymentOption == value ? Colors.white : Colors.black,
            ),
            SizedBox(height: 8.0),
            Text(
              name,
              style: TextStyle(
                color: _selectedPaymentOption == value ? Colors.white : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
