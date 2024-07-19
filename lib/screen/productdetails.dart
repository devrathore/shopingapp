
import 'package:ellemora/component/SharedAppBar.dart';
import 'package:ellemora/model/product.dart';
import 'package:ellemora/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: SharedAppBar(
        title: product.title,
        cartItemCount: cartProvider.cartItems.length,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(product.image),
            const SizedBox(height: 16),
            Text(
              product.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '\Rs ${product.price}',
              style: const TextStyle(fontSize: 20, color: Colors.green),
            ),
            const SizedBox(height: 16),
            Text(product.description),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text('${product.rating.rate}', style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Text('(${product.rating.count} reviews)',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent, 
        elevation: 0,
        child: Container(
         
          child: Padding(
            padding: const EdgeInsets.all(8.0), 
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
               
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  child: const Text('Buy Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
