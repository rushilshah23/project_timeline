//This page is under manager section

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../CommonWidgets.dart';
import 'addWorkers.dart';
import 'approveWork/WorkApproveModTabs.dart';
import 'approveWork/WorkApproveModule.dart';




class YourAllocatedProjects extends StatefulWidget {
  @override
  _YourAllocatedProjectsState createState() => _YourAllocatedProjectsState();
}

class _YourAllocatedProjectsState extends State<YourAllocatedProjects> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List ourCreatedProjects = List();
  List allProjects = List();
  String projectID="b570da70-fa93-11ea-9561-89a3a74b28bb";


  @override
  void initState() {
    super.initState();
  }

  Widget displayProject(int index) {
    return Container(
        child: Card(
            elevation: 4,
            margin: EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 7),
            semanticContainer: true,
            color: Colors.amberAccent.shade50,
            child: Container(
              padding: EdgeInsets.all(15),
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
                                Text(
                                  "Project: " +
                                      ourCreatedProjects[index]["projectName"],
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
                                  "Site Address: " +
                                      ourCreatedProjects[index]["siteAddress"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "Supervisor Name" +
                                      ": " +
                                      "Shraddha.V.Pawar",
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Progress" +
                                          ": " +
                                          "20%",
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      "Status" +
                                          ": " +
                                          "On Going",
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                              ],
                            )),
                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                  icon: Icon(Icons.update),
                                  color: Colors.grey,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WorkApproveModTabs()),
                                    );
                                  },
                                ),
//                                IconButton(
//                                  icon: Icon(Icons.delete),
//                                  color: Colors.grey,
//                                  onPressed: () {},
//                                ),
                                IconButton(
                                  icon: Icon(Icons.add_box),
                                  color: Colors.grey,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SearchWorkerPage()),
                                    );
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
    return new Scaffold(
//      appBar: AppBar(
//        title: Text("Your Created Projects"),
//      ),
      body: StreamBuilder(
          stream: databaseReference.child("projects").onValue,
          builder: (context, snap) {
            if (snap.hasData &&
                !snap.hasError &&
                snap.data.snapshot.value != null) {
              Map data = snap.data.snapshot.value;
              ourCreatedProjects.clear();
              allProjects = [];
              data.forEach(
                    (index, data) => allProjects.add({"key": index, ...data}),
              );

              for (int i = 0; i < allProjects.length; i++) {

                  ourCreatedProjects.add(allProjects[i]);

              }
              return new Column(
                children: <Widget>[
                  new Expanded(
                    child: new ListView.builder(
                      itemCount: ourCreatedProjects.length,
                      itemBuilder: (context, index) {
                        return displayProject(index);
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
          }),
      //floatingActionButton: floats(context, Test()),
    );
  }
}
