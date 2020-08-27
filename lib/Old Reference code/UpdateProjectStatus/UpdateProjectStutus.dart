//This page is under supervisor section

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'UpdateYourCreatedTasks.dart';


class UpdateProjectStatus extends StatefulWidget {
  final String projectID;
  UpdateProjectStatus({Key key, this.projectID}) : super(key: key);

  @override
  _UpdateProjectStatusState createState() => _UpdateProjectStatusState();
}

class _UpdateProjectStatusState extends State<UpdateProjectStatus> {
  final databaseReference = FirebaseDatabase.instance.reference();

  List myCreatedProjects = List();
  List allProjects = List();
  String SupervisorUid = "cHvmoDkm5fQC34NalR0GFa9ZMMJ2";

  @override
  void initState() {
    super.initState();
  }

  Widget displayProjects(int index) {
    return Container(
      padding: EdgeInsets.only(top: 10),
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
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Project: " + myCreatedProjects[index]["projectName"],
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(fontSize: 14),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Site Address: " +
                              myCreatedProjects[index]["siteAddress"],
                          overflow: TextOverflow.clip,
                          maxLines: 2,
                          softWrap: false,
                          style: TextStyle(fontSize: 14),
                        ),
                        Text(
                          "Supervisor Name :" +
                              myCreatedProjects[index]["supervisorName"],
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
                                  myCreatedProjects[index]["progress"]
                                      .toString() +
                                  "%",
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
                                  myCreatedProjects[index]["status"],
                              overflow: TextOverflow.clip,
                              maxLines: 2,
                              softWrap: false,
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
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
                            icon: Icon(Icons.arrow_forward_ios),
                            color: Colors.grey,
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateYourCreatedTasks(
                                          projectID: myCreatedProjects[index]
                                              ["projectID"],
                                        )),
                              );
                            },
                          ),
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Your Created Projects"),
      ),
      body: StreamBuilder(
        stream: databaseReference.child("projects").onValue,
        builder: (context, snap) {
          if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value != null) {
            Map data = snap.data.snapshot.value;
            allProjects = [];
            data.forEach(
              (index, data) => allProjects.add({"key": index, ...data}),
            );

            for (int i = 0; i < allProjects.length; i++) {
              if (allProjects[i]["supervisorUID"] == SupervisorUid)
                myCreatedProjects.add(allProjects[i]);
            }

            return new Column(
              children: <Widget>[
                new Expanded(
                    child: new ListView.builder(
                  itemCount: myCreatedProjects.length,
                  itemBuilder: (context, index) {
                    return displayProjects(index);
                  },
                ))
              ],
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
