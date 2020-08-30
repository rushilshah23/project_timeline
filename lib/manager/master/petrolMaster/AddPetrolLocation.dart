import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/CommonWidgets.dart';
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
          'petrolPumpID':uniqueID,
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
    return Center(
        child: Material(
            child: Container(
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.width / 1.2,
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      padding: EdgeInsets.only(top: 20,right: 20,left: 20),


      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Column(

              children: <Widget>[
                Text(
                  "Add Petrol Pump",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  minLines: 1,
                  validator: (String content) {
                    if (content.length == 0) {
                      return "Please Enter Petrol Pump Name";
                    } else {
                      return null;
                    }
                  },
                  controller: petrolPumpNameController,
                  decoration: InputDecoration(
                    labelText: "Petrol Pump Name",
                    border: OutlineInputBorder(),
                    hintText: "Enter Petrol Pump Name",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  minLines: 1,
                  maxLines: 3,
                  validator: (String content) {
                    if (content.length == 0) {
                      return "Please Enter Petrol Pump Address";
                    } else {
                      return null;
                    }
                  },
                  controller: petrolPumpAddressController,
                  decoration: InputDecoration(
                    labelText: "Petrol Pump Address",
                    border: OutlineInputBorder(),
                    hintText: "Enter Petrol Pump Address",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),

                Row(
                  children: [
                    Flexible(
                      child:  TextFormField(
                        minLines: 1,
                        validator: (String content) {
                          if (content.length == 0) {
                            return "Please Enter Petrol Pump District";
                          } else {
                            return null;
                          }
                        },
                        controller: petrolPumpDistrictController,
                        decoration: InputDecoration(
                          labelText: "District",
                          border: OutlineInputBorder(),
                          hintText: "Enter Petrol Pump District",
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 10,
                    ),

                    Flexible(
                      child:  TextFormField(
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
                          hintText: "Enter Petrol Pump Town",
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
                      child:     TextFormField(
                        minLines: 1,
                        validator: (String content) {
                          if (content.length == 0) {
                            return "Please Enter Pin Code";
                          } else {
                            return null;
                          }
                        },
                        controller: petrolPumpPinCodeController,
                        decoration: InputDecoration(
                          labelText: "Pin Code",
                          border: OutlineInputBorder(),
                          hintText: "Enter Petrol Pump Pin Code",
                        ),
                      ),
                    ),

                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child:    TextFormField(
                        minLines: 1,
                        validator: (String content) {
                          if (content.length == 0) {
                            return "Please Enter Petrol Pump Phone Number";
                          } else {
                            return null;
                          }
                        },
                        controller: petrolPumpPhoneNumberController,
                        decoration: InputDecoration(
                          labelText: "Contact",
                          border: OutlineInputBorder(),
                          hintText: "Enter Contact",
                        ),
                      ),
                    ),


                  ],
                ),



                SizedBox(
                  height: 20,
                ),
                RaisedButton(
                  child: Text("Add Petrol Pump"),
                  onPressed: () {
                    addPetrolPump();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    )));
  }
}
