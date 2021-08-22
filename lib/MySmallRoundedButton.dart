import 'package:flutter/material.dart';

class MySmallRoundedButton extends StatelessWidget {
  final action;
  final child;
  const MySmallRoundedButton({Key? key,required this.action,required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: action,
        child: child,
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.blue),
        ))));
  }
}
