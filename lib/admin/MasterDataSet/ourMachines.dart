//This page is under manager section

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/multilingual/dynamic_translation.dart';
import '../CommonWidgets.dart';
import 'ourMachinesDetailsDisplay.dart';
import 'package:project_timeline/languages/setLanguageText.dart';
class OurMachines extends StatefulWidget {
  @override
  _OurMachinesState createState() => _OurMachinesState();
}

class _OurMachinesState extends State<OurMachines> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List allMachines = List();

  String uid = "8YiMHLBnBaNjmr3yPvk8NWvNPmm2";


  Widget displayProject(int index) {

             
    return Container(
        child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => OurMachinesDetailsDisplay(
                    data: allMachines, indexes: index),
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
                          allMachines[index]["machineName"],
                       allMachines[index]["modelName"],
                        
                        ]),
                    builder: (context, snapshot) {
                      if(snapshot.hasData){
                 return Container(
                    padding: EdgeInsets.only(
                        top: 20, bottom: 20, left: 10, right: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                    width: MediaQuery.of(context).size.width / 1.4,
                                    child:Text(
                                      machinesDataPage[0] +":   "+
                                        snapshot.data[0]??  allMachines[index]["machineName"],
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 15,
                                        //fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w900
                                      ),
                                    )),
                                    Text(
                                      machinesDataPage[2] +":   "+
                                         snapshot.data[1]??  allMachines[index]["modelName"],
                                      overflow: TextOverflow.clip,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(
                                        fontSize: 14,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      machinesDataPage[6] +":   "+
                                          allMachines[index]
                                              ["operatingWeight"] +
                                          " kg",
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      softWrap: true,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Text(
                                      machinesDataPage[8]+":   "+
                                          allMachines[index]["enginePower"] +
                                          " rpm",
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    
                                        Text(
                                          machinesDataPage[5] +":   "+
                                              allMachines[index]
                                                      ["fuelConsumption"]
                                                  .toString() +
                                              " litre/hr",
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          softWrap: false,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          machinesDataPage[2]+
                                              ":   " +
                                              allMachines[index]
                                                  ["machineRent"] +
                                              " Rs/hr",
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          softWrap: false,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                   
                                )),
                          ],
                        )
                      ],
                    ));
                    
                    }
                      else return Container(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child:Center(child: CircularProgressIndicator(),));
                    })))
                    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
//      appBar: AppBar(
//
//        title: Text("Machine Master"),
//      ),

      body: StreamBuilder(
          stream:
              databaseReference.child("masters").child("machineMaster").onValue,
          builder: (context, snap) {
            if (snap.hasData &&
                !snap.hasError &&
                snap.data.snapshot.value != null) {
              Map data = snap.data.snapshot.value;
              allMachines = [];
              data.forEach(
                (index, data) => allMachines.add({"key": index, ...data}),
              );

              return new Column(
                children: <Widget>[
                  // SizedBox(
                  //   height: 10,
                  // ),
//                   Center(
// //                    child: Text('Our Machines',
// //                        style: titlestyles(18, Colors.orange)),
//                   child: titleStyles('Our Machines', 18),
//                   ),
                  SizedBox(
                    height: 20,
                  ),
                  new Expanded(
                    child: new ListView.builder(
                      itemCount: allMachines.length,
                      itemBuilder: (context, index) {
                        return displayProject(index);
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
