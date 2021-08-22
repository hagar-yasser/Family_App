import 'package:family_app/MyRoundedLoadingButton.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);
  static const routeName='/profile';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("${authProvider.getCurrentUser()!.displayName}"),
            MyRoundedLoadingButton(
                action: () async {
                 await authProvider.signOut();
                },
                text: 'Sign Out')
          ],
        ),
      ),
    );
  }
}
