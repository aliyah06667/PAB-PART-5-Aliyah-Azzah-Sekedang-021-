import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView(
                children: cart.itemsList.map((item) {
                  return ListTile(
                    title: Text(item.product.name),
                    subtitle: Text('${item.quantity} x Rp ${item.product.price.toStringAsFixed(0)}'),
                    trailing: Text('Rp ${item.totalPrice.toStringAsFixed(0)}'),
                  );
                }).toList(),
              ),
            ),
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Your Name')),
            TextField(controller: addressController, decoration: const InputDecoration(labelText: 'Address')),
            const SizedBox(height: 16),
            Text('Total: Rp ${cart.totalPrice.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20)),
            ElevatedButton(
              onPressed: () {
                cart.clear();
                showDialog(
                  context: context,
                  builder: (_) => const AlertDialog(
                    title: Text('Success'),
                    content: Text('Order placed successfully!'),
                  ),
                );
              },
              child: const Text('Place Order'),
            )
          ],
        ),
      ),
    );
  }
}