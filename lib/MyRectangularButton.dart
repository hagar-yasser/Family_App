import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final action;
  final text;
  const MyButton({Key? key, required this.action, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          action();
        },
        child: Text(text),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(Color(0xffEA907A))));
  }
}
