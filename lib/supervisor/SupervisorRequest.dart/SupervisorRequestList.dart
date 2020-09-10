import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/CommonWidgets.dart';

class SupervisorRequestList extends StatefulWidget {
  @override
  _SupervisorRequestListState createState() => _SupervisorRequestListState();
}

class _SupervisorRequestListState extends State<SupervisorRequestList> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List allWorkerRequest = List();

  Widget displayWorkerRequest(int index, data) {
    return Container(
        child: Card(
            elevation: 4,
            margin: EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 7),
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
                            Text(
                              "Email :" + allWorkerRequest[index]["email"],
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
                    // Container(
                    //     margin: EdgeInsets.only(top: 5),
                    //     child: Column(
                    //       children: <Widget>[
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         IconButton(
                    //           icon: Icon(Icons.edit),
                    //           color: Colors.grey,
                    //           onPressed: () {},
                    //         ),
                    //         IconButton(
                    //           icon: Icon(Icons.delete),
                    //           color: Colors.grey,
                    //           onPressed: () {},
                    //         ),
                    //         IconButton(
                    //           icon: Icon(Icons.add_box),
                    //           color: Colors.grey,
                    //           onPressed: () {
                    //             // Navigator.push(
                    //             //   context,
                    //             //   MaterialPageRoute(
                    //             //       builder: (context) => YourCreatedTasks(
                    //             //             projectID: myCreatedProjects[index]
                    //             //                 ["projectID"],
                    //             //           )),
                    //             // );
                    //           },
                    //         ),
                    //       ],
                    //     ))
                  ],
                )
              ],
            ))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppbar("Supervisor Request List"),
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
                  child: Text('Supervisor Request List',
                      style: titlestyles(18, Colors.orange)),
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
