import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/ProgressTimeLine/ViewAllProjects/ProjectDetails.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'package:project_timeline/CommonWidgets.dart';
import 'package:project_timeline/progressProject/progressDetails.dart';

class ProjectProgress extends StatefulWidget {
  @override
  _ProjectProgressState createState() => _ProjectProgressState();
}

class _ProjectProgressState extends State<ProjectProgress> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List allProjects = List();

  @override
  void initState() {
    super.initState();
  }

  Widget displayProject(int index, allProjects) {
    return Container(
        child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProgressDetails(
                    allProjectDetails: allProjects[index],
                  )),
        );
      },
      child: Card(
          elevation: 4,
          margin: EdgeInsets.only(left: 5, right: 0, top: 7, bottom: 7),
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
                            // '',
                            "Name: " + allProjects[index]["projectName"],
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
                          // Text(
                          //   '',
                          //   // "Email :" + allProjects[index]["email"],
                          //   overflow: TextOverflow.clip,
                          //   maxLines: 2,
                          //   softWrap: false,
                          //   style: TextStyle(fontSize: 14),
                          // ),
                          // Text(
                          //   '',
                          //   // "Address: " + allProjects[index]["address"],
                          //   overflow: TextOverflow.clip,
                          //   maxLines: 2,
                          //   softWrap: false,
                          //   style: TextStyle(fontSize: 14),
                          // ),
                          // Row(
                          //   children: <Widget>[
                          //     Text(
                          //       '',
                          //       // "Age: " + allProjects[index]["age"],
                          //       overflow: TextOverflow.clip,
                          //       maxLines: 2,
                          //       softWrap: false,
                          //       style: TextStyle(fontSize: 14),
                          //     ),
                          //     SizedBox(
                          //       width: 10,
                          //     ),
                          //     Text(
                          //       '',
                          //       // "Phone no: " + allProjects[index]["phoneNo"],
                          //       overflow: TextOverflow.clip,
                          //       maxLines: 2,
                          //       softWrap: false,
                          //       style: TextStyle(fontSize: 14),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(
                          //   height: 15,
                          // )
                        ],
                      )),
                  // Container(
                  //     margin: EdgeInsets.only(top: 5),
                  //     child: Column(
                  //       children: <Widget>[
                  //         SizedBox(
                  //           width: 10,
                  //         ),
                  //         FlatButton(
                  //           color: Color.fromRGBO(204, 255, 153, 1),
                  //           child: Text("Accept"),
                  //           onPressed: () {},
                  //         ),
                  //         SizedBox(
                  //           width: 10,
                  //         ),
                  //       ],
                  //     ))
                ],
              )
            ],
          ))),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new StreamBuilder(
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

            return Scaffold(
              appBar: AppBar(title: Text('Projects')),
              body: new Column(
                children: [
                  Expanded(
                      child: Container(
                    width: MediaQuery.of(context).size.width,
//                      margin: EdgeInsets.only(
//                          top: 15, bottom: 230, right: 10, left: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      // color: primaryColor,

                    ),
                    child: Column(
                      children: [
                        // Text(allProjects.toString()),
                        Expanded(
                          child: new ListView.builder(
                            itemCount: allProjects.length,
                            itemBuilder: (context, index) {
                              return Container(
                                  // height: 280,
                                  margin: EdgeInsets.all(10),
                                  child: displayProject(index, allProjects));
                            },
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.indigo),
            ));
          }
        });
  }
}
