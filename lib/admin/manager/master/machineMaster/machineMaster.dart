//This page is under manager section

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../../CommonWidgets.dart';
import 'EditMachineData.dart';
import 'addNewMachine.dart';

class MachineMaster extends StatefulWidget {
  @override
  _MachineMasterState createState() => _MachineMasterState();
}

class _MachineMasterState extends State<MachineMaster> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List allMachines = List();

  String uid = "8YiMHLBnBaNjmr3yPvk8NWvNPmm2";

  @override
  void initState() {
    super.initState();
  }

  Widget displayProject(int index) {
    return Container(

        // height: MediaQuery.of(context).size.height/5.5,

        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditMachineData(
                          machineDetails: allMachines[index],
                        )),
              );
            },
            child: Card(
                elevation: 4,
                margin: EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 7),
                semanticContainer: true,
                color: Colors.amberAccent.shade50,
                child: Container(
                    decoration: BoxDecoration(
                      gradient: cards(),
                    ),
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
                                    Text(
                                      "Machine Name: " +
                                          allMachines[index]["machineName"],
                                      overflow: TextOverflow.clip,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic),
                                    ),
                                    Text(
                                      "Model: " +
                                          allMachines[index]["modelName"],
                                      overflow: TextOverflow.clip,
                                      maxLines: 1,
                                      softWrap: false,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Operating Weight: " +
                                          allMachines[index]
                                              ["operatingWeight"] +
                                          " kg",
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "Engine Power: " +
                                          allMachines[index]["enginePower"] +
                                          " rpm",
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          "Fuel Consumption: " +
                                              allMachines[index]
                                                      ["fuelConsumption"]
                                                  .toString() +
                                              " litre/hr",
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          softWrap: false,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Rent" +
                                              ": " +
                                              allMachines[index]
                                                  ["machineRent"] +
                                              " Rs/hr",
                                          overflow: TextOverflow.clip,
                                          maxLines: 2,
                                          softWrap: false,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        )
                      ],
                    )))));
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
//
//              debugPrint("this is map"+data.toString());

              data.forEach(
                (index, data) => allMachines.add({"key": index, ...data}),
              );

//              debugPrint("allMachine list"+allMachines.toString());
//
//              debugPrint("list without key"+data.values.toList().toString());
//              debugPrint("list of keys"+data.keys.toList().toString());

//
//              for(int i=0;i<allMachines.length;i++)
//                {
//                  debugPrint("machine $i name"+allMachines[i]["machineName"]);
//                  debugPrint("machine $i name"+allMachines[i]["machineID"]);
//                }

              return new Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                  child: titleStyles('Our Machines', 18),
                  ),
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
            } else if (!snap.hasData ||
                snap.hasError ||
                snap.data.snapshot.value == null) {
              return Center(
                child: Text("No Data Found"),
              );
            } else{
              return Center(
                  child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ));
            }
          }),
      floatingActionButton: floats(context, AddNewMachine()),
    );
  }
}
