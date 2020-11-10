import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/admin/headings.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  final String uid, userType;
  ProfilePage({Key key, this.userType, this.uid}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();

  List collection = ["manager", "supervisor", "workers"];

  Map myData;
  bool status = false;
  String usertype, signinMethod;

  FirebaseAuth _auth = FirebaseAuth.instance;

  _loadData() async {
    await FirebaseFirestore.instance
        .collection(usertype)
        .doc(widget.uid)
        .get()
        .then((myDocuments) {
      myData = myDocuments.data();

      debugPrint(myData.toString());
      setState(() {
        nameController.text = myData["name"] ?? "";
        emailController.text = myData["email"] ?? "";
        mobileController.text = myData["mobile"] ?? "";
        addressController.text = myData["address"] ?? "";
        ageController.text = myData["age"] ?? "";
        status = true;
        signinMethod = myData["signInMethod"] ?? "";
      });
    });
  }

  editData() async {
    try {
      await FirebaseFirestore.instance
          .collection(usertype)
          .doc(widget.uid)
          .update({
        'name': nameController.text,
        'email': emailController.text ?? "",
        'mobile': mobileController.text ?? "",
        'address': addressController.text,
        'age': ageController.text,
      });

      showToast("Edited Successfully");
    } catch (e) {
      debugPrint(e.toString());
      showToast("Failed");
    }
  }

  // _setData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.clear();

  //   prefs.setString('email', emailController.text);
  //   prefs.setString('name', nameController.text);
  //   prefs.setString('mobile', mobileController.text);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.userType == managerType)
      setState(() {
        usertype = collection[0];
      });
    else if (widget.userType == supervisorType)
      setState(() {
        usertype = collection[1];
      });
    else if (widget.userType == workerType)
      setState(() {
        usertype = collection[2];
      });

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppbar(forgotPassText[0], context),
      body: status
          ? Center(
              child: Container(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              padding: EdgeInsets.only(top: 20, right: 20, left: 20),

              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        titleStyles(forgotPassText[1], 20),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          //initialValue: name,

                          validator: (String content) {
                            if (content.isEmpty) {
                              return forgotPassText[2];
                            } else {
                              return null;
                            }
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: forgotPassText[3],
                            border: OutlineInputBorder(),
                            //hintText: "Enter Petrol Pump Name",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        signinMethod.toLowerCase().contains("email")
                            ? TextFormField(
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
                                enabled:
                                    signinMethod.toLowerCase().contains("email")
                                        ? false
                                        : true,
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: forgotPassText[5],
                                  border: OutlineInputBorder(),
                                  //hintText: "Enter Petrol Pump Address",
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          enabled: signinMethod.toLowerCase().contains("otp")
                              ? false
                              : true,
                          validator: (val) {
                            if (val.length < 10 || val.length > 10)
                              return forgotPassText[6];
                            else
                              return null;
                          },
                          keyboardType: TextInputType.number,
                          controller: mobileController,
                          decoration: InputDecoration(
                            labelText: forgotPassText[7],
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          maxLines: 5,
                          validator: (String content) {
                            if (content.isEmpty) {
                              return forgotPassText[8];
                            } else {
                              return null;
                            }
                          },
                          controller: addressController,
                          decoration: InputDecoration(
                            labelText: forgotPassText[9],
                            border: OutlineInputBorder(),
                            //hintText: "Enter Petrol Pump Town",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          validator: (String content) {
                            if (content.isEmpty) {
                              return forgotPassText[10];
                            } else {
                              return null;
                            }
                          },
                          controller: ageController,
                          decoration: InputDecoration(
                            labelText: forgotPassText[11],
                            border: OutlineInputBorder(),
                            //hintText: "Enter Petrol Pump Town",
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FlatButton(
                              child: Container(
                                height: 45,
                                width: 120,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  color: Color(0xff018abd),
                                ),
                                child: Center(
                                    child: Text(
                                  forgotPassText[12],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                )),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  editData();
                                }
                              },
                            ),
                            signinMethod.toLowerCase().contains("email")
                                ? FlatButton(
                                    child: Container(
                                      height: 45,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        color: Color(0xff018abd),
                                      ),
                                      child: Center(
                                          child: Text(
                                        forgotPassText[13],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      )),
                                    ),
                                    onPressed: () {
                                      if (emailController.text != "")
                                        _auth
                                            .sendPasswordResetEmail(
                                                email: emailController.text)
                                            .then((value) {
                                          showToast(forgotPassText[14]);
                                        });
                                    },
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ))
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
