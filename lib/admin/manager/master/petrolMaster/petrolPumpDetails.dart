import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../CommonWidgets.dart';
import 'EditPetrolPump.dart';
import 'package:project_timeline/languages/setLanguageText.dart';


class PetrolPumpDetails extends StatefulWidget {
  Map data;
  int indexes;
  PetrolPumpDetails({Key key, this.data, this.indexes}) : super(key: key);

  @override
  _PetrolPumpDetailsState createState() => _PetrolPumpDetailsState();
}

class _PetrolPumpDetailsState extends State<PetrolPumpDetails> {
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();
  Map data;
  int indexes;
  @override
  void initState() {
    setState(() {
      data = widget.data;
      indexes = widget.indexes;
    });

  }

  deletePetrolPump(keyNode) async {
    try {
      await databaseReference
          .child("masters")
          .child("petrolMaster")
          .child(keyNode)
          .remove();
      await Navigator.of(context).pop();
      showToast("Deleted Successfully");
    } catch (e) {
      debugPrint("This is the error " + e.toString());
      showToast("Failed. check your internet!");
    }
  }

  editPetrolPump(Map data) async {
    await Navigator.of(context).pop();
    showDialog(
      context: context,
      builder: (_) => EditPetrolPump(
        data: data,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 1.7,
        padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  Center(
                  child: titleStyles(petrolPumpDataPage[6] + ':', 18),
                  ),
                  Text(petrolPumpDataPage[0] + ": "),
                  Text(widget.data["petrolPumpName"].toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(petrolPumpDataPage[1] + ":"),
                  Text(widget.data["petrolPumpAddress"].toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(petrolPumpDataPage[2] + ": "),
                  Text(widget.data["petrolPumpPhoneNumber"].toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(petrolPumpDataPage[3] + ": "),
                  Text(widget.data["petrolPumpDistrict"].toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(petrolPumpDataPage[4] + ":"),
                  Text(widget.data["petrolPumpTown"].toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(petrolPumpDataPage[5] + ":"),
                  Text(widget.data["petrolPumpPinCode"].toString()),
                  SizedBox(
                    height: 20,
                  ),

                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
