import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/languages/setLanguageText.dart';

import '../../CommonWidgets.dart';

class WorkerRequestList extends StatefulWidget {
  @override
  _WorkerRequestListState createState() => _WorkerRequestListState();
}

class _WorkerRequestListState extends State<WorkerRequestList> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final CollectionReference workers =
      FirebaseFirestore.instance.collection("workers");
  final CollectionReference user =
      FirebaseFirestore.instance.collection("user");
  FirebaseAuth auth = FirebaseAuth.instance;
  List allWorkerRequest = List();

  acceptRequest(worker) async {
    try {
      if (worker["signInMethod"] != "email") {
        await user.doc(worker["key"]).delete();
        await workers.doc(worker["key"]).set({
          "assignedProject": "No project assigned",
          "mobile": worker["phoneNo"],
          "name": worker["name"],
          "age": worker["age"],
          "address": worker["address"],
          "uid": worker["key"],
          'signInMethod': worker["signInMethod"]
        }).then((value) async {
          await databaseReference
              .child("request")
              .child("worker")
              .child(worker["key"])
              .remove();
        }).then((value) {
          showToast("Added successfully");
        });
      } else {
        await user.doc(worker["key"]).delete();
        await workers.doc(worker["key"]).set({
          "assignedProject": "No project assigned",
          "email": worker["email"],
          "password": worker["password"],
          "age": worker["age"],
          "address": worker["address"],
          "mobile": worker["phoneNo"],
          "name": worker["name"],
          "uid": worker["key"],
          'signInMethod': worker["signInMethod"]
        }).then((value) async {
          await databaseReference
              .child("request")
              .child("worker")
              .child(worker["key"])
              .remove();
        }).then((value) {
          showToast("Added successfully");
        });
      }

      // print(worker["key"]);
      // print(worker["email"]);
      // print(worker["password"]);
      // await FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(
      //         email: worker["email"], password: worker["password"])
      //     .then((AuthResult result) async {
      //   await workers.doc(result.user.uid).set({
      //     "assignedProject": "No project assigned",
      //     "email": worker["email"],
      //     "mobile": worker["phoneNo"],
      //     "name": worker["name"],
      //     "uid": result.user.uid
      //   }).then((value) async {
      //     await databaseReference
      //         .child("request")
      //         .child("worker")
      //         .child(worker["key"])
      //         .remove();
      //   });
      // }).then((value) {
      //   showToast("Added successfully");
      // });
    } catch (e) {
      print(e.toString());
    }
  }

  declineRequest(worker) async {
    await databaseReference
        .child("request")
        .child("worker")
        .child(worker["key"])
        .remove()
        .then((value) {
      showToast(superText3[2]);
    });
  }

  Widget displayWorkerRequest(int index, data) {
    return Container(
      child: Card(
        elevation: 4,
        margin: EdgeInsets.only(left: 5, right: 5, top: 7, bottom: 7),
        semanticContainer: true,
        color: Colors.amberAccent.shade50,
        child: Container(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                      width: MediaQuery.of(context).size.width / 1.4,
                      padding: EdgeInsets.all(5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            superText3[3] + allWorkerRequest[index]["name"],
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
                          if (allWorkerRequest[index]["email"] != null)
                            Text(
                              superText3[4] + allWorkerRequest[index]["email"],
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                              softWrap: false,
                              style: TextStyle(fontSize: 14),
                            ),
                          if (allWorkerRequest[index]["signInMethod"] !=
                              "email")
                            Text(
                              superText3[5],
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                              softWrap: false,
                              style: TextStyle(fontSize: 14),
                            ),
                          Text(
                            superText3[6] + allWorkerRequest[index]["address"],
                            overflow: TextOverflow.clip,
                            maxLines: 2,
                            softWrap: false,
                            style: TextStyle(fontSize: 14),
                          ),
                          Row(
                            children: <Widget>[
                              Text(
                                superText3[7] + allWorkerRequest[index]["age"],
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                softWrap: false,
                                style: TextStyle(fontSize: 14),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                superText3[8] +
                                    allWorkerRequest[index]["phoneNo"],
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                softWrap: false,
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          )
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.only(top: 5),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          FlatButton(
                            color: Color.fromRGBO(204, 255, 153, 1),
                            child: Text(superText3[9]),
                            onPressed: () {
                              setState(() {
                                acceptRequest(allWorkerRequest[index]);
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          FlatButton(
                            color: Color.fromRGBO(244, 137, 137, 1),
                            child: Text(superText3[10]),
                            onPressed: () {
                              setState(() {
                                declineRequest(allWorkerRequest[index]);
                              });
                            },
                          ),
                        ],
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ThemeAppbar("Worker Request List"),
      body: StreamBuilder(
        stream: databaseReference.child("request").child("worker").onValue,
        builder: (context, snap) {
          if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value != null) {
            Map data = snap.data.snapshot.value;
            allWorkerRequest = [];

            data.forEach(
              (index, data) => allWorkerRequest.add({"key": index, ...data}),
            );

            // debugPrint(data.toString());
            return new Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: titleStyles(superText3[11], 18),
                ),
                SizedBox(
                  height: 20,
                ),
                // Text(data.toString()),
                new Expanded(
                  child: new ListView.builder(
                    itemCount: allWorkerRequest.length,
                    itemBuilder: (context, index) {
                      return displayWorkerRequest(index, allWorkerRequest);
                    },
                  ),
                ),
              ],
            );
          } else if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value == null) {
            return Center(
              child: Text(superText3[12]),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            );
          }
        },
      ),
    );
  }
}
