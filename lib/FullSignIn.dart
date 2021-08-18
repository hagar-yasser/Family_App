import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import './objects/Activity.dart';
import 'package:google_fonts/google_fonts.dart';
import './SignInType.dart';

class FullSignIn extends StatelessWidget {
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
              SignInType()
            ],
          ),
        ),
      ),
    );
  }
}
