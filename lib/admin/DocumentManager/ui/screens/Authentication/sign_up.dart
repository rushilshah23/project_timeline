import 'package:Aol_docProvider/core/services/authenticationService.dart';
import 'package:Aol_docProvider/core/services/validators.dart';
import 'package:Aol_docProvider/ui/shared/constants.dart';
import 'package:Aol_docProvider/ui/widgets/buttons.dart';
import 'package:Aol_docProvider/ui/widgets/loading.dart';
import 'package:Aol_docProvider/ui/widgets/textFields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  SignUp({this.toggleView});
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _signUpKey = GlobalKey<FormState>();
  TextEditingController _emailHomePageController = new TextEditingController();
  TextEditingController _passwordHomePageConroller1 =
      new TextEditingController();
  TextEditingController _passwordHomePageConroller2 =
      new TextEditingController();
  String error = '';

  void initState() {
    super.initState();
    _emailHomePageController.clear();
    _passwordHomePageConroller1.clear();
    _passwordHomePageConroller2.clear();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Sign Up Page"),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: colorBox,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _signUpKey,
                  child: ListView(
                    children: [
                      Center(
                        child: Icon(
                          Icons.people,
                          size: 128,
                          // color: Theme.of(context).primaryColor,
                          color: Color(0xFF02DEED),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      textFieldWidget(
                          controller: _emailHomePageController,
                          hintText: "Enter your Email ID",
                          labelText: "Email ID",
                          validateFunction: emailValidator),
                      SizedBox(
                        height: 16,
                      ),
                      textFieldWidget(
                          controller: _passwordHomePageConroller1,
                          hintText: "Enter your password",
                          validateFunction: passwordValidator,
                          labelText: "Password",
                          obscure: true),
                      SizedBox(
                        height: 16,
                      ),
                      textFieldWidget(
                          controller: _passwordHomePageConroller2,
                          hintText: "Renter your password",
                          validateFunction: passwordValidator,
                          labelText: " Confirm Password",
                          obscure: true),
                      SizedBox(
                        height: 16,
                      ),
                      Builder(builder: (BuildContext context) {
                        return formButton(context,
                            iconData: Icons.lock_open,
                            textData: "Sign Up", onPressed: () async {
                          if (_signUpKey.currentState.validate()) {
                            if (_passwordHomePageConroller1.text ==
                                _passwordHomePageConroller2.text) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                AuthenticationService()
                                    .signupEmailId(
                                        _emailHomePageController.text,
                                        _passwordHomePageConroller1.text)
                                    .then((value) {
                                  if (value == null) {
                                    setState(() {
                                      isLoading = false;
                                      error = 'something went wrong';
                                    });
                                    // Scaffold.of(context).showSnackBar(SnackBar(
                                    //     content: Text("invalid email or password")));
                                  } else {
                                    // setState(() {
                                    //   _passwordHomePageConroller1.clear();
                                    //   _passwordHomePageConroller2.clear();
                                    //   _emailHomePageController.clear();
                                    // });
                                    debugPrint(value.uid);
                                  }
                                });
                              } catch (error) {
                                debugPrint(error.toString());
                              }
                            } else {
                              setState(() {
                                error = 'passwords didn' '/t match';
                              });
                            }
                          }
                        });
                      }),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                  text: 'Already have an account?',
                                  style: TextStyle(
                                      color: Color(0xFF02DEED), fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' Sign In',
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 18),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            widget.toggleView();

                                            // navigate to desired screen
                                          })
                                  ]),
                            ),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text("$error",
                            style: TextStyle(color: Colors.red, fontSize: 14)),
                      )
                    ],
                  )),
            ),
          );
  }
}
