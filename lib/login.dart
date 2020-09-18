import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/Register.dart';
import 'CommonWidgets.dart';
import 'manager/ManagerHomePage.dart';
import 'supervisor/SupervisorHomePage.dart';
import 'worker/WorkerHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String _requestType = null ?? "user";
  String _signInMethod = null ?? "email";
  String _email;
  String _password;
  var credential;

  List<String> _users = [
    'manager.aol@gmail.com',
    'supervisor@gmail.com',
    'worker1@gmail.com',
  ];
  int b = 1234;

  final formKey = new GlobalKey<FormState>();
  //final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();
  final controllerOTP = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference workers = Firestore.instance.collection("workers");
  final CollectionReference user = Firestore.instance.collection("user");
  final CollectionReference supervisor =
      Firestore.instance.collection("supervisor");

  Future checkOTP(String phone, BuildContext context) async {
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          print(credential);
          print("`````````````````````````````````````````");
          print("Verification Complete");
          print("`````````````````````````````````````````");
          loginUsingOTP(credential);
        },
        verificationFailed: (AuthException exception) {
          print("`````````````````````````````````````````");
          print("Verification Failed");
          print("`````````````````````````````````````````");
          print(exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Give the code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: controllerOTP,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async {
                        final code = controllerOTP.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);
                        print(credential);
                        print("`````````````````````````````````````````");
                        print("Verification Complete");
                        print("`````````````````````````````````````````");
                        loginUsingOTP(credential);
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }

  loginUsingEmail() {
    if (_email.contains(_users[0]) &&
        _email != (_users[1]) &&
        _email != (_users[2])) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ManagerHomePage()),
      );
    } else if (_email != (_users[0]) &&
        _email.contains(_users[1]) &&
        _email != (_users[2])) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SupervisorHomePage()),
      );
    } else if (_email != _users[0] &&
        _email != _users[1] &&
        _email.contains(_users[2])) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WorkerHomePage()),
      );
    } else {
      showToast("Invalid Credentials");
    }
  }

  loginUsingOTP(credential) async {
    print("```````````````````````````");
    print(_requestType);
    print("```````````````````````````");
    switch (_requestType) {
      case "user":
        await user.getDocuments().then((value) {
          value.documents.forEach((element) async {
            if (element.documentID == _email) {
              if (element.data["status"] == "accepted") {
                AuthResult result =
                    await _auth.signInWithCredential(credential);
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  print("```````````````````````````");
                  print("account creation successful");
                  print(user.uid);
                  print("```````````````````````````");
                  workers.document(element.documentID).updateData(
                      {"status": "created", "uid": user.uid}).then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManagerHomePage()),
                    );
                  });
                }
              } else if (element.data["status"] == "created") {
                AuthResult result =
                    await _auth.signInWithCredential(credential);
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  print("```````````````````````````");
                  print("login successful");
                  print(user.uid);
                  print("```````````````````````````");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManagerHomePage()),
                  );
                }
              }
            } else {
              showToast("Account is not Accepted");
            }
          });
        });
        break;
      case "supervisor":
        await supervisor.getDocuments().then((value) {
          value.documents.forEach((element) async {
            if (element.documentID == _email) {
              if (element.data["status"] == "accepted") {
                AuthResult result =
                    await _auth.signInWithCredential(credential);
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  print("```````````````````````````");
                  print("account creation successful");
                  print(user.uid);
                  print("```````````````````````````");
                  workers.document(element.documentID).updateData(
                      {"status": "created", "uid": user.uid}).then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SupervisorHomePage()),
                    );
                  });
                }
              } else if (element.data["status"] == "created") {
                AuthResult result =
                    await _auth.signInWithCredential(credential);
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  print("```````````````````````````");
                  print("login successful");
                  print(user.uid);
                  print("```````````````````````````");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SupervisorHomePage()),
                  );
                }
              }
            } else {
              showToast("Account is not Accepted");
            }
          });
        });
        break;
      case "worker":
        await workers.getDocuments().then((value) {
          value.documents.forEach((element) async {
            if (element.documentID == _email) {
              if (element.data["status"] == "accepted") {
                AuthResult result =
                    await _auth.signInWithCredential(credential);
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  print("```````````````````````````");
                  print("account creation successful");
                  print(user.uid);
                  print("```````````````````````````");
                  await workers.document(element.documentID).updateData(
                      {"status": "created", "uid": user.uid}).then((value) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WorkerHomePage()),
                    );
                  });
                }
              } else if (element.data["status"] == "created") {
                AuthResult result =
                    await _auth.signInWithCredential(credential);
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  print("```````````````````````````");
                  print("login successful");
                  print(user.uid);
                  print("```````````````````````````");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WorkerHomePage()),
                  );
                }
              }
            } else {
              showToast("Account is not Accepted");
            }
          });
        });
        break;
    }
  }

  List<Widget> showEmail() {
    return [
      Container(
        child: TextFormField(
          controller: userController,
          onChanged: (value) {
            _email = value;
          },
          validator: (val) => val.isEmpty ? 'Enter email' : null,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.email),
            hintText: 'Email',
            contentPadding: EdgeInsets.all(20.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        child: TextFormField(
          controller: passController,
          validator: (val) => val.isEmpty ? 'Enter password' : null,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.vpn_key),
            hintText: 'Password',
            contentPadding: EdgeInsets.all(20.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ),
      ),
      SizedBox(
        height: 20,
      ),
    ];
  }

  List<Widget> showMobile() {
    return [
      Container(
        child: TextFormField(
          controller: userController,
          onChanged: (value) {
            _email = value;
          },
          validator: (val) => val.isEmpty ? 'Enter mobile number' : null,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.phone),
            hintText: 'Mobile Number',
            contentPadding: EdgeInsets.all(20.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
        ),
      ),
      SizedBox(
        height: 10,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        //resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              decoration: BoxDecoration(
                gradient: gradients(),
                borderRadius:
                    BorderRadius.only(bottomLeft: Radius.circular(100)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.white,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 32),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      Column(
                        children: [
                          Text("Sign In Method:"),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio(
                                      value: "email",
                                      groupValue: _signInMethod,
                                      onChanged: (value) {
                                        setState(() {
                                          _signInMethod = value;
                                        });
                                      }),
                                  Text("Email")
                                ],
                              ),
                              Row(
                                children: [
                                  Radio(
                                      value: "OTP",
                                      groupValue: _signInMethod,
                                      onChanged: (value) {
                                        setState(() {
                                          _signInMethod = value;
                                        });
                                      }),
                                  Text("OTP")
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text("User Type:"),
                          Row(
                            children: [
                              Radio(
                                value: "user",
                                groupValue: _requestType,
                                onChanged: (value) {
                                  setState(() {
                                    _requestType = value;
                                  });
                                },
                              ),
                              Text(
                                'User',
                              ),
                              Radio(
                                value: "supervisor",
                                groupValue: _requestType,
                                onChanged: (value) {
                                  setState(() {
                                    _requestType = value;
                                  });
                                },
                              ),
                              Text(
                                'Supervisor',
                              ),
                              Radio(
                                value: "worker",
                                groupValue: _requestType,
                                onChanged: (value) {
                                  setState(() {
                                    _requestType = value;
                                  });
                                },
                              ),
                              Text(
                                'Worker',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                      children: _signInMethod == "email"
                          ? showEmail()
                          : showMobile()),
                  SizedBox(
                    height: 25,
                  ),
                  RaisedButton(
                    onPressed: () {
                      _signInMethod == "email"
                          ? loginUsingEmail()
                          : checkOTP("+91" + _email, context);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(0),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: new BoxDecoration(
                          gradient: gradients(),
                          borderRadius: BorderRadius.circular(32.0)),
                      child: Text(
                        "LOGIN",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Register()),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(0),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: new BoxDecoration(
                          gradient: gradients(),
                          borderRadius: BorderRadius.circular(32.0)),
                      child: Text(
                        "REGISTER",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
