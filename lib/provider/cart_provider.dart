import 'package:ellemora/apiService/CartService.dart';
import 'package:ellemora/model/product.dart';
import 'package:flutter/material.dart';

class CartProvider with ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  final CartService _cartService = CartService();

  Future<void> addToCart(String userId, Product product) async {
    await _cartService.addToCart(userId, product);
    _cartItems.add(product);
    notifyListeners();
  }

  Future<List<Product>> fetchCartItems(String userId) async {
    _cartItems = await _cartService.fetchCartItems(userId);
    notifyListeners();
    return _cartItems;
  }

  Future<void> removeFromCart(String userId, Product product) async {
    await _cartService.removeFromCart(userId, product.id.toString());
    notifyListeners();
  }

  void incrementItem(String userId, Product product) async {
    await _cartService.incrementItem(userId, product.id.toString());
    final index = _cartItems.indexOf(product);
    _cartItems[index].quantity++;
    notifyListeners();
  }

  void decrementItem(String userId, Product product) async {
    await _cartService.decrementItem(userId, product.id.toString());
    final index = _cartItems.indexOf(product);
    if (_cartItems[index].quantity > 1) {
      _cartItems[index].quantity--;
      notifyListeners();
    }
  }

  double getTotalPrice() {
    return _cartItems.fold(
        0, (total, current) => total + (current.price * current.quantity));
  }
}
