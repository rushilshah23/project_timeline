import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Register.dart';
import 'colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'CommonWidgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_dialog/progress_dialog.dart';

import 'manager/ManagerHomePage.dart';
import 'supervisor/SupervisorHomePage.dart';
import 'worker/WorkerHomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  List<String> _type = ["worker", "supervisor", "manager"];
  String _requestType = null ?? "worker";
  String _signInMethod = null ?? "email";
  String _email, _password;
  var credential, selectedType, flag = 0, firstTimeLogin = 0;

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
  final CollectionReference manager = Firestore.instance.collection("manager");
  final CollectionReference newPhoneUser =
      Firestore.instance.collection("newPhoneUser");

  signOut() async {
    await _auth.signOut().then((value) {
      showToast("Logout Successful");
    });
  }

  _setData(String name, String email, String mobile, String uid,
      String assignedProject) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();

    prefs.setString('email', email);
    prefs.setString('name', name);
    prefs.setString('mobile', mobile);
    prefs.setString('uid', uid);
    prefs.setString('assignedProject', assignedProject);
    prefs.setString('userType', _requestType);
    prefs.setBool("isLoggedIn", true);
  }

  Future checkOTP(String phone, BuildContext context, pr) async {
    await pr.show();
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 120),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          print(credential);
          print("`````````````````````````````````````````");
          print("Verification Complete");
          print("`````````````````````````````````````````");
          loginUsingOTP(credential, pr);
        },
        verificationFailed: (AuthException exception) {
          print("`````````````````````````````````````````");
          print("Verification Failed");
          print("`````````````````````````````````````````");
          print(exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) async {
          await pr.hide();
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
                        await pr.show();
                        final code = controllerOTP.text.trim();
                        AuthCredential credential =
                            PhoneAuthProvider.getCredential(
                                verificationId: verificationId, smsCode: code);
                        print(credential);
                        print("`````````````````````````````````````````");
                        print("Verification Complete");
                        print("`````````````````````````````````````````");
                        loginUsingOTP(credential, pr);
                      },
                    )
                  ],
                );
              });
        },
        codeAutoRetrievalTimeout: null);
  }

  loginUsingEmail(pr) async {
    await pr.show();
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
                AuthResult result = await _auth
                    .signInWithEmailAndPassword(
                        email: _email, password: _password)
                    .catchError((e) {
                  showToast(e.toString());
                });
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  await pr.hide();
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
                AuthResult result = await _auth
                    .signInWithEmailAndPassword(
                        email: _email, password: _password)
                    .catchError((e) {
                  showToast(e.toString());
                });

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
                  _setData(
                      element.data["name"],
                      element.data["email"],
                      element.data["mobile"],
                      element.data["uid"],
                      element.data["assignedProject"]);
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
                AuthResult result = await _auth
                    .signInWithEmailAndPassword(
                        email: _email, password: _password)
                    .catchError((e) {
                  showToast(e.toString());
                });
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
                  _setData(
                      element.data["name"],
                      element.data["email"],
                      element.data["mobile"],
                      element.data["uid"],
                      element.data["assignedProject"]);
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
        case "manager":
          print("manager");
          await manager.getDocuments().then((value) {
            value.documents.forEach((element) async {
              if (element.data["email"] == _email) {
                flag = 1;
                print(element.data);
                AuthResult result = await _auth
                    .signInWithEmailAndPassword(
                        email: _email, password: _password)
                    .catchError((e) {
                  showToast(e.toString());
                });
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
                  _setData(
                      element.data["name"],
                      element.data["email"],
                      element.data["mobile"],
                      element.data["uid"],
                      element.data["assignedProject"]);
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
      }
    } catch (e) {
      print("```````````````````````````");
      print(e.toString());
      print("```````````````````````````");
    }
  }

  loginUsingOTP(credential, pr) async {
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
                  await pr.hide();
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
                      _setData(element["name"], element["email"],
                          element["mobile"], user.uid, "No project assigned");
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
                    await pr.hide();
                    print("```````````````````````````");
                    print(element.data["uid"]);
                    print(element.data["mobile"]);
                    print(element.data["name"]);
                    print(element.data["assignedProject"]);
                    showToast("Login Successful");
                    print("```````````````````````````");
                    _setData(
                        element.data["name"],
                        element.data["email"],
                        element.data["mobile"],
                        element.data["uid"],
                        element.data["assignedProject"]);

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
                  await pr.hide();

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
                      _setData(element["name"], element["email"],
                          element["mobile"], user.uid, "No project assigned");
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
                    await pr.hide();

                    print("```````````````````````````");
                    print(element.data["uid"]);
                    print(element.data["mobile"]);
                    print(element.data["name"]);
                    print(element.data["assignedProject"]);
                    showToast("Login Successful");
                    print("```````````````````````````");
                    _setData(
                        element.data["name"],
                        element.data["email"],
                        element.data["mobile"],
                        element.data["uid"],
                        element.data["assignedProject"]);
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
                  await pr.hide();

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
                    _setData(element["name"], element["email"],
                        element["mobile"], user.uid, "No project assigned");
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
                    await pr.hide();

                    print("```````````````````````````");
                    print(element.data["uid"]);
                    print(element.data["mobile"]);
                    print(element.data["name"]);
                    print(element.data["assignedProject"]);
                    showToast("Login Successful");
                    print("```````````````````````````");
                    _setData(
                        element.data["name"],
                        element.data["email"],
                        element.data["mobile"],
                        element.data["uid"],
                        element.data["assignedProject"]);

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
        case "manager":
          await newPhoneUser.getDocuments().then((value) {
            value.documents.forEach((element) async {
              if (element.documentID == _email &&
                  element.data["userType"] == "manager") {
                firstTimeLogin = 1;
                AuthResult result =
                    await _auth.signInWithCredential(credential);
                FirebaseUser user = result.user;
                if (user.uid != null) {
                  await pr.hide();

                  print("```````````````````````````");
                  print("account creation successful");
                  print(user.uid);
                  print(element.data["mobile"]);
                  print(element.data["name"]);
                  print(element.data["assignedProject"]);
                  showToast("Login Successful");
                  print("```````````````````````````");
                  manager.document(user.uid).setData({
                    "assignedProject": "No project assigned",
                    "mobile": element["mobile"],
                    "name": element["name"],
                    "age": element["age"],
                    "address": element["address"],
                    "uid": user.uid,
                    'signInMethod': "otp"
                  }).then((value) async {
                    await newPhoneUser.document(_email).delete().then((value) {
                      _setData(element["name"], element["email"],
                          element["mobile"], user.uid, "No project assigned");
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
            await manager.getDocuments().then((value) {
              value.documents.forEach((element) async {
                if (element.data["mobile"] == _email) {
                  flag = 1;
                  AuthResult result =
                      await _auth.signInWithCredential(credential);
                  FirebaseUser user = result.user;
                  if (user.uid != null) {
                    await pr.hide();

                    print("```````````````````````````");
                    print(element.data["uid"]);
                    print(element.data["mobile"]);
                    print(element.data["name"]);
                    print(element.data["assignedProject"]);
                    showToast("Login Successful");
                    print("```````````````````````````");
                    _setData(
                        element.data["name"],
                        element.data["email"],
                        element.data["mobile"],
                        element.data["uid"],
                        element.data["assignedProject"]);

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
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
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
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
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
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
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
    final ProgressDialog pr = ProgressDialog(context);

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
//            Container(
//              width: MediaQuery.of(context).size.width,
//              height: 250,
//              decoration: BoxDecoration(
//                gradient: gradients(),
//                borderRadius:
//                    BorderRadius.only(bottomLeft: Radius.circular(100)),
//              ),
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  Icon(
//                    Icons.person,
//                    size: 80,
//                    color: Colors.white,
//                  ),
//                  Align(
//                    alignment: Alignment.bottomRight,
//                    child: Padding(
//                      padding: const EdgeInsets.only(right: 32),
//                    ),
//                  ),
//                ],
//              ),
//            ),

            TopBar(),

            Padding(
              padding: const EdgeInsets.only(
                  top: 10, bottom: 10, left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("User Type:"),
                      SizedBox(
                        width: 30,
                      ),
                      DropdownButton(
                          hint: Text("Select User Type"),
                          value: _requestType,
                          items: _type.map((String userType) {
                            return DropdownMenuItem<String>(
                              value: userType,
                              child: Text(
                                userType,
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _requestType = value;
                            });
                          }),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                      children: _signInMethod == "email"
                          ? showEmail()
                          : showMobile()),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      _signInMethod == "email"
                          ? loginUsingEmail(pr)
                          : checkOTP("+91" + _email, context, pr);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textColor: Colors.white,
                    padding: EdgeInsets.all(0),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(15),
                      decoration: new BoxDecoration(
                          gradient: gradients(),
                          borderRadius: BorderRadius.circular(12.0)),
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

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Container(
        height: 300.0,
      ),
      painter: CurvePainter(),
    );
  }
}

class CurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    Paint paint = Paint();

    path.lineTo(0, size.height * 0.75);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.70,
        size.width * 0.17, size.height * 0.90);
    path.quadraticBezierTo(
        size.width * 0.20, size.height, size.width * 0.25, size.height * 0.90);
    path.quadraticBezierTo(size.width * 0.40, size.height * 0.40,
        size.width * 0.50, size.height * 0.70);
    path.quadraticBezierTo(size.width * 0.60, size.height * 0.85,
        size.width * 0.65, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.70, size.height * 0.90, size.width, 0);
    path.close();

    paint.color = colorThree;
    canvas.drawPath(path, paint);

    path = Path();
    path.lineTo(0, size.height * 0.50);
    path.quadraticBezierTo(size.width * 0.10, size.height * 0.80,
        size.width * 0.15, size.height * 0.60);
    path.quadraticBezierTo(size.width * 0.20, size.height * 0.45,
        size.width * 0.27, size.height * 0.60);
    path.quadraticBezierTo(
        size.width * 0.45, size.height, size.width * 0.50, size.height * 0.80);
    path.quadraticBezierTo(size.width * 0.55, size.height * 0.30,
        size.width * 0.75, size.height * 0.65);
    path.quadraticBezierTo(
        size.width * 0.85, size.height * 0.93, size.width, size.height * 0.50);
    path.lineTo(size.width, 0);
    path.close();

    paint.color = colorTwo;
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
