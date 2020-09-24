import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/Register.dart';
import 'CommonWidgets.dart';
import 'manager/ManagerHomePage.dart';
import 'supervisor/SupervisorHomePage.dart';
import 'worker/WorkerHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String _requestType = null ?? "user";
  String _signInMethod = null ?? "email";
  String _email, _password;
  var credential, flag = 0, firstTimeLogin = 0;

  final formKey = new GlobalKey<FormState>();
  //final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();
  final controllerOTP = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference workers = Firestore.instance.collection("workers");
  final CollectionReference users = Firestore.instance.collection("user");
  final CollectionReference supervisor =
      Firestore.instance.collection("supervisor");
  final CollectionReference newPhoneUser =
      Firestore.instance.collection("newPhoneUser");

  signOut() async {
    await _auth.signOut().then((value) {
      showToast("Logout Successful");
    });
  }

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

  loginUsingEmail() async {
    print(_email);
    print(_password);
    try {
      switch (_requestType) {
        case "user":
          print("user");
          await users.getDocuments().then((value) {
            value.documents.forEach((element) async {
              if (element.data["email"] == _email) {
                flag = 1;
                AuthResult result = await _auth.signInWithEmailAndPassword(
                    email: _email, password: _password);
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  print("```````````````````````````");
                  print("account login successful");
                  print(user.uid);
                  print(element.data["email"]);
                  print(element.data["mobile"]);
                  print(element.data["name"]);
                  print(element.data["assignedProject"]);
                  showToast("Login Successful");
                  print("```````````````````````````");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManagerHomePage()),
                  );
                }
              }
            });
          });
          if (flag == 0) showToast("Account is not Accepted");
          break;
        case "supervisor":
          print("supervisor");
          await supervisor.getDocuments().then((value) {
            value.documents.forEach((element) async {
              if (element.data["email"] == _email) {
                flag = 1;
                AuthResult result = await _auth.signInWithEmailAndPassword(
                    email: _email, password: _password);

                FirebaseUser user = result.user;
                if (user.uid != null) {
                  print("```````````````````````````");
                  print("account login successful");
                  print(user.uid);
                  print(element.data["email"]);
                  print(element.data["mobile"]);
                  print(element.data["name"]);
                  print(element.data["assignedProject"]);
                  showToast("Login Successful");
                  print("```````````````````````````");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SupervisorHomePage()),
                  );
                }
              }
            });
          });
          if (flag == 0) showToast("Account is not Accepted");
          break;
        case "worker":
          print("worker");
          await workers.getDocuments().then((value) {
            value.documents.forEach((element) async {
              if (element.data["email"] == _email) {
                flag = 1;
                print(element.data);
                AuthResult result = await _auth.signInWithEmailAndPassword(
                    email: _email, password: _password);
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  print("```````````````````````````");
                  print("account login successful");
                  print(user.uid);
                  print(element.data["email"]);
                  print(element.data["mobile"]);
                  print(element.data["name"]);
                  print(element.data["assignedProject"]);
                  showToast("Login Successful");
                  print("```````````````````````````");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WorkerHomePage()),
                  );
                }
              }
            });
          });
          if (flag == 0) showToast("Account is not Accepted");
          break;
      }
    } catch (e) {
      print("```````````````````````````");
      print(e.toString());
      print("```````````````````````````");
    }
  }

  loginUsingOTP(credential) async {
    print("```````````````````````````");
    print(_requestType);
    print("```````````````````````````");
    try {
      switch (_requestType) {
        case "user":
          await newPhoneUser.getDocuments().then((value) {
            value.documents.forEach((element) async {
              if (element.documentID == _email &&
                  element.data["userType"] == "user") {
                firstTimeLogin = 1;
                AuthResult result =
                    await _auth.signInWithCredential(credential);
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  print("```````````````````````````");
                  print("account creation successful");
                  print(user.uid);
                  print(element.data["mobile"]);
                  print(element.data["name"]);
                  print(element.data["assignedProject"]);
                  showToast("Login Successful");
                  print("```````````````````````````");
                  users.document(user.uid).setData({
                    "assignedProject": "No project assigned",
                    "mobile": element["mobile"],
                    "name": element["name"],
                    "age": element["age"],
                    "address": element["address"],
                    "uid": user.uid,
                    'signInMethod': "otp"
                  }).then((value) async {
                    await newPhoneUser.document(_email).delete().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManagerHomePage()),
                      );
                    });
                  });
                }
              }
            });
          });
          if (firstTimeLogin != 1) {
            await users.getDocuments().then((value) {
              value.documents.forEach((element) async {
                if (element.data["mobile"] == _email) {
                  flag = 1;
                  AuthResult result =
                      await _auth.signInWithCredential(credential);
                  FirebaseUser user = result.user;
                  if (user.uid != null) {
                    print("```````````````````````````");
                    print(element.data["uid"]);
                    print(element.data["mobile"]);
                    print(element.data["name"]);
                    print(element.data["assignedProject"]);
                    showToast("Login Successful");
                    print("```````````````````````````");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManagerHomePage()),
                    );
                  }
                }
              });
            });
            if (flag == 0) {
              showToast("Please register first");
            }
          } else {
            await newPhoneUser.document(_email).delete();
          }
          break;
        case "supervisor":
          await newPhoneUser.getDocuments().then((value) {
            value.documents.forEach((element) async {
              if (element.documentID == _email &&
                  element.data["userType"] == "supervisor") {
                firstTimeLogin = 1;
                AuthResult result =
                    await _auth.signInWithCredential(credential);
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  print("```````````````````````````");
                  print("account creation successful");
                  print(user.uid);
                  print(element.data["mobile"]);
                  print(element.data["name"]);
                  print(element.data["assignedProject"]);
                  showToast("Login Successful");
                  print("```````````````````````````");
                  supervisor.document(user.uid).setData({
                    "assignedProject": "No project assigned",
                    "mobile": element["mobile"],
                    "name": element["name"],
                    "age": element["age"],
                    "address": element["address"],
                    "uid": user.uid,
                    'signInMethod': "otp"
                  }).then((value) async {
                    await newPhoneUser.document(_email).delete().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManagerHomePage()),
                      );
                    });
                  });
                }
              }
            });
          });
          if (firstTimeLogin != 1) {
            await supervisor.getDocuments().then((value) {
              value.documents.forEach((element) async {
                if (element.data["mobile"] == _email) {
                  flag = 1;
                  AuthResult result =
                      await _auth.signInWithCredential(credential);
                  FirebaseUser user = result.user;
                  if (user.uid != null) {
                    print("```````````````````````````");
                    print(element.data["uid"]);
                    print(element.data["mobile"]);
                    print(element.data["name"]);
                    print(element.data["assignedProject"]);
                    showToast("Login Successful");
                    print("```````````````````````````");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SupervisorHomePage()),
                    );
                  }
                }
              });
            });
            if (flag == 0) {
              showToast("Please register first");
            }
          } else {
            await newPhoneUser.document(_email).delete();
          }
          break;
        case "worker":
          await newPhoneUser.getDocuments().then((value) {
            value.documents.forEach((element) async {
              if (element.documentID == _email &&
                  element.data["userType"] == "worker") {
                firstTimeLogin = 1;
                AuthResult result =
                    await _auth.signInWithCredential(credential);
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  print("```````````````````````````");
                  print("account creation successful");
                  print(user.uid);
                  print(element.data["mobile"]);
                  print(element.data["name"]);
                  print(element.data["assignedProject"]);
                  showToast("Login Successful");
                  print("```````````````````````````");
                  workers.document(user.uid).setData({
                    "assignedProject": "No project assigned",
                    "mobile": element["mobile"],
                    "name": element["name"],
                    "age": element["age"],
                    "address": element["address"],
                    "uid": user.uid,
                    'signInMethod': "otp"
                  }).then((value) async {
                    await newPhoneUser.document(_email).delete().then((value) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ManagerHomePage()),
                      );
                    });
                  });
                }
              }
            });
          });
          if (firstTimeLogin != 1) {
            await workers.getDocuments().then((value) {
              value.documents.forEach((element) async {
                if (element.data["mobile"] == _email) {
                  flag = 1;
                  AuthResult result =
                      await _auth.signInWithCredential(credential);
                  FirebaseUser user = result.user;
                  if (user.uid != null) {
                    print("```````````````````````````");
                    print(element.data["uid"]);
                    print(element.data["mobile"]);
                    print(element.data["name"]);
                    print(element.data["assignedProject"]);
                    showToast("Login Successful");
                    print("```````````````````````````");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WorkerHomePage()),
                    );
                  }
                }
              });
            });
            if (flag == 0) {
              showToast("Please register first");
            }
          } else {
            await newPhoneUser.document(_email).delete();
          }

          break;
      }
    } catch (e) {
      print("```````````````````````````");
      print(e.toString());
      print("```````````````````````````");
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
          onChanged: (value) {
            _password = value;
          },
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
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 20, right: 20),
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sign In Method:"),
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
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("User Type:"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                      children: _signInMethod == "email"
                          ? showEmail()
                          : showMobile()),
                  SizedBox(
                    height: 15,
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
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Register()),
                          );
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color: Colors.blue[900]),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    )));
  }
}
