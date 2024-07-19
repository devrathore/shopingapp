import 'package:ellemora/screen/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../component/CustomButton.dart';
import '../../component/CustomePassword.dart';
import '../../component/CustomeTextFiled.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = FirebaseAuth.instance;

  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _mobileController = TextEditingController();

  void _register() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    String mobile = _mobileController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty || mobile.isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (name.length < 3 || name.length > 35) {
      Fluttertoast.showToast(
        msg: 'Name must be 3 characters',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid email',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (password.length < 6 || password.length > 8) {
      Fluttertoast.showToast(
        msg: 'Password must be between 6 and 8 characters',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    if (!RegExp(r'^\d{10}$').hasMatch(mobile)) {
      Fluttertoast.showToast(
        msg: 'Mobile number must be exactly 10 digits',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = userCredential.user!.uid;
      await _databaseReference.child('users').child(uid).set({
        'name': name,
        'email': email,
        'mobile': mobile,
        'password': password,
      });

      Fluttertoast.showToast(
        msg: 'Registration successful',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        String errorMessage;

        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'This email address is already in use.';
            break;
          default:
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
      } else {
        Fluttertoast.showToast(
          msg: 'An unknown error occurred.',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text(
          'Sign Up',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(
                controller: _nameController,
                labelText: 'Name',
                hintText: 'Enter your name',
                prefixIcon: Icons.person,
                borderColor: Colors.blue,
                borderWidth: 2.0,
                borderRadius: 12.0,
                maxLength: 35,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icons.email,
                borderColor: Colors.blue,
                borderWidth: 2.0,
                borderRadius: 12.0,
                maxLength: 30,
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
              CustomTextField(
                controller: _mobileController,
                labelText: 'Mobile',
                hintText: 'Enter your mobile number',
                prefixIcon: Icons.phone,
                borderColor: Colors.blue,
                borderWidth: 2.0,
                borderRadius: 12.0,
                maxLength: 10,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'Register',
                onPressed: _register,
                color: Colors.blue,
                textColor: Colors.white,
                fontSize: 18.0,
                borderRadius: 12.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
