import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/CommonWidgets.dart';

class WorkerRequestList extends StatefulWidget {
  @override
  _WorkerRequestListState createState() => _WorkerRequestListState();
}

class _WorkerRequestListState extends State<WorkerRequestList> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List allWorkerRequest = List();

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
                              onPressed: () {},
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            FlatButton(
                              color: Color.fromRGBO(244, 137, 137, 1),
                              child: Text("Decline"),
                              onPressed: () {},
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
                  child: Text('Worker Request List',
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
