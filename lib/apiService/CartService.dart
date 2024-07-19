import 'package:ellemora/model/product.dart';
import 'package:firebase_database/firebase_database.dart';

class CartService {
  final DatabaseReference _cartRef =
      FirebaseDatabase.instance.ref().child('cart');

  Future<void> addToCart(String userId, Product product) async {
    final productRef = _cartRef.child(userId).child(product.id.toString());
    final snapshot = await productRef.get();

    if (snapshot.exists) {
      int quantity = snapshot.child('quantity').value as int;
      productRef.update({'quantity': quantity + 1});
    } else {
      productRef.set({
        'id': product.id,
        'title': product.title,
        'price': product.price,
        'image': product.image,
        'quantity': 1,
      });
    }
  }

  Future<void> removeFromCart(String userId, String productId) async {
    await _cartRef.child(userId).child(productId).remove();
  }

  Future<void> incrementItem(String userId, String productId) async {
    final productRef = _cartRef.child(userId).child(productId);
    final snapshot = await productRef.get();

    if (snapshot.exists) {
      int quantity = snapshot.child('quantity').value as int;
      productRef.update({'quantity': quantity + 1});
    }
  }

  Future<void> decrementItem(String userId, String productId) async {
    final productRef = _cartRef.child(userId).child(productId);
    final snapshot = await productRef.get();

    if (snapshot.exists) {
      int quantity = snapshot.child('quantity').value as int;
      if (quantity > 1) {
        productRef.update({'quantity': quantity - 1});
      }
    }
  }

  Future<List<Product>> fetchCartItems(String userId) async {
    final snapshot = await _cartRef.child(userId).get();
    List<Product> cartItems = [];

    if (snapshot.exists) {
      final dynamic data = snapshot.value;

      print("datatest:$data");
      if (data != null) {
        if (data is Map<dynamic, dynamic>) {
          data.forEach((key, value) {
            if (value != null) {
              cartItems.add(Product.fromJson(Map<String, dynamic>.from(value)));
            }
          });
        } else if (data is List<dynamic>) {
          data.forEach((value) {
            if (value != null && value is Map<dynamic, dynamic>) {
              cartItems.add(Product.fromJson(Map<String, dynamic>.from(value)));
            }
          });
        }
      }
    }

    // Debug print to check cartItems
    print("Cart Items: $cartItems");

    return cartItems;
  }
}
