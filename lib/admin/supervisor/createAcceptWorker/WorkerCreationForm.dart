import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:random_string/random_string.dart';

class WorkerCreationForm extends StatefulWidget {
  @override
  _WorkerCreationFormState createState() => _WorkerCreationFormState();
}

class _WorkerCreationFormState extends State<WorkerCreationForm> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final CollectionReference workers =
      FirebaseFirestore.instance.collection("workers");
  final CollectionReference newPhoneUser =
      FirebaseFirestore.instance.collection("newPhoneUser");
  FirebaseAuth auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      password = randomAlphaNumeric(6);
    });
  }

  String _signInMethod = null ?? "email";
  String name;
  String email;
  String phoneNo;
  String address;
  String age;
  String password;

  final controllerName = TextEditingController();
  final controllerEmail = TextEditingController();
  final controllerPhoneNo = TextEditingController();
  final controllerOTP = TextEditingController();
  final controllerAddress = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerPassword = TextEditingController();

  addUserUsingEmail() async {
    if (_formKey.currentState.validate()) {
      debugPrint("name " + name);
      debugPrint("email " + email);
      debugPrint("phoneNo " + phoneNo);
      debugPrint("address " + address);
      debugPrint("age " + age);
      debugPrint("password " + password);
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((UserCredential result) async {
          await workers.doc(result.user.uid).set({
            "assignedProject": "No project assigned",
            "email": email,
            "mobile": phoneNo,
            "name": name,
            "uid": result.user.uid,
            "address": address,
            "age": age,
            "password": password,
            "signInMethod": 'email',
          }).then((value) async {
            showToast("Added successfully");
          });
        });

        // Navigator.pop(context);
      } catch (e) {
        showToast("Failed. Check your Internet !");
      }
    }
  }

  addUserUsingPhone() async {
    if (_formKey.currentState.validate()) {
      try {
        await newPhoneUser.doc(phoneNo).set({
          "userType": "worker",
          "mobile": phoneNo,
          "name": name,
          "address": address,
          "age": age,
          "assignedProject": 'No project assigned',
          "signInMethod": 'otp',
        }).then((value) async {
          showToast("Added successfully");
        });
      } catch (e) {
        showToast("Failed. Check your Internet !");
      }
    }
  }

  List<Widget> emailForm() {
    return [
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
        keyboardType: TextInputType.emailAddress,
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
    ];
  }

  List<Widget> mobileForm() {
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ThemeAppbar("Request Login"),
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
                      child: titleStyles('Make worker form', 18),
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
                    Column(
                      children:
                          _signInMethod == "email" ? emailForm() : mobileForm(),
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Name",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                        ),
                      ),
                      controller: controllerName,
                      validator: (val) =>
                          val.isEmpty ? 'Enter your Name' : null,
                      onChanged: (val) {
                        setState(() => name = val);
                      },
                    ),
                    SizedBox(height: 15),
                    TextFormField(
                       keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Phone no",
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                        ),
                      ),
                      controller: controllerPhoneNo,
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
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                        ),
                      ),
                      controller: controllerAddress,
                      validator: (val) =>
                          val.isEmpty ? 'Enter your Address' : null,
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
                          borderSide:
                              const BorderSide(color: Colors.blue, width: 2.0),
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
                    _signInMethod == "email"
                        ? TextFormField(
                            initialValue: password,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: "Password",
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.blue, width: 2.0),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    topLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10)),
                              ),
                            ),
                            // controller: controllerPassword,
                            // validator: (val) => val.isEmpty ? 'Enter Password' : null,
                            // onChanged: (val) {
                            //   setState(() => password = val);
                            // },
                          )
                        : Container(),
                    SizedBox(height: 20),
                    Center(
                      child: FlatButton(
//                        child: Container(
//                          height: 50,
//                          width: 400,
//                          decoration: BoxDecoration(gradient: gradients()),
//                          child: Padding(
//                            padding: const EdgeInsets.only(left: 130, top: 15),
//                            child: Text(
//                              'Create Worker',
//                              style: TextStyle(color: Colors.white),
//                            ),
//                          ),
//                        ),
                        child: buttonContainers(400, 'Create Worker', 18),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _signInMethod == "email"
                                  ? addUserUsingEmail()
                                  : addUserUsingPhone();
                            });
                            // test();
                          }
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
