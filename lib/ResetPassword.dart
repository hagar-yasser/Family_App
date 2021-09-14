import 'package:family_app/MyRectangularButton.dart';
import 'package:family_app/MyRoundedLoadingButton.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  static const routeName = '/resetPassword';
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Reset Password",
                style: TextStyle(fontSize: 35),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  // height: MediaQuery.of(context).size.height * 0.4,
                  child: Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                  labelText: "Enter Your Email"),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: MyRoundedLoadingButton(
                                child: Text('Send request'),
                                action: () async {
                                  try {
                                    await authProvider
                                        .resetPassword(_controller.text);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Reset Password email was sent. Please check your email")));
                                    Navigator.of(context).pop();
                                  } on Exception catch (e) {
                                    _showErrorDialog(context,
                                        "Couldn't send a request email", e);
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String title, Exception e) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            title,
            style: const TextStyle(fontSize: 24),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  '${(e as dynamic).message}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            MyButton(
                action: () {
                  Navigator.of(context).pop();
                },
                text: 'OK'),
          ],
        );
      },
    );
  }
}
