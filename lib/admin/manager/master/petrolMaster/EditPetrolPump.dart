import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';

import 'petrolMaster.dart';

class EditPetrolPump extends StatefulWidget {
  Map data;
  EditPetrolPump({Key key, this.data}) : super(key: key);

  @override
  _EditPetrolPumpState createState() => _EditPetrolPumpState();
}

class _EditPetrolPumpState extends State<EditPetrolPump> {
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();

  String petrolPumpName,
      petrolPumpAddress,
      petrolPumpPhoneNumber,
      petrolPumpDistrict,
      petrolPumpTown,
      petrolPumpPinCode;
  TextEditingController petrolPumpNameController = TextEditingController();
  TextEditingController petrolPumpAddressController = TextEditingController();
  TextEditingController petrolPumpPhoneNumberController =
      TextEditingController();
  TextEditingController petrolPumpDistrictController = TextEditingController();
  TextEditingController petrolPumpTownController = TextEditingController();
  TextEditingController petrolPumpPinCodeController = TextEditingController();

  @override
  void initState() {
    debugPrint(" this is in edit page " + widget.data.toString());
    setState(() {
      petrolPumpNameController.text = widget.data["petrolPumpName"].toString();
      petrolPumpAddressController.text =
          widget.data["petrolPumpAddress"].toString();
      petrolPumpPhoneNumberController.text =
          widget.data["petrolPumpPhoneNumber"].toString();
      petrolPumpDistrictController.text =
          widget.data["petrolPumpDistrict"].toString();
      petrolPumpTownController.text = widget.data["petrolPumpTown"].toString();
      petrolPumpPinCodeController.text =
          widget.data["petrolPumpPinCode"].toString();
    });
  }


  deletePetrolPump(keyNode) async {
    try {
      await databaseReference
          .child("masters")
          .child("petrolMaster")
          .child(keyNode)
          .remove();
      showToast("Deleted Successfully");

     Navigator.of(context).pop();

    } catch (e) {
      debugPrint("This is the error " + e.toString());
      showToast("Failed. check your internet!");
    }
  }

  updatePetrolPump() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        petrolPumpName = petrolPumpNameController.text;
        petrolPumpAddress = petrolPumpAddressController.text;
        petrolPumpPhoneNumber = petrolPumpPhoneNumberController.text;
        petrolPumpDistrict = petrolPumpDistrictController.text;
        petrolPumpTown = petrolPumpTownController.text;
        petrolPumpPinCode = petrolPumpPinCodeController.text;
      });

      try {
        await databaseReference
            .child("masters")
            .child("petrolMaster")
            .child(widget.data["key"])
            .update({
          "petrolPumpName": petrolPumpName,
          "petrolPumpAddress": petrolPumpAddress,
          "petrolPumpPhoneNumber": petrolPumpPhoneNumber,
          "petrolPumpDistrict": petrolPumpDistrict,
          "petrolPumpTown": petrolPumpTown,
          "petrolPumpPinCode": petrolPumpPinCode,
        });
        await showToast("Edited \nSuccessfully");
        Navigator.of(context).pop();
      } catch (e) {
        showToast("Failed. check your internet!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppbar("Edit Details", context),
            body: Center(child: Container(
      
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      padding: EdgeInsets.all(20),

      child: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                titleStyles('Edit Details', 18),
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
                    //hintText: "Enter Petrol Pump Name",
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
                            return "Enter District";
                          } else {
                            return null;
                          }
                        },
                        controller: petrolPumpDistrictController,
                        decoration: InputDecoration(
                          labelText: "District",
                          border: OutlineInputBorder(),

                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
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
                      child:  TextFormField(
                        minLines: 1,
                        validator: (String content) {
                          if (content.length == 0) {
                            return " Enter Pin Code";
                          } else {
                            return null;
                          }
                        },
                        controller: petrolPumpPinCodeController,
                        decoration: InputDecoration(
                          labelText: "Pin Code",
                          border: OutlineInputBorder(),

                        ),
                      ),
                    ),
                    SizedBox(width: 10,),
                    Flexible(
                      child: TextFormField(
                        minLines: 1,
                        validator: (String content) {
                          if (content.length == 0) {
                            return "Enter Phone No";
                          } else {
                            return null;
                          }
                        },
                        controller: petrolPumpPhoneNumberController,
                        decoration: InputDecoration(
                          labelText: "Contact No.",
                          border: OutlineInputBorder(),

                        ),
                      ),
                    ),

                  ],
                ),

                SizedBox(
                  height: 20,
                ),




                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [

                    FlatButton(
                      child: buttonContainers(100, 'Save', 17),
                      onPressed: () {
                        updatePetrolPump();
                        // debugPrint(widget.data["key"].toString());
                      },
                    ),

                    FlatButton(
                      child: buttonContainers(100, 'Delete', 17),
                        onPressed: () {
                          updatePetrolPump();
                          // debugPrint(widget.data["key"].toString());

                          deletePetrolPump(
                            widget.data["petrolPumpID"],
                          );
                        },
                      ),

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
