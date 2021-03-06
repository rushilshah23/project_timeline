import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../../../CommonWidgets.dart';
import 'AddPetrolLocation.dart';
import 'EditPetrolPump.dart';
import 'petrolPumpDetails.dart';


class PetrolMaster extends StatefulWidget {
  @override
  _PetrolMasterState createState() => _PetrolMasterState();
}

class _PetrolMasterState extends State<PetrolMaster> {
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

        child: Card(
            elevation: 4,
            margin: EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 7),
            semanticContainer: true,
            color: Colors.amberAccent.shade50,
            child: Container(
              decoration: BoxDecoration(
                gradient: cards()
              ),
                child: Column(
              children: <Widget>[


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      padding: EdgeInsets.only(top: 30,bottom: 30,left: 10,right: 10),
                      //padding: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Name " +
                                allPetrolPump[index]["petrolPumpName"]
                                    .toString(),
                            overflow: TextOverflow.clip,
                            maxLines: 1,
                            softWrap: false,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                //fontStyle: FontStyle.italic
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Address" +
                                ": "
                                    .toString(),
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            softWrap: false,
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                          ),
                          Text(
                                allPetrolPump[index]["petrolPumpAddress"]
                                    .toString(),
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            softWrap: false,
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Phone No." +
                                ": " +
                                allPetrolPump[index]["petrolPumpPhoneNumber"],
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            softWrap: false,
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 5),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              color: Colors.grey,
                              onPressed: () {
                                // debugPrint(allPetrolPumpData[index]["key"].toString());

                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditPetrolPump(
                                    data: allPetrolPumpData[index],
                                  ),),
                                  );
                                // showDialog(
                                //   context: context,
                                //   builder: (_) => EditPetrolPump(
                                //     data: allPetrolPumpData[index],
                                //   ),
                                // );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              color: Colors.grey,
                              onPressed: () {

                               
                                showDialog(
                                  context: context,
                                  builder: (_) => PetrolPumpDetails(
                                    data: allPetrolPumpData[index],
                                  ),
                                );

                                
                              },
                            ),
//                            IconButton(
//                              icon: Icon(Icons.delete),
//                              color: Colors.grey,
//                              onPressed: () {
//                                deletePetrolPump(
//                                  allPetrolPumpData[index]["key"],
//                                );
//                              },
//                            ),
                          ],
                        ))
                  ],
                )
              ],
            ))));
    // return Container(
    //   padding: EdgeInsets.only(top: 10),
    //   child: Column(
    //     children: [
    //       ListTile(
    //         contentPadding: EdgeInsets.all(10),
    //         title: Text(allPetrolPump[index]["petrolPumpName"].toString()),
    //         subtitle:
    //             Text(allPetrolPump[index]["petrolPumpAddress"].toString()),
    //         onTap: () {
    //           debugPrint("test" + data.toString());
    //           return showDialog(
    //             context: context,
    //             builder: (_) => PetrolPumpDetails(
    //               data: data[index],
    //               indexes: index,
    //             ),
    //           );
    //         },
    //       ),
    //     ],
    //   ),
    // );
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
                  SizedBox(height: 10,),
                  Center(
                  child: titleStyles('Our Diesel Stations', 18),
                  ),

                  SizedBox(height: 20,),

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
      floatingActionButton: floats(context,AddPetrolLocation()),
      /*FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => AddPetrolLocation(),
          );
        },
        child: Container(
            child: Icon(Icons.add)),
      ),*/
    );
  }
}
