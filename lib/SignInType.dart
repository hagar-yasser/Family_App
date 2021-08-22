import 'package:english_words/english_words.dart';
import 'package:family_app/ActivityBrief.dart';
import 'package:family_app/MyRectangularButton.dart';
import 'package:family_app/MyRoundedLoadingButton.dart';
import 'package:family_app/objects/MyUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:family_app/authorization/Auth.dart';

class SignInType extends StatefulWidget {
  const SignInType({Key? key}) : super(key: key);

  @override
  _SignInTypeState createState() => _SignInTypeState();
}

class _SignInTypeState extends State<SignInType> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  late String _name;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  late List<TextEditingController> allControllers;
  @override
  void dispose() {
    allControllers.map((e) => e.dispose());
    super.dispose();
  }

  MyUser? currentUser;
  @override
  void initState() {
    // TODO: implement initState
    allControllers = [_emailController, _passwordController, _nameController];
    super.initState();
  }

  @override
  var tween = Tween(begin: Offset(-1.0, 0.0), end: Offset(0, 0))
      .chain(CurveTween(curve: Curves.ease));
  bool _signUp = true;
  

  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    return Form(
      key: _formKey,
      child: Card(
        elevation: 8,
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Spacer(
                  flex: 2,
                ),
                MyButton(
                    action: () {
                      setState(() {
                        _signUp = true;
                      });
                    },
                    text:'Sign Up',
                    ),
                Spacer(
                  flex: 1,
                ),
                MyButton(
                    action: () {
                      setState(() {
                        _signUp = false;
                      });
                    },
                    text: 'Log In',
                    ),
                Spacer(
                  flex: 2,
                ),
              ],
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return SlideTransition(
                    child: child, position: animation.drive(tween));
              },
              child: _signUp
                  ? SignUp(controllers: allControllers)
                  : LogIn(
                      controllers: [allControllers[0], allControllers[1]],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
              child: MyRoundedLoadingButton(
                action: () async {
                  bool allIsOk = false;
                  if (_formKey.currentState!.validate()) {
                    if (_signUp) {
                      try {
                        currentUser = await auth.handleSignUp(
                            _emailController.text,
                            _passwordController.text,
                            _nameController.text);
                        allIsOk = true;
                        _showMessageDialog(
                          context,
                          "Verification Link sent to your email",
                        );
                      } on Exception catch (e) {
                        _showErrorDialog(
                            context, "couldn't creat a new account", e);
                      }
                    } else {
                      try {
                        currentUser = await auth.handleSignInEmail(
                            _emailController.text, _passwordController.text);
                        allIsOk = true;
                        // if (auth.getCurrentUser()!.emailVerified) {
                        //   var credential = EmailAuthProvider.credential(email:_emailController.text,password: _passwordController.text );
                        //   await auth
                        //       .getCurrentUser()!
                        //       .reauthenticateWithCredential(credential);
                        // }
                      } on Exception catch (e) {
                        _showErrorDialog(context, "couldn't signIn", e);
                      }
                    }
                  }
                  
                },
                text:'Submit'

                // style: ButtonStyle(
                //     backgroundColor:
                //         MaterialStateProperty.all<Color>(Color(0xffEA907A)))
              ),
            )
          ],
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
                text: 'OK'
               ),
          ],
        );
      },
    );
  }

  void _showMessageDialog(BuildContext context, String title) {
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
                  "Verify your email by clicking the link sent to be able to access your account",
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
                text:'OK'
                ),
          ],
        );
      },
    );
  }
}

class LogIn extends StatelessWidget {
  final List<TextEditingController> controllers;

  const LogIn({
    Key? key,
    required this.controllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MyTextFormField(
              text: 'Email',
              obscureText: false,
              controller: controllers[0],
            ),
            MyTextFormField(
              text: 'Password',
              obscureText: true,
              controller: controllers[1],
            )
          ],
        )

        // Container(
        //   width: MediaQuery.of(context).size.width,
        //   height: 200,
        //   color: Colors.blue,
        // )
        );
  }
}

class SignUp extends StatelessWidget {
  final List<TextEditingController> controllers;

  const SignUp({
    Key? key,
    required this.controllers,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            MyTextFormField(
                text: 'Email', obscureText: false, controller: controllers[0]),
            MyTextFormField(
              text: 'Password',
              obscureText: true,
              controller: controllers[1],
            ),
            MyTextFormField(
              text: 'Name',
              obscureText: false,
              controller: controllers[2],
            ),
          ],
        )

        // Container(
        //   width: MediaQuery.of(context).size.width,
        //   height: 200,
        //   color: Colors.blue,
        // )
        );
  }
}

class MyTextFormField extends StatefulWidget {
  final String text;
  final bool obscureText;
  final TextEditingController controller;
  const MyTextFormField(
      {Key? key,
      required this.text,
      required this.obscureText,
      required this.controller})
      : super(key: key);

  @override
  _MyTextFormFieldState createState() => _MyTextFormFieldState();
}

class _MyTextFormFieldState extends State<MyTextFormField> {
  late TextEditingController _controller;
  @override
  void initState() {
    // TODO: implement initState
    _controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        obscureText: widget.obscureText,
        controller: _controller,
        decoration: InputDecoration(
            border: OutlineInputBorder(), labelText: widget.text),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Please enter some text";
          }
          return null;
        },
      ),
    );
  }
}
