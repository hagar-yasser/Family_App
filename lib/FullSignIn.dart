import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './SignInType.dart';

class FullSignIn extends StatelessWidget {
  static const routeName = '/fullSignIn';
  const FullSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                height: 150,
                child: Center(
                  child: Text(
                    "The Family App",
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              SignInType(),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/resetPassword');
                  },
                  child: Text('Forgot Your Password ?'))
            ],
          ),
        ),
      ),
    );
  }
}
