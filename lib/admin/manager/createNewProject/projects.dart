//This page is under manager section

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../CommonWidgets.dart';
import 'test.dart';

class CreatedProjects extends StatefulWidget {
  @override
  _CreatedProjectsState createState() => _CreatedProjectsState();
}

class _CreatedProjectsState extends State<CreatedProjects> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List ourCreatedProjects = List();
  List allProjects = List();

   final CollectionReference markers =
        FirebaseFirestore.instance.collection("markers");

  @override
  void initState() {
    super.initState();
  }


    Future<void> _onDelete(String projectID) {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to delete the project?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () async{
                databaseReference
                        .child("projects")
                        .child(projectID)
                        .remove();

                        await markers
                      .doc(projectID)
                      .delete();

                    showToast("Removed Sucessfully");
                    Navigator.of(context).pop();
            },
            child: Text("YES"),
          ),
        ],
      ),
    );
  }


  Widget displayProject(int index) {
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
                        padding: EdgeInsets.only(  top: 20, bottom: 20),
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
                            // Text(
                            //   "Supervisor Name" + ": " + "Shraddha.V.Pawar",
                            //   overflow: TextOverflow.clip,
                            //   maxLines: 2,
                            //   softWrap: false,
                            //   style: TextStyle(fontSize: 14),
                            // ),

                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  "Progress" + ": " + ourCreatedProjects[index]["progressPercent"]+" %",
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Status" + ": " + ourCreatedProjects[index]["projectStatus"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        )),

                              IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.grey,
                              onPressed: () {
                                _onDelete(ourCreatedProjects[index]["projectID"]);
                              },
                            ),
                          
//                     Container(
//                         margin: EdgeInsets.only(top: 5),
//                         child: Column(
//                           children: <Widget>[
//                             SizedBox(
//                               width: 10,
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.edit),
//                               color: Colors.grey,
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => EditProject(
//                                           uniqueId: ourCreatedProjects[index])),
//                                 );
//                               },
//                             ),
//                              icon: Icon(Icons.delete),
//                               color: Colors.grey,
//                               onPressed: () {},
//                             ),       IconButton(
//                       
//                             IconButton(
//                               icon: Icon(Icons.add_box),
//                               color: Colors.grey,
//                               onPressed: () {
// //                                    Navigator.push(
// //                                      context,
// //                                      MaterialPageRoute(
// //                                          builder: (context) => YourCreatedTasks(
// //                                            projectID: myCreatedProjects[index]
// //                                            ["projectID"],
// //                                          )),
// //                                    );
//                               },
//                             ),
//                           ],
//                         ))
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
          }),
      floatingActionButton: floats(
        context,
        Test(),
      ),
    );
  }
}
