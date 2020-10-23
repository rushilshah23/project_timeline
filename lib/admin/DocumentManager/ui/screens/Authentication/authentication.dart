import 'package:flutter/material.dart';
import 'package:project_timeline/admin/DocumentManager/ui/screens/Authentication/sign_in..dart';
import 'package:project_timeline/admin/DocumentManager/ui/screens/Authentication/sign_up.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool signIn = true;

  void toggleView() {
    setState(() {
      signIn = !signIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (signIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return SignUp(toggleView: toggleView);
    }
  }
}
