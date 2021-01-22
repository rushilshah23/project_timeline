import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/admin/manager/master/petrolMaster/petrolPumpDetails.dart';
import 'package:project_timeline/multilingual/dynamic_translation.dart';
import '../CommonWidgets.dart';

import 'package:project_timeline/languages/setLanguageText.dart';

class OurPetrolPumps extends StatefulWidget {
  @override
  _OurPetrolPumpsState createState() => _OurPetrolPumpsState();
}

class _OurPetrolPumpsState extends State<OurPetrolPumps> {
  final databaseReference = FirebaseDatabase.instance.reference();
  Map petrolPumpData;
  List allPetrolPump = List();

  @override
  void initState() {
    super.initState();
    getPetrolPumpDetails();
  }

  getPetrolPumpDetails() async {
    databaseReference.child("masters").once().then((DataSnapshot snapshot) {
      Map petrolPumpLocations = snapshot.value["petrolMaster"];
      setState(() {
        petrolPumpData = petrolPumpLocations;
      });
      debugPrint(petrolPumpData.toString());
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
    } catch (e) {
      debugPrint("This is the error " + e.toString());
      showToast("Failed. check your internet!");
    }
  }

  Widget petrolMaster(int index, allPetrolPumpData) {

   
    return Container(
        child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => PetrolPumpDetails(
                  data: allPetrolPumpData[index],
                ),
              );
            },
            child: Card(
                elevation: 4,
                margin: EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 7),
                semanticContainer: true,
                color: Colors.amberAccent.shade50,
                child:
                  FutureBuilder(
                    future: DynamicTranslation().listTranslate(
                        data: [
                         allPetrolPump[index]["petrolPumpName"],
                        allPetrolPump[index]["petrolPumpAddress"],
                        allPetrolPump[index]["petrolPumpPhoneNumber"],
                        ]),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                
                return Container(

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                   
                        Container(
                          //width: MediaQuery.of(context).size.width / 1.4,
                          padding: EdgeInsets.only(left: 15,
                              top: 30, bottom: 30),
                          //padding: EdgeInsets.all(5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                petrolPumpDataPage[0] +":   "+
                                   snapshot.data[0]?? allPetrolPump[index]["petrolPumpName"]
                                        .toString(),
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                softWrap: false,
                                style: TextStyle(
                                    fontSize: 14,
                                    //fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w900),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                petrolPumpDataPage[1] +":   "+
                                   snapshot.data[1]??  allPetrolPump[index]["petrolPumpAddress"]
                                        .toString(),
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                softWrap: false,
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                petrolPumpDataPage[2] +":   "+
                                   snapshot.data[2]?? allPetrolPump[index]
                                        ["petrolPumpPhoneNumber"],
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                softWrap: false,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                   
                  ],
                ));}
                  else return Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child:Center(child: CircularProgressIndicator(),));
                })
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text('Petrol Locations'),
//      ),
      body: StreamBuilder(
          stream:
              databaseReference.child("masters").child("petrolMaster").onValue,
          builder: (context, snap) {
            if (snap.hasData &&
                !snap.hasError &&
                snap.data.snapshot.value != null) {
              Map data = snap.data.snapshot.value;
              allPetrolPump = [];
              data.forEach(
                (index, data) => allPetrolPump.add({"key": index, ...data}),
              );

              return new Column(
                children: <Widget>[
                  // SizedBox(
                  //   height: 10,
                  // ),
//                   Center(
// //                    child: Text('Our Diesel Stations',
// //                        style: titlestyles(18, Colors.orange)),
//                     child: titleStyles('Our Diesel Stations', 18),
//                   ),
                  SizedBox(
                    height: 20,
                  ),
                  new Expanded(
                    child: new ListView.builder(
                      itemCount: allPetrolPump.length,
                      itemBuilder: (context, index) {
                        return petrolMaster(index, allPetrolPump);
                      },
                    ),
                  ),
                ],
              );
            } else if (snap.hasData &&
                !snap.hasError &&
                snap.data.snapshot.value == null) {
              return Center(
                child: Text("No data found"),
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ));
            }
          }),
    );
  }
}
