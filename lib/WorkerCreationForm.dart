import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/CommonWidgets.dart';
import 'package:random_string/random_string.dart';
import 'package:uuid/uuid.dart';

class WorkerCreationForm extends StatefulWidget {
  @override
  _WorkerCreationFormState createState() => _WorkerCreationFormState();
}

class _WorkerCreationFormState extends State<WorkerCreationForm> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  String _requestType = null ?? "worker";
  String name;
  String email;
  String phoneNo;
  String address;
  String age;
  String password;

  TextEditingController controllerName;
  TextEditingController controllerEmail;
  TextEditingController controllerPhoneNo;
  TextEditingController controllerAddress;
  TextEditingController controllerAge;
  TextEditingController controllerPassword;

  test() {
    // debugPrint("randpassowrd is " + randPassword.toString());
  }

  addUser() async {
    debugPrint(name);
    if (_formKey.currentState.validate()) {
      var uuid = Uuid();
      String uniqueID = uuid.v1();
      password = randomAlphaNumeric(6);
      debugPrint("pass is " + password);
      try {
        await databaseReference
            .child("request")
            .child("worker")
            .child(uniqueID)
            .set({
          'name': name,
          'email': email,
          'phoneNo': phoneNo,
          'address': address,
          'age': age,
          'password': password,
        });
        await showToast("Worker Details added ");
        debugPrint("name " + name);
        debugPrint("email " + email);
        debugPrint("phoneNo " + phoneNo);
        debugPrint("address " + address);
        debugPrint("age " + age);
        debugPrint("password " + password);

        await setState(() {
          controllerAddress = null;
          controllerName = null;
          controllerEmail = null;
          controllerPhoneNo = null;
          controllerAge = null;
          controllerPassword = null;
        });

        // Navigator.pop(context);
      } catch (e) {
        showToast("Failed. Check your Internet !");
      }
    }
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
                      child: Text(
                        'Make worker form',
                        style: titlestyles(18, Colors.orange),
                      ),
                    ),
                    SizedBox(height: 15),
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
                      decoration: InputDecoration(
                        labelText: "Email",
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
                      validator: (val) =>
                          val.isEmpty ? 'Enter Phone Number' : null,
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
                    // TextFormField(
                    //   obscureText: true,
                    //   decoration: InputDecoration(
                    //     labelText: "Password",
                    //     fillColor: Colors.white,
                    //     focusedBorder: OutlineInputBorder(
                    //       borderSide:
                    //           const BorderSide(color: Colors.blue, width: 2.0),
                    //       borderRadius: BorderRadius.only(
                    //           topRight: Radius.circular(10),
                    //           topLeft: Radius.circular(10),
                    //           bottomRight: Radius.circular(10),
                    //           bottomLeft: Radius.circular(10)),
                    //     ),
                    //   ),
                    //   controller: controllerPassword,
                    //   validator: (val) => val.isEmpty ? 'Enter Password' : null,
                    //   onChanged: (val) {
                    //     setState(() => password = val);
                    //   },
                    // ),
                    SizedBox(height: 10),
                    Center(
                      child: FlatButton(
                        child: Container(
                          height: 50,
                          width: 400,
                          decoration: BoxDecoration(gradient: gradients()),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 130, top: 15),
                            child: Text(
                              'Add Machine',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            addUser();
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
