import 'package:ellemora/screen/ProductPage.dart';
import 'package:ellemora/utils/UserPreferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../component/CustomButton.dart';
import '../../component/CustomePassword.dart';
import '../../component/CustomeTextFiled.dart';
import 'SignUpPage.dart';

class LoginPage extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Login'),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome To Ellemora',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _usernameController,
              labelText: 'Email',
              hintText: 'Enter your email',
              prefixIcon: Icons.person,
              borderColor: Colors.blue,
              borderWidth: 2.0,
              borderRadius: 12.0,
              maxLength: 25,
            ),
            const SizedBox(height: 20),
            CustomePassword(
              controller: _passwordController,
              labelText: 'Password',
              hintText: 'Enter your password',
              prefixIcon: Icons.lock,
              obscureText: true,
              borderColor: Colors.blue,
              borderWidth: 2.0,
              borderRadius: 12.0,
              maxLength: 8,
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Login',
              onPressed: () async {
                String username = _usernameController.text;
                String password = _passwordController.text;

                if (username.isEmpty ||
                    password.isEmpty ||
                    !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(username)) {
                  Fluttertoast.showToast(
                    msg: 'Please fill correct email and password',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                } else {
                  try {
                    final user = await _auth.signInWithEmailAndPassword(
                      email: username,
                      password: password,
                    );

                    if (user.user != null) {
                      Fluttertoast.showToast(
                        msg: 'LogIn successful',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                       await UserPreferences.saveUserData(
                            loggedIn: true,
                           userId: user.user!.uid);

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProductListScreen()),
                      );
                    }
                  } catch (e) {
                    String errorMessage;

                    if (e is FirebaseAuthException) {
                      switch (e.code) {
                        case 'user-not-found':
                          errorMessage = 'No user found for that email.';
                          break;
                        case 'wrong-password':
                          errorMessage =
                              'Wrong password provided for that user.';
                          break;
                        default:
                          errorMessage = 'An unknown error occurred.';
                      }
                    } else {
                      errorMessage = 'An unknown error occurred.';
                    }

                    Fluttertoast.showToast(
                      msg: errorMessage,
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }
                }
              },
              color: Colors.blue,
              textColor: Colors.white,
              fontSize: 18.0,
              borderRadius: 12.0,
            ),
            const SizedBox(height: 20),
            Container(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: RichText(
                  text: const TextSpan(
                    text: 'Not registered? ',
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Register here',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
