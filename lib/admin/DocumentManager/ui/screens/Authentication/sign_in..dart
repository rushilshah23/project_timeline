import 'package:Aol_docProvider/core/services/authenticationService.dart';
import 'package:Aol_docProvider/core/services/validators.dart';
import 'package:Aol_docProvider/ui/shared/constants.dart';
import 'package:Aol_docProvider/ui/widgets/buttons.dart';
import 'package:Aol_docProvider/ui/widgets/loading.dart';
import 'package:Aol_docProvider/ui/widgets/textFields.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _signInKey = GlobalKey<FormState>();
  TextEditingController _emailHomePageController = new TextEditingController();
  TextEditingController _passwordHomePageConroller =
      new TextEditingController();
  String error = '';

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Sign In Page"),
              centerTitle: true,
              flexibleSpace: Container(
                decoration: colorBox,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                  key: _signInKey,
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
                          controller: _passwordHomePageConroller,
                          hintText: "Enter your password",
                          validateFunction: passwordValidator,
                          labelText: "Password",
                          obscure: true),
                      SizedBox(
                        height: 16,
                      ),
                      Builder(builder: (BuildContext context) {
                        return formButton(context,
                            iconData: Icons.lock_open,
                            textData: "Sign In", onPressed: () async {
                          if (_signInKey.currentState.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              AuthenticationService()
                                  .signinEmailId(_emailHomePageController.text,
                                      _passwordHomePageConroller.text)
                                  .then((value) {
                                if (value == null) {
                                  setState(() {
                                    isLoading = false;
                                    error =
                                        'please use valid email or password';
                                  });
                                  // Scaffold.of(context).showSnackBar(SnackBar(
                                  //     content: Text("invalid email or password")));
                                } else {
                                  debugPrint(value.uid);
                                }
                              });
                            } catch (error) {
                              debugPrint(error.toString());
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
                                  text: 'Don\'t have an account?',
                                  style: TextStyle(
                                      color: Color(0xFF02DEED), fontSize: 18),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ' Sign Up',
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
