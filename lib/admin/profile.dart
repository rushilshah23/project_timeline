import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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
      appBar: ThemeAppbar("Edit Profile", context),
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
                        titleStyles('Edit Your Details', 20),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          //initialValue: name,

                          validator: (String content) {
                            if (content.isEmpty) {
                              return "Please enter your name";
                            } else {
                              return null;
                            }
                          },
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Your Name",
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
                                    return 'Enter a valid email address';
                                  else
                                    return null;
                                },
                                enabled:
                                    signinMethod.toLowerCase().contains("email")
                                        ? false
                                        : true,
                                controller: emailController,
                                decoration: InputDecoration(
                                  labelText: "Your Email",
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
                              return 'Enter a valid phone number';
                            else
                              return null;
                          },
                          keyboardType: TextInputType.number,
                          controller: mobileController,
                          decoration: InputDecoration(
                            labelText: "Your Mobile",
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
                              return "Please enter the address";
                            } else {
                              return null;
                            }
                          },
                          controller: addressController,
                          decoration: InputDecoration(
                            labelText: "Your Address",
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
                              return "Please enter your age";
                            } else {
                              return null;
                            }
                          },
                          controller: ageController,
                          decoration: InputDecoration(
                            labelText: "Your Age",
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
                              "Edit Data",
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
