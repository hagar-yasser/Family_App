import 'package:family_app/MyRoundedLoadingButton.dart';
import 'package:family_app/authorization/Auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static const routeName = '/profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${authProvider.getCurrentUser()!.displayName}",
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
                          Text(
                            "Add a Family Member",
                            style: TextStyle(fontSize: 20),
                          ),
                          TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                                labelText: "Type the member's email"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: MyRoundedLoadingButton(
                              child: Text('Send family request'),
                              action: () async {
                                await addFamily();
                              },
                            ),
                          )
                        ],
                      ),
                    )),
              ),
            ),
            MyRoundedLoadingButton(
                action: () async {
                  await authProvider.signOut();
                },
                child: Text('Sign Out'))
          ],
        ),
      ),
    );
  }
  Future<void> addFamily() async{

  }
}
