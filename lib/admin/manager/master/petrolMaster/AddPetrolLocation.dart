import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:uuid/uuid.dart';

class AddPetrolLocation extends StatefulWidget {
  @override
  _AddPetrolLocationState createState() => _AddPetrolLocationState();
}

class _AddPetrolLocationState extends State<AddPetrolLocation> {
  String petrolPumpName,
      petrolPumpAddress,
      petrolPumpPhoneNumber,
      petrolPumpDistrict,
      petrolPumpTown,
      petrolPumpPinCode;
  final _formKey = GlobalKey<FormState>();
  TextEditingController petrolPumpNameController = TextEditingController();
  TextEditingController petrolPumpAddressController = TextEditingController();
  TextEditingController petrolPumpPhoneNumberController =
      TextEditingController();
  TextEditingController petrolPumpDistrictController = TextEditingController();
  TextEditingController petrolPumpTownController = TextEditingController();
  TextEditingController petrolPumpPinCodeController = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();

  addPetrolPump() async {
    debugPrint("testing add petrol pump");
    if (_formKey.currentState.validate()) {
      setState(() {
        petrolPumpName = petrolPumpNameController.text;
        petrolPumpAddress = petrolPumpAddressController.text;
        petrolPumpPhoneNumber = petrolPumpPhoneNumberController.text;
        petrolPumpDistrict = petrolPumpDistrictController.text;
        petrolPumpTown = petrolPumpTownController.text;
        petrolPumpPinCode = petrolPumpPinCodeController.text;
      });

      if (petrolPumpName == null) {
        return "Not Specified ";
      } else
        petrolPumpName = petrolPumpName;

      // if (petrolPumpAddress == null) {
      //   petrolPumpAddress = "Not Specified ";
      // } else
      //   petrolPumpAddress = petrolPumpAddress;

      // if (petrolPumpPhoneNumber == null) {
      //   petrolPumpPhoneNumber = "Not Specified ";
      // } else
      //   petrolPumpPhoneNumber = petrolPumpPhoneNumber;

      var uuid = Uuid();
      String uniqueID = uuid.v1();

      // try {
      //   databaseReference.child("masters").child("petrolMaster").update({
      //     '$uniqueID',
      //   });
      //   showToast("Added successfully");
      // } catch (e) {
      //   showToast("Failed. Check your Internet");
      // }

      try {
        await databaseReference
            .child("masters")
            .child("petrolMaster")
            .child(uniqueID)
            .set({
          'petrolPumpName': petrolPumpName,
          'petrolPumpAddress': petrolPumpAddress,
          'petrolPumpAddress': petrolPumpAddress,
          'petrolPumpDistrict': petrolPumpDistrict,
          'petrolPumpTown': petrolPumpTown,
          'petrolPumpID': uniqueID,
          'petrolPumpPinCode': petrolPumpPinCode,
          'petrolPumpPhoneNumber': petrolPumpPhoneNumber,
        });
        showToast("Added successfully");
        Navigator.of(context).pop();
      } catch (e) {
        showToast("Failed. Check your Internet");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ThemeAppbar("Add a petrol pump", context),
        body: Center(
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
                    titleStyles('Add Petrol Pump', 20),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      minLines: 1,
                      validator: (String content) {
                        if (content.length == 0) {
                          return "Please enter petrol pump name";
                        } else {
                          return null;
                        }
                      },
                      controller: petrolPumpNameController,
                      decoration: InputDecoration(
                        labelText: "Petrol Pump Name",
                        border: OutlineInputBorder(),
                        //hintText: "Enter Petrol Pump Name",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      minLines: 1,
                      maxLines: 6,
                      validator: (String content) {
                        if (content.length == 0) {
                          return "Please enter petrol pump address";
                        } else {
                          return null;
                        }
                      },
                      controller: petrolPumpAddressController,
                      decoration: InputDecoration(
                        labelText: "Petrol Pump Address",
                        border: OutlineInputBorder(),
                        //hintText: "Enter Petrol Pump Address",
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            minLines: 1,
                            validator: (String content) {
                              if (content.length == 0) {
                                return "please enter petrol pump district";
                              } else {
                                return null;
                              }
                            },
                            controller: petrolPumpDistrictController,
                            decoration: InputDecoration(
                              labelText: "District",
                              border: OutlineInputBorder(),
                              //hintText: "Enter Petrol Pump District",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
                            minLines: 1,
                            validator: (String content) {
                              if (content.length == 0) {
                                return "Town";
                              } else {
                                return null;
                              }
                            },
                            controller: petrolPumpTownController,
                            decoration: InputDecoration(
                              labelText: "Town",
                              border: OutlineInputBorder(),
                              //hintText: "Enter Petrol Pump Town",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: TextFormField(
                            minLines: 1,
                            validator: (String content) {
                              if (content.length == 0) {
                                return "Please enter pin code";
                              } else {
                                return null;
                              }
                            },
                            controller: petrolPumpPinCodeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Pin Code",
                              border: OutlineInputBorder(),
                              //hintText: "Enter Petrol Pump Pin Code",
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextFormField(
                            minLines: 1,
                            validator: (val) {
                              if (val.isEmpty) return 'Enter phone number';
                              if (val.length < 10 || val.length > 10)
                                return 'Enter a valid phone number';
                              else
                                return null;
                            },
                            controller: petrolPumpPhoneNumberController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "Contact",
                              border: OutlineInputBorder(),
                              //hintText: "Enter Contact",
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: FlatButton(
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
                                "Add ",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17),
                              )),
                            ),
                            onPressed: () {
                              addPetrolPump();
                            },
                          ),
                        ),

//                    Flexible(
//                    child :FlatButton(
//                      child: Container(
//                        height: 45,
//                        width: 120,
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                            gradient: gradients() //Gradient
//                        ),
//                        child: Padding(
//                          padding: const EdgeInsets.only(top: 9,left: 13),
//                          child: Text(
//                            'Our Projects',
//                            style: TextStyle(
//                                color: Colors.white,
//                                fontWeight: FontWeight.bold
//                            ),
//                          ),
//                        ),
//                      ),
//                      onPressed: () {},
//                    ),
//                    ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
