import 'package:english_words/english_words.dart';
import 'package:family_app/ActivityBrief.dart';
import 'package:family_app/objects/MyUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './objects/Activity.dart';
import 'package:google_fonts/google_fonts.dart';
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
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _signUp = true;
                      });
                    },
                    child: Text('Sign Up'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xffEA907A)))),
                Spacer(
                  flex: 1,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _signUp = false;
                      });
                    },
                    child: Text('Log In'),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color(0xffEA907A)))),
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
                  ? SignUp(
                      controllers: allControllers,
                    )
                  : LogIn(
                      controllers: [allControllers[0], allControllers[1]],
                    ),
            ),
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final auth = Provider.of<Auth>(context, listen: false);
                    if (_signUp) {
                      currentUser = await auth.handleSignUp(
                          _emailController.text,
                          _passwordController.text,
                          _nameController.text);
                    } else {
                      currentUser = await auth.handleSignInEmail(
                          _emailController.text, _passwordController.text);
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => ActivityBrief(
                            activity: Activity(
                                'Eating together',
                                70,
                                [
                                  'Eman Ahmed',
                                  'Omar Yasser',
                                  'Yasser AbdelRaouf'
                                ],
                                1,
                                1))));
                  }
                },
                child: Text('Submit'),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Color(0xffEA907A))))
          ],
        ),
      ),
    );
  }
}

class LogIn extends StatelessWidget {
  final List<TextEditingController> controllers;
  const LogIn({Key? key, required this.controllers}) : super(key: key);

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
  const SignUp({Key? key, required this.controllers}) : super(key: key);

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
