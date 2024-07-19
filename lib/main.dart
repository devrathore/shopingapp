import 'package:ellemora/provider/cart_provider.dart';
import 'package:ellemora/screen/CartScreen.dart';
import 'package:ellemora/screen/ProductPage.dart';
import 'package:ellemora/screen/auth/SignUpPage.dart';
import 'package:ellemora/screen/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screen/SplashScreen .dart';


void main()async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CartProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ellemora',
         themeMode: ThemeMode.system, 
        theme: ThemeData(
          primarySwatch: Colors.blue,
          brightness: Brightness.light,
          
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.dark,
          
        ),
       
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(), 
          '/product': (context) => ProductListScreen(), 
          '/cart': (context) => CartScreen(),
          '/login': (context) => LoginPage(), 
          '/signup': (context) => SignUpPage(),
        },
      ),
    );
  }
}
