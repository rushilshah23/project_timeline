import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/CommonWidgets.dart';

class SupervisorRequestList extends StatefulWidget {
  @override
  _SupervisorRequestListState createState() => _SupervisorRequestListState();
}

class _SupervisorRequestListState extends State<SupervisorRequestList> {
  final databaseReference = FirebaseDatabase.instance.reference();
  final CollectionReference workers =
      Firestore.instance.collection("supervisor");
  final CollectionReference user = Firestore.instance.collection("user");
  FirebaseAuth auth = FirebaseAuth.instance;
  List allWorkerRequest = List();

  acceptRequest(worker) async {
    try {
      if (worker["signInMethod"] != "email") {
        await user.document(worker["key"]).delete();
        await workers.document(worker["key"]).setData({
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
              .child("supervisor")
              .child(worker["key"])
              .remove();
        }).then((value) {
          showToast("Added successfully");
        });
      } else {
        await user.document(worker["key"]).delete();
        await workers.document(worker["key"]).setData({
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
              .child("supervisor")
              .child(worker["key"])
              .remove();
        }).then((value) {
          showToast("Added successfully");
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  declineRequest(worker) async {
    await databaseReference
        .child("request")
        .child("supervisor")
        .child(worker["key"])
        .remove()
        .then((value) {
      showToast("Declined successfully");
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
                              "Name: " + allWorkerRequest[index]["name"],
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
                                "Email :" + allWorkerRequest[index]["email"],
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                softWrap: false,
                                style: TextStyle(fontSize: 14),
                              ),
                            if (allWorkerRequest[index]["signInMethod"] != null)
                              Text(
                                "Sign In method : OTP",
                                overflow: TextOverflow.clip,
                                maxLines: 2,
                                softWrap: false,
                                style: TextStyle(fontSize: 14),
                              ),
                            Text(
                              "Address: " + allWorkerRequest[index]["address"],
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                              softWrap: false,
                              style: TextStyle(fontSize: 14),
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Age: " + allWorkerRequest[index]["age"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Phone no: " +
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
                              child: Text("Accept"),
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
                              child: Text("Decline"),
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
            ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: ThemeAppbar("Supervisor Request List"),
      body: StreamBuilder(
        stream: databaseReference.child("request").child("supervisor").onValue,
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
                  child: titleStyles('Supervisor Request List', 18),
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
              child: Text("No request found"),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
            ));
          }
        },
      ),
    );
  }
}
