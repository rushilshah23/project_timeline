import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/authenticationService.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/database.dart';
import 'package:project_timeline/admin/DocumentManager/wrapper.dart';
import 'package:project_timeline/admin/login.dart';

import 'CommonWidgets.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final databaseReference = FirebaseDatabase.instance.reference();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference user =
      FirebaseFirestore.instance.collection("user");
  final _formKey = new GlobalKey<FormState>();

  List<String> _type = [workerType, supervisorType, managerType];
  List<String> tempTypes = ["worker", "supervisor", "manager"];
  String tempSelectedType;
  String _requestType = null ?? workerType;
  String _signInMethod = null ?? "email";
  String name;
  String email;
  String phoneNo;
  String address;
  String age;
  String password;
  var code, uuid;

  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPhoneNo = TextEditingController();
  final controllerOTP = TextEditingController();
  final controllerAddress = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerPassword = TextEditingController();

  @override
  void initState() {
    tempSelectedType = tempTypes[0];
    super.initState();
  }

  checkOTP(String phone, BuildContext context) async {}

  addUserUsingEmail() async {
    if (_formKey.currentState.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((UserCredential result) async {
          uuid = result.user.uid;
          await user.doc(result.user.uid).set({
            "email": email,
            "mobile": phoneNo,
            "name": name,
            "uid": result.user.uid,
            "address": address,
            "age": age,
            "password": password,
            'signInMethod': "email"
          }).then((value) async {
            await databaseReference
                .child("request")
                .child(tempSelectedType)
                .child(uuid)
                .set({
              "uid": result.user.uid,
              'name': name,
              'email': email,
              'phoneNo': phoneNo,
              'address': address,
              'age': age,
              'password': password,
              'signInMethod': "email"
            }).then((value) async {
              User user = result.user;
              await DatabaseService(
                userID: user.uid,
              ).updateUserData(
                folderName: user.email,
              );

              AuthenticationService().userfromAuthentication(user);
              showToast("Request Successfully Sent");
            });
          });
        });
        Navigator.pop(context);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return LoginPage();
        }));
      } catch (e) {
        showToast(e.toString());
      }
    }
  }

  addUserUsingPhone(context) async {
    if (_formKey.currentState.validate()) {
      await _auth.verifyPhoneNumber(
          phoneNumber: "+91" + phoneNo,
          timeout: Duration(seconds: 120),
          verificationCompleted: (AuthCredential credential) async {
            //Navigator.of(context).pop();
            print(credential);
            print("`````````````````````````````````````````");
            print("Verification Complete");
            print("`````````````````````````````````````````");
            UserCredential result =
                await _auth.signInWithCredential(credential);
            User user = result.user;

            // Rushil part
            DatabaseService(
              userID: user.uid,
            ).updateUserData(
              folderName: user.phoneNumber,
            );
            AuthenticationService().userfromAuthentication(user);

            //
            addDB(user.uid);

            // if (user != null) {
            //   print(user);
            // } else {
            //   print("Error");
            // }

            //This callback would gets called when verification is done auto maticlly
          },
          verificationFailed: (FirebaseAuthException exception) {
            print("`````````````````````````````````````````");
            print("Verification Failed");
            print("`````````````````````````````````````````");
            print(exception.message);
          },
          codeSent: (String verificationId, [int forceResendingToken]) {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Give the code?"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        TextField(
                          controller: controllerOTP,
                          onChanged: (value) {
                            code = value.trim();
                          },
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Confirm"),
                        textColor: Colors.white,
                        color: Colors.blue,
                        onPressed: () async {
                          AuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: code);
                          print(credential);
                          print("`````````````````````````````````````````");
                          print("Verification Complete");
                          print("`````````````````````````````````````````");
                          UserCredential result =
                              await _auth.signInWithCredential(credential);
                          User user = result.user;

                          // RUSHIL PART

                          await DatabaseService(
                            userID: user.uid,
                          ).updateUserData(
                            folderName: user.phoneNumber,
                          );
                          AuthenticationService().userfromAuthentication(user);
                          //
                          addDB(user.uid);

                          // if (user != null) {
                          //   print(user);
                          // } else {
                          //   print("Error");
                          // }
                        },
                      )
                    ],
                  );
                });
          },
          codeAutoRetrievalTimeout: (String verificationId) {});
    }
  }

  addDB(uniqueID) async {
    try {
      await user.doc(uniqueID).set({
        "mobile": phoneNo,
        "name": name,
        "uid": uniqueID,
        "address": address,
        "age": age,
        "userType": tempSelectedType,
        'signInMethod': "otp"
      }).then((value) async {
        await databaseReference
            .child("request")
            .child(tempSelectedType)
            .child(uniqueID)
            .set({
          "uid": uniqueID,
          'name': name,
          'phoneNo': phoneNo,
          'address': address,
          'age': age,
          'signInMethod': "otp"
        }).then((value) {
          showToast("Request successfully sent");
        });
      });
      Navigator.pop(context);
    } catch (e) {
      showToast("Failed. Check your Internet !");
    }
  }

  List<Widget> emailForm() {
    return [
      TextFormField(
        decoration: InputDecoration(
          labelText: "Name",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        controller: controllerName,
        validator: (val) => val.isEmpty ? 'Enter your Name' : null,
        onChanged: (val) {
          setState(() => name = val);
        },
      ),
      SizedBox(height: 15),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Email",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        controller: controllerEmail,
        validator: (val) {
          Pattern pattern =
              r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
              r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
              r"{0,253}[a-zA-Z0-9])?)*$";
          RegExp regex = new RegExp(pattern);
          if (val.isEmpty) return 'Enter Email';
          if (!regex.hasMatch(val) || val == null)
            return 'Enter a valid email address';
          else
            return null;
        },
        onChanged: (val) {
          setState(() => email = val);
        },
      ),
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(
          labelText: "Mobile no",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        controller: controllerPhoneNo,
        keyboardType: TextInputType.number,
        validator: (val) {
          if (val.isEmpty) return 'Enter Phone Number';
          if (val.length < 10 || val.length > 10)
            return 'Enter a valid Phone Number';
          else
            return null;
        },
        onChanged: (val) {
          setState(() => phoneNo = val);
        },
      ),
      SizedBox(height: 15),
      TextFormField(
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        decoration: InputDecoration(
          labelText: "Address",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        controller: controllerAddress,
        validator: (val) => val.isEmpty ? 'Enter your Address' : null,
        onChanged: (val) {
          setState(() => address = val);
        },
      ),
      SizedBox(height: 15),
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Age",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        controller: controllerAge,
        validator: (val) => val.isEmpty ? 'Enter your Age' : null,
        onChanged: (val) {
          setState(() => age = val);
        },
      ),
      SizedBox(height: 15),
      TextFormField(
        // keyboardType: TextInputType.visiblePassword,
        obscureText: true,
        decoration: InputDecoration(
          labelText: "Password",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        controller: controllerPassword,
        validator: (val) => val.isEmpty ? 'Enter Password' : null,
        onChanged: (val) {
          setState(() => password = val);
        },
      ),
      SizedBox(height: 20)
    ];
  }

  List<Widget> mobileForm() {
    return [
      TextFormField(
        decoration: InputDecoration(
          labelText: "Name",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        controller: controllerName,
        validator: (val) => val.isEmpty ? 'Enter your Name' : null,
        onChanged: (val) {
          setState(() => name = val);
        },
      ),
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(
          labelText: "Mobile no",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        controller: controllerPhoneNo,
        keyboardType: TextInputType.number,
        validator: (val) {
          if (val.isEmpty) return 'Enter Phone Number';
          if (val.length < 10 || val.length > 10)
            return 'Enter a valid Phone Number';
          else
            return null;
        },
        onChanged: (val) {
          setState(() => phoneNo = val);
        },
      ),
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(
          labelText: "Address",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        controller: controllerAddress,
        validator: (val) => val.isEmpty ? 'Enter your Address' : null,
        onChanged: (val) {
          setState(() => address = val);
        },
      ),
      SizedBox(height: 15),
      TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: "Age",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        ),
        controller: controllerAge,
        validator: (val) => val.isEmpty ? 'Enter your Age' : null,
        onChanged: (val) {
          setState(() => age = val);
        },
      ),
      SizedBox(height: 20)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xff005c9d),
        ),
        title: Text("Register",
            style: TextStyle(
              color: Color(0xff005c9d),
            )),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: titleStyles('Register for Work Requests', 18)),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Text("Sign In Method"),
                        SizedBox(
                          width: 20,
                        ),
                        Row(
                          children: [
                            Radio(
                                value: "email",
                                groupValue: _signInMethod,
                                onChanged: (value) {
                                  setState(() {
                                    _signInMethod = value;
                                    controllerName.clear();
                                    controllerPhoneNo.clear();
                                    controllerAddress.clear();
                                    controllerAge.clear();
                                  });
                                }),
                            Text("Email ID")
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
                                    controllerName.clear();
                                    controllerEmail.clear();
                                    controllerPhoneNo.clear();
                                    controllerAddress.clear();
                                    controllerAge.clear();
                                    controllerPassword.clear();
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
                                tempSelectedType =
                                    tempTypes[_type.indexOf(_requestType)];
                              });
                            }),
                      ],
                    ),
                    Column(
                      children:
                          _signInMethod == "email" ? emailForm() : mobileForm(),
                    ),
                    Center(
                      child: FlatButton(
                        child: buttonContainers(400, 20, 'Register', 18),
                        onPressed: () {
                          _signInMethod == "email"
                              ? addUserUsingEmail()
                              : addUserUsingPhone(context);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
