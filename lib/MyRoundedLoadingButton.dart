import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

class MyRoundedLoadingButton extends StatefulWidget {
  final child;
  final action;

  const MyRoundedLoadingButton(
      {Key? key, required this.action, required this.child})
      : super(key: key);

  @override
  _MyRoundedLoadingButtonState createState() => _MyRoundedLoadingButtonState();
}

class _MyRoundedLoadingButtonState extends State<MyRoundedLoadingButton> {
  late final RoundedLoadingButtonController _loadingController;
  bool _isDisposed = false;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    _loadingController = RoundedLoadingButtonController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RoundedLoadingButton(
      controller: _loadingController,
      onPressed: () async {
        await widget.action();
        if (!_isDisposed) _loadingController.reset();
      },
      child: widget.child,
      color: Color(0xffEA907A),
      valueColor: Color(0xffF7A440),
      width: 150,
    );
  }
}
