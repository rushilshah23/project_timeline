import 'package:flutter/material.dart';
import 'package:project_timeline/languages/setLanguageText.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePass extends StatefulWidget {
  @override
  _ChangePassState createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController oldController = TextEditingController();
  TextEditingController newController = TextEditingController();
  TextEditingController new2Controller = TextEditingController();
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _email, _old, _new, _new2;

  void change() async {
    UserCredential result = await _auth
        .signInWithEmailAndPassword(email: _email, password: _old)
        .catchError((e) {
      showToast(e.toString());
    });
    User user = result.user;
    if (user.uid != null) {
      user.updatePassword(_new).then((_) {
        showToast(forgotPassText[23]);
      }).catchError((error) {
        showToast(forgotPassText[24] + error.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppbar(forgotPassText[22], context),
      body:SingleChildScrollView(child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  TextFormField(
                    onChanged: (value) {
                      setState(() {
                        _email = value;
                      });
                    },
                    validator: (val) {
                      Pattern pattern =
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                          r"{0,253}[a-zA-Z0-9])?)*$";
                      RegExp regex = new RegExp(pattern);
                      if (!regex.hasMatch(val))
                        return forgotPassText[4];
                      else
                        return null;
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: forgotPassText[5],
                      border: OutlineInputBorder(),
                      //hintText: "Enter Petrol Pump Address",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _old = value;
                      });
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return forgotPassText[16];
                      } else
                        return null;
                    },
                    controller: oldController,
                    decoration: InputDecoration(
                      labelText: forgotPassText[15],
                      border: OutlineInputBorder(),
                      //hintText: "Enter Petrol Pump Address",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _new = value;
                      });
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return forgotPassText[18];
                      } else
                        return null;
                    },
                    controller: newController,
                    decoration: InputDecoration(
                      labelText: forgotPassText[17],
                      border: OutlineInputBorder(),
                      //hintText: "Enter Petrol Pump Address",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {
                        _new2 = value;
                      });
                    },
                    validator: (val) {
                      if (val.isEmpty) {
                        return forgotPassText[20];
                      } else if (_new != val)
                        return forgotPassText[21];
                      else
                        return null;
                    },
                    controller: new2Controller,
                    decoration: InputDecoration(
                      labelText: forgotPassText[19],
                      border: OutlineInputBorder(),
                      //hintText: "Enter Petrol Pump Address",
                    ),
                  ),
                ],
              ),
              SizedBox(
                    height: 40,
                  ),
              Column(
                children: [
                  RaisedButton(
                    color: Color(0xff018abd),
                    child: Container(
                      child: Center(
                        child: Text(
                          forgotPassText[22],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17),
                        ),
                      ),
                      width: double.infinity,
                      height: 55,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_formKey.currentState.validate()) {
                          change();
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
