import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MyRoundedLoadingButton extends StatefulWidget {
  final text;
  final action;

  const MyRoundedLoadingButton(
      {Key? key, required this.action, required this.text})
      : super(key: key);

  @override
  _MyRoundedLoadingButtonState createState() => _MyRoundedLoadingButtonState();
}

class _MyRoundedLoadingButtonState extends State<MyRoundedLoadingButton> {
  late final RoundedLoadingButtonController _loadingController;
  
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _loadingController = RoundedLoadingButtonController();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      controller: _loadingController,
      onPressed: () async {
        await widget.action();
        _loadingController.reset();
      },
      child: Text(widget.text),
      color: Color(0xffEA907A),
      valueColor: Color(0xffF7A440),
      width: 150,
    );
  }
}
