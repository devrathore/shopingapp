import 'package:ellemora/utils/UserPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SharedAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int cartItemCount;

  SharedAppBar({
    required this.title,
    required this.cartItemCount,
  });

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you really want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                logout(context);
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    UserPreferences.clearUserData();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out'),
      ),
    );
   
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              
              },
            ),
            if (cartItemCount > 0)
              Positioned(
                right: 7,
                top: 7,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints:const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '$cartItemCount',
                    style:const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.logout),
          onPressed: () {
            showLogoutDialog(context);
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
