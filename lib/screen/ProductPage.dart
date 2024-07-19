import 'dart:async';

import 'package:ellemora/apiService/CartService.dart';
import 'package:ellemora/apiService/apiService.dart';
import 'package:ellemora/component/SharedAppBar.dart';
import 'package:ellemora/model/product.dart';
import 'package:ellemora/provider/cart_provider.dart';
import 'package:ellemora/screen/productdetails.dart';
import 'package:ellemora/utils/UserPreferences.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatefulWidget {
  ProductListScreen({Key? key}) : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final StreamController<List<Product>> _productsStreamController =
      StreamController();
  final StreamController<List<String>> _categoriesStreamController =
      StreamController();
  List<Product> allProducts = [];
  List<Product> displayedProducts = [];
  late CartService cartService;
  late String userId;

  @override
  void initState() {
    super.initState();
    cartService = CartService();
    fetchProducts();
    fetchCategories();
  }

  void fetchProducts() {
    ApiService().fetchProducts().listen((products) {
      allProducts = products;
      displayedProducts = products;
      _productsStreamController.add(displayedProducts);
    });
  }

  void fetchCategories() async {
    final userData = await UserPreferences.getUserData();
    userId = userData['userId'];
    ApiService().fetchCategories().listen((categories) {
      _categoriesStreamController.add(categories);
    });
  }

  void _searchProducts(String query) {
    final productsToSearch =
        displayedProducts.isNotEmpty ? displayedProducts : allProducts;

    final filteredProducts = productsToSearch.where((product) {
      final titleLower = product.title.toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      displayedProducts = filteredProducts;
      _productsStreamController.add(displayedProducts);
    });
  }

  void filterByCategory(String category) {
    if (category.isEmpty) {
      setState(() {
        displayedProducts = allProducts;
      });
    } else {
      final filteredProducts =
          allProducts.where((product) => product.category == category).toList();
      setState(() {
        displayedProducts = filteredProducts;
      });
    }
    _productsStreamController.add(displayedProducts);
  }

  void clearFilter() {
    setState(() {
      displayedProducts = allProducts;
    });
    _productsStreamController.add(displayedProducts);
  }

  @override
  void dispose() {
    _productsStreamController.close();
    _categoriesStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: SharedAppBar(
        title: 'Products',
        cartItemCount: cartProvider.cartItems.length,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                border: Border.all(),
              ),
              child: TextField(
                onChanged: _searchProducts,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: InputBorder.none,
                  suffixIcon: Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 35,
                    child: StreamBuilder<List<String>>(
                      stream: _categoriesStreamController.stream,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          ));
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (snapshot.hasData) {
                          final categories = snapshot.data!;
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  filterByCategory(categories[index]);
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: Colors.blue),
                                  ),
                                  child: Center(child: Text(categories[index])),
                                ),
                              );
                            },
                          );
                        } else {
                          return const Center(
                              child: Text('No categories found'));
                        }
                      },
                    ),
                  ),
                ),
                TextButton(
                  child: const Text("All"),
                  onPressed: clearFilter,
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: _productsStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;
                      double childAspectRatio =
                          constraints.maxWidth > 600 ? 2 / 3 : 1 / 1.5;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                        ),
                        itemCount: displayedProducts.length,
                        itemBuilder: (context, index) {
                          final product = displayedProducts[index];
                          return Card(
                            margin: const EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailScreen(product: product),
                                  ),
                                );
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Center(
                                      child: Image.network(
                                        product.image,
                                        fit: BoxFit.cover,
                                        height: 100,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(product.title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis),
                                        const SizedBox(height: 4),
                                        Text('\Rs.${product.price}',
                                            style: const TextStyle(
                                                color: Colors.green)),
                                        Row(
                                          children: [
                                            const Icon(Icons.star,
                                                color: Colors.amber, size: 16),
                                            const SizedBox(width: 5),
                                            Text(
                                                '${product.rating.rate} (${product.rating.count})'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          await cartProvider.addToCart(
                                              userId, product);
                                        },
                                        child: const Text('Add to Cart'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No products found'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
