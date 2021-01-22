import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/multilingual/dynamic_translation.dart';
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

 List translatedText=["","","","","","",""];

  @override
  void initState() {
  
    loadTranslatedText();
  }

  loadTranslatedText() async {
   translatedText= await DynamicTranslation().listTranslate(
                        data: [
                          widget.data["petrolPumpName"],
                           widget.data["petrolPumpAddress"],
                           widget.data["petrolPumpPhoneNumber"],      
                            widget.data["petrolPumpDistrict"], 
                            widget.data["petrolPumpTown"],
                            widget.data["petrolPumpPinCode"]
                        ]);
                        setState(() {
                          
                        });
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
                  Text(translatedText[0]??widget.data["petrolPumpName"].toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(petrolPumpDataPage[1] + ":"),
                  Text(translatedText[1]??widget.data["petrolPumpAddress"].toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(petrolPumpDataPage[2] + ": "),
                  Text(translatedText[2]??widget.data["petrolPumpPhoneNumber"].toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(petrolPumpDataPage[3] + ": "),
                  Text(translatedText[3]??widget.data["petrolPumpDistrict"].toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(petrolPumpDataPage[4] + ":"),
                  Text(translatedText[4]??widget.data["petrolPumpTown"].toString()),
                  SizedBox(
                    height: 20,
                  ),
                  Text(petrolPumpDataPage[5] + ":"),
                  Text(translatedText[5]??widget.data["petrolPumpPinCode"].toString()),
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
