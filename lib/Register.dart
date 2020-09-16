import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/CommonWidgets.dart';
import 'package:uuid/uuid.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  String _requestType = null ?? "user";
  String _signInMethod = null ?? "email";
  String name;
  String email;
  String phoneNo;
  String address;
  String age;
  String password;
  var credentials;

  TextEditingController controllerName;
  TextEditingController controllerEmail;
  TextEditingController controllerPhoneNo;
  TextEditingController controllerOTP;
  TextEditingController controllerAddress;
  TextEditingController controllerAge;
  TextEditingController controllerPassword;

  Future<bool> checkOTP(String phone, BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 180),
        verificationCompleted: (AuthCredential credential) async {
          //Navigator.of(context).pop();
          print(credential);
          print("`````````````````````````````````````````");
          print("Verification Complete");
          print("`````````````````````````````````````````");
          return credential;
          // AuthResult result = await _auth.signInWithCredential(credential);

          // FirebaseUser user = result.user;

          // if (user != null) {
          //   print(user);
          // } else {
          //   print("Error");
          // }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (AuthException exception) {
          print("`````````````````````````````````````````");
          print("Verification Failed");
          print("`````````````````````````````````````````");
          print(exception.message);
          return null;
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
                        return credential;
                        // AuthResult result =
                        //     await _auth.signInWithCredential(credential);

                        // FirebaseUser user = result.user;

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
        codeAutoRetrievalTimeout: null);
  }

  addUserUsingEmail() async {
    if (_formKey.currentState.validate()) {
      var uuid = Uuid();
      String uniqueID = uuid.v1();
      try {
        await databaseReference
            .child("request")
            .child(_requestType)
            .child(uniqueID)
            .set({
          'name': name,
          'email': email,
          'phoneNo': phoneNo,
          'address': address,
          'age': age,
          'password': password,
        }).then((value) {
          showToast("User requested Added");
        });
        await setState(() {
          controllerAddress = null;
          controllerName = null;
          controllerEmail = null;
          controllerPhoneNo = null;
          controllerAge = null;
          controllerPassword = null;
        });
        Navigator.pop(context);
      } catch (e) {
        showToast("Failed. Check your Internet !");
      }
    }
  }

  addUserUsingPhone() async {
    if (_formKey.currentState.validate()) {
      credentials = checkOTP("+91" + phoneNo, context);
      print(credentials);
      var uuid = Uuid();
      String uniqueID = uuid.v1();
      // try {
      //   await databaseReference
      //       .child("request")
      //       .child(_requestType)
      //       .child(uniqueID)
      //       .set({
      //     'name': name,
      //     'phoneNo': phoneNo,
      //     'address': address,
      //     'age': age,
      //     'credentials': credentials
      //   }).then((value) {
      //     showToast("User requested Added");
      //   });
      //   await setState(() {
      //     controllerAddress = null;
      //     controllerName = null;
      //     controllerPhoneNo = null;
      //     controllerAge = null;
      //     controllerOTP = null;
      //   });
      //   Navigator.pop(context);
      // } catch (e) {
      //   showToast("Failed. Check your Internet !");
      // }
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
        ),
        controller: controllerEmail,
        validator: (val) => val.isEmpty ? 'Enter Email' : null,
        onChanged: (val) {
          setState(() => email = val);
        },
      ),
      SizedBox(height: 15),
      TextFormField(
        decoration: InputDecoration(
          labelText: "Phone no",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
        ),
        controller: controllerPhoneNo,
        validator: (val) => val.isEmpty ? 'Enter Phone Number' : null,
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
        ),
        controller: controllerAddress,
        validator: (val) => val.isEmpty ? 'Enter your Address' : null,
        onChanged: (val) {
          setState(() => address = val);
        },
      ),
      SizedBox(height: 15),
      TextFormField(
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
        ),
        controller: controllerAge,
        validator: (val) => val.isEmpty ? 'Enter your Age' : null,
        onChanged: (val) {
          setState(() => age = val);
        },
      ),
      SizedBox(height: 15),
      TextFormField(
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
          labelText: "Phone no",
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10),
                topLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
                bottomLeft: Radius.circular(10)),
          ),
        ),
        controller: controllerPhoneNo,
        validator: (val) => val.isEmpty ? 'Enter Phone Number' : null,
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
        ),
        controller: controllerAddress,
        validator: (val) => val.isEmpty ? 'Enter your Address' : null,
        onChanged: (val) {
          setState(() => address = val);
        },
      ),
      SizedBox(height: 15),
      TextFormField(
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
      appBar: ThemeAppbar("Request Login"),
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
                      child: Text(
                        'Register for Work Requests',
                        style: titlestyles(18, Colors.orange),
                      ),
                    ),
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
                                  });
                                }),
                            Text("Mobile No.")
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("Type:"),
                        SizedBox(
                          width: 20,
                        ),
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
                    Column(
                      children:
                          _signInMethod == "email" ? emailForm() : mobileForm(),
                    ),
                    Center(
                      child: FlatButton(
                        child: Container(
                          height: 50,
                          width: 400,
                          decoration: BoxDecoration(gradient: gradients()),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 130, top: 15),
                            child: Text(
                              'Register',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _signInMethod == "email"
                              ? addUserUsingEmail()
                              : addUserUsingPhone();
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
