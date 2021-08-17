import 'package:flutter/material.dart';
import './objects/Activity.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInType extends StatefulWidget {
  const SignInType({Key? key}) : super(key: key);

  @override
  _SignInTypeState createState() => _SignInTypeState();
}

class _SignInTypeState extends State<SignInType> {
  @override
  var tween = Tween(begin: Offset(-1.0, 0.0), end: Offset(0,0)).chain(CurveTween(curve: Curves.ease));
  bool _signUp = true;
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(flex: 2,),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _signUp = true;
                    });
                  },
                  child: Text('Sign Up'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xffEA907A)))
               ),
              Spacer(flex: 1,),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _signUp = false;
                    });
                  },
                  child: Text('Log In'),
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Color(0xffEA907A)))
                ),
              Spacer(flex: 2,),
            ],
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(child: child, position: animation.drive(tween));
            },
            child: _signUp ? SignUp() : LogIn(),
          )
        ],
      ),
    );
  }
}

class LogIn extends StatelessWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
    
      color: Colors.blue,
    )
    );
  }
}

class SignUp extends StatelessWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        color: Colors.red,
      ),
    );
  }
}
