import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/authenticationService.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/database.dart';
import 'package:project_timeline/admin/DocumentManager/wrapper.dart';
import 'Register.dart';
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
  List<String> _type = [workerType, supervisorType, managerType];
  String _requestType = null ?? workerType;
  String _signInMethod = null ?? "email";
  String _email, _password;
  var credential, selectedType, flag = 0, firstTimeLogin = 0;

  final formKey = new GlobalKey<FormState>();
  final userController = TextEditingController();
  final passController = TextEditingController();
  final controllerOTP = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference workers =
      FirebaseFirestore.instance.collection("workers");
  final CollectionReference users =
      FirebaseFirestore.instance.collection("user");
  final CollectionReference supervisor =
      FirebaseFirestore.instance.collection("supervisor");
  final CollectionReference manager =
      FirebaseFirestore.instance.collection("manager");
  final CollectionReference newPhoneUser =
      FirebaseFirestore.instance.collection("newPhoneUser");

  // signOut() async {
  //   await _auth.signOut().then((value) {
  //     return Navigator.pushReplacement(context,
  //         MaterialPageRoute(builder: (context) {
  //       showToast("Logout Successful");
  //       return Wrapper();
  //     }));
  //   });
  // }

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
        verificationFailed: (FirebaseAuthException exception) {
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
                            PhoneAuthProvider.credential(
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
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  loginUsingEmail(pr) async {
    await pr.show();
    print(_email);
    print(_password);
    try {
      if (_requestType == userType) {
        print("user");
        await users.get().then((value) {
          value.docs.forEach((element) async {
            if (element.data()["email"] == _email) {
              flag = 1;
              UserCredential result = await _auth
                  .signInWithEmailAndPassword(
                      email: _email, password: _password)
                  .catchError((e) {
                showToast(e.toString());
              });
              User user = result.user;

              // rushil part

              try {
                DatabaseService(
                  userID: user.uid,
                );

                AuthenticationService().userfromAuthentication(user);
              } catch (e) {
                debugPrint(e.toString());
                // return null;
              }

              //
              if (user.uid != null) {
                await pr.hide();
                print("```````````````````````````");
                print("account login successful");
                print(user.uid);
                print(element.data()["email"]);
                print(element.data()["mobile"]);
                print(element.data()["name"]);
                print(element.data()["assignedProject"]);
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
      } else if (_requestType == supervisorType) {
        print("supervisor");
        await supervisor.get().then((value) {
          value.docs.forEach((element) async {
            if (element.data()["email"] == _email) {
              flag = 1;
              UserCredential result = await _auth
                  .signInWithEmailAndPassword(
                      email: _email, password: _password)
                  .catchError((e) {
                showToast(e.toString());
              });

              User user = result.user;
              if (user.uid != null) {
                print("```````````````````````````");
                print("account login successful");
                print(user.uid);
                print(element.data()["email"]);
                print(element.data()["mobile"]);
                print(element.data()["name"]);
                print(element.data()["assignedProject"]);
                showToast("Login Successful");
                print("```````````````````````````");
                _setData(
                    element.data()["name"],
                    element.data()["email"],
                    element.data()["mobile"],
                    element.data()["uid"],
                    element.data()["assignedProject"]);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SupervisorHomePage()),
                );
              }
            }
          });
        });
        if (flag == 0) showToast("Account is not Accepted");
      } else if (_requestType == workerType) {
        print("worker");
        await workers.get().then((value) {
          value.docs.forEach((element) async {
            if (element.data()["email"] == _email) {
              flag = 1;
              print(element.data());
              UserCredential result = await _auth
                  .signInWithEmailAndPassword(
                      email: _email, password: _password)
                  .catchError((e) {
                showToast(e.toString());
              });
              User user = result.user;
              if (user.uid != null) {
                print("```````````````````````````");
                print("account login successful");
                print(user.uid);
                print(element.data()["email"]);
                print(element.data()["mobile"]);
                print(element.data()["name"]);
                print(element.data()["assignedProject"]);
                showToast("Login Successful");
                print("```````````````````````````");
                _setData(
                    element.data()["name"],
                    element.data()["email"],
                    element.data()["mobile"],
                    element.data()["uid"],
                    element.data()["assignedProject"]);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkerHomePage()),
                );
              }
            }
          });
        });
        if (flag == 0) showToast("Account is not Accepted");
      } else if (_requestType == managerType) {
        print("manager");
        await manager.get().then((value) {
          value.docs.forEach((element) async {
            if (element.data()["email"] == _email) {
              flag = 1;
              print(element.data());
              UserCredential result = await _auth
                  .signInWithEmailAndPassword(
                      email: _email, password: _password)
                  .catchError((e) {
                showToast(e.toString());
              });
              User user = result.user;
              if (user.uid != null) {
                print("```````````````````````````");
                print("account login successful");
                print(user.uid);
                print(element.data()["email"]);
                print(element.data()["mobile"]);
                print(element.data()["name"]);
                print(element.data()["assignedProject"]);
                showToast("Login Successful");
                print("```````````````````````````");
                _setData(
                    element.data()["name"],
                    element.data()["email"],
                    element.data()["mobile"],
                    element.data()["uid"],
                    element.data()["assignedProject"]);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ManagerHomePage()),
                );
              }
            }
          });
        });
        if (flag == 0) showToast("Account is not Accepted");
      } else {
        print("error");
      }
    } catch (e) {
      print("```````````````````````````");
      print(e.toString());
      await pr.hide();
      print("```````````````````````````");
    }
    await pr.hide();
  }

  loginUsingOTP(credential, pr) async {
    print("```````````````````````````");
    print(_requestType);
    print("```````````````````````````");
    try {
      if (_requestType == userType) {
        await newPhoneUser.get().then((value) {
          value.docs.forEach((element) async {
            if (element.id == _email &&
                element.data()["userType"] == userType) {
              firstTimeLogin = 1;
              UserCredential result =
                  await _auth.signInWithCredential(credential);
              User user = result.user;
              if (user.uid != null) {
                await pr.hide();
                print("```````````````````````````");
                print("account creation successful");
                print(user.uid);
                print(element.data()["mobile"]);
                print(element.data()["name"]);
                print(element.data()["assignedProject"]);
                showToast("Login Successful");
                print("```````````````````````````");
                users.doc(user.uid).set({
                  "assignedProject": "No project assigned",
                  "mobile": element["mobile"],
                  "name": element["name"],
                  "age": element["age"],
                  "address": element["address"],
                  "uid": user.uid,
                  'signInMethod': "otp"
                }).then((value) async {
                  await newPhoneUser.doc(_email).delete().then((value) {
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
          await users.get().then((value) {
            value.docs.forEach((element) async {
              if (element.data()["mobile"] == _email &&
                  _signInMethod == "otp") {
                flag = 1;
                UserCredential result =
                    await _auth.signInWithCredential(credential);
                User user = result.user;
                if (user.uid != null) {
                  await pr.hide();
                  print("```````````````````````````");
                  print(element.data()["uid"]);
                  print(element.data()["mobile"]);
                  print(element.data()["name"]);
                  print(element.data()["assignedProject"]);
                  showToast("Login Successful");
                  print("```````````````````````````");
                  _setData(
                      element.data()["name"],
                      element.data()["email"],
                      element.data()["mobile"],
                      element.data()["uid"],
                      element.data()["assignedProject"]);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManagerHomePage()),
                  );
                }
              }
            });
          });
          if (flag == 0) {
            showToast("Please register first");
          }
        } else {
          await newPhoneUser.doc(_email).delete();
        }
      } else if (_requestType == supervisorType) {
        await newPhoneUser.get().then((value) {
          value.docs.forEach((element) async {
            if (element.id == _email &&
                element.data()["userType"] == supervisorType) {
              firstTimeLogin = 1;
              UserCredential result =
                  await _auth.signInWithCredential(credential);
              User user = result.user;
              if (user.uid != null) {
                await pr.hide();

                print("```````````````````````````");
                print("account creation successful");
                print(user.uid);
                print(element.data()["mobile"]);
                print(element.data()["name"]);
                print(element.data()["assignedProject"]);
                showToast("Login Successful");
                print("```````````````````````````");
                supervisor.doc(user.uid).set({
                  "assignedProject": "No project assigned",
                  "mobile": element["mobile"],
                  "name": element["name"],
                  "age": element["age"],
                  "address": element["address"],
                  "uid": user.uid,
                  'signInMethod': "otp"
                }).then((value) async {
                  await newPhoneUser.doc(_email).delete().then((value) {
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
          await supervisor.get().then((value) {
            value.docs.forEach((element) async {
              if (element.data()["mobile"] == _email &&
                  _signInMethod == "otp") {
                flag = 1;
                UserCredential result =
                    await _auth.signInWithCredential(credential);
                User user = result.user;
                if (user.uid != null) {
                  await pr.hide();

                  print("```````````````````````````");
                  print(element.data()["uid"]);
                  print(element.data()["mobile"]);
                  print(element.data()["name"]);
                  print(element.data()["assignedProject"]);
                  showToast("Login Successful");
                  print("```````````````````````````");
                  _setData(
                      element.data()["name"],
                      element.data()["email"],
                      element.data()["mobile"],
                      element.data()["uid"],
                      element.data()["assignedProject"]);
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
          await newPhoneUser.doc(_email).delete();
        }
      } else if (_requestType == workerType) {
        await newPhoneUser.get().then((value) {
          value.docs.forEach((element) async {
            if (element.id == _email &&
                element.data()["userType"] == workerType) {
              firstTimeLogin = 1;
              UserCredential result =
                  await _auth.signInWithCredential(credential);
              User user = result.user;
              if (user.uid != null) {
                await pr.hide();

                print("```````````````````````````");
                print("account creation successful");
                print(user.uid);
                print(element.data()["mobile"]);
                print(element.data()["name"]);
                print(element.data()["assignedProject"]);
                showToast("Login Successful");
                print("```````````````````````````");
                workers.doc(user.uid).set({
                  "assignedProject": "No project assigned",
                  "mobile": element["mobile"],
                  "name": element["name"],
                  "age": element["age"],
                  "address": element["address"],
                  "uid": user.uid,
                  'signInMethod': "otp"
                }).then((value) async {
                  _setData(element["name"], element["email"], element["mobile"],
                      user.uid, "No project assigned");
                  await newPhoneUser.doc(_email).delete().then((value) {
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
          await workers.get().then((value) {
            value.docs.forEach((element) async {
              if (element.data()["mobile"] == _email &&
                  _signInMethod == "otp") {
                flag = 1;
                UserCredential result =
                    await _auth.signInWithCredential(credential);
                User user = result.user;
                if (user.uid != null) {
                  await pr.hide();
                  print("```````````````````````````");
                  print(element.data()["uid"]);
                  print(element.data()["mobile"]);
                  print(element.data()["name"]);
                  print(element.data()["assignedProject"]);
                  showToast("Login Successful");
                  print("```````````````````````````");
                  _setData(
                      element.data()["name"],
                      element.data()["email"],
                      element.data()["mobile"],
                      element.data()["uid"],
                      element.data()["assignedProject"]);
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
          await newPhoneUser.doc(_email).delete();
        }
      } else if (_requestType == managerType) {
        await newPhoneUser.get().then((value) {
          value.docs.forEach((element) async {
            if (element.id == _email &&
                element.data()["userType"] == managerType) {
              firstTimeLogin = 1;
              UserCredential result =
                  await _auth.signInWithCredential(credential);
              User user = result.user;
              if (user.uid != null) {
                await pr.hide();

                print("```````````````````````````");
                print("account creation successful");
                print(user.uid);
                print(element.data()["mobile"]);
                print(element.data()["name"]);
                print(element.data()["assignedProject"]);
                showToast("Login Successful");
                print("```````````````````````````");
                manager.doc(user.uid).set({
                  "assignedProject": "No project assigned",
                  "mobile": element["mobile"],
                  "name": element["name"],
                  "age": element["age"],
                  "address": element["address"],
                  "uid": user.uid,
                  'signInMethod': "otp"
                }).then((value) async {
                  await newPhoneUser.doc(_email).delete().then((value) {
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
          await manager.get().then((value) {
            value.docs.forEach((element) async {
              if (element.data()["mobile"] == _email &&
                  _signInMethod == "otp") {
                flag = 1;
                UserCredential result =
                    await _auth.signInWithCredential(credential);
                User user = result.user;
                if (user.uid != null) {
                  await pr.hide();

                  print("```````````````````````````");
                  print(element.data()["uid"]);
                  print(element.data()["mobile"]);
                  print(element.data()["name"]);
                  print(element.data()["assignedProject"]);
                  showToast("Login Successful");
                  print("```````````````````````````");
                  _setData(
                      element.data()["name"],
                      element.data()["email"],
                      element.data()["mobile"],
                      element.data()["uid"],
                      element.data()["assignedProject"]);

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ManagerHomePage()),
                  );
                }
              }
            });
          });
          if (flag == 0) {
            showToast("Please register first");
          }
        } else {
          await newPhoneUser.doc(_email).delete();
        }
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
            setState(() {
              _email = value;
            });
          },
          validator: (val) => val.isEmpty ? 'Enter email' : null,
          keyboardType: TextInputType.emailAddress,
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
          obscureText: true,
          controller: passController,
          onChanged: (value) {
            setState(() {
              _password = value;
            });
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
            setState(() {
              _email = value;
            });
          },
          validator: (val) => val.isEmpty ? 'Enter mobile number' : null,
          keyboardType: TextInputType.phone,
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
        backgroundColor: Colors.white,
        //resizeToAvoidBottomInset: false,
        body: Background(
          child: SingleChildScrollView(
              child: Container(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Login",
                    style: GoogleFonts.playfairDisplay(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w700,
                        fontSize: 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/3293465.jpg",
                        height: 180,
                        width: 350,
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 10, left: 30, right: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Signed In Method: ",
                              style: GoogleFonts.merriweather(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: "email",
                                    groupValue: _signInMethod,
                                    onChanged: (value) {
                                      setState(() {
                                        _signInMethod = value;
                                        userController.clear();
                                      });
                                    }),
                                Text(
                                  "Email",
                                  style: GoogleFonts.merriweather(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
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
                                        userController.clear();
                                      });
                                    }),
                                Text(
                                  "OTP",
                                  style: GoogleFonts.merriweather(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "User Type: ",
                              style: GoogleFonts.merriweather(
                                  fontWeight: FontWeight.w700, fontSize: 16),
                            ),
                            SizedBox(
                              width: 30,
                            ),
                            DropdownButton(
                                hint: Text("Select User Type"),
                                value: _requestType,
                                items: _type.map((String usertype) {
                                  return DropdownMenuItem<String>(
                                    value: usertype,
                                    child: Text(
                                      usertype,
                                      style: GoogleFonts.merriweather(
                                        fontWeight: FontWeight.w400,
                                      ),
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
                          height: 10,
                        ),
                        Column(
                            children: _signInMethod == "email"
                                ? showEmail()
                                : showMobile()),
                        SizedBox(
                          height: 5,
                        ),
                        Center(
                          child: RaisedButton(
                            onPressed: () async {
                              if (formKey.currentState.validate()) {
                                _signInMethod == "email"
                                    ? loginUsingEmail(pr)
                                    : checkOTP("+91" + _email, context, pr);
                              }
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            textColor: Colors.white,
                            padding: EdgeInsets.all(0),
                            child: Container(
                              width: 200,
                              padding: EdgeInsets.all(15),
                              decoration: new BoxDecoration(
                                  color: Color(0xff005c9d),
                                  borderRadius: BorderRadius.circular(12.0)),
                              child: Text(
                                "LOGIN",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.merriweather(
                                    fontWeight: FontWeight.w400, fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 9,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: GoogleFonts.merriweather(
                                  fontWeight: FontWeight.w400, fontSize: 18),
                            ),
                            FlatButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Register()),
                                );
                              },
                              child: Text(
                                'Register',
                                style: GoogleFonts.merriweather(
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
          )),
        ));
  }
}

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/image.png",
              width: size.width * 0.35,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset(
              "assets/image2.png",
              width: size.width * 0.4,
            ),
          ),
          child,
        ],
      ),
    );
  }
}
