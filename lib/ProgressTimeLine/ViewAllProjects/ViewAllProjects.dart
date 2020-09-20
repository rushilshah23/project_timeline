import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/ProgressTimeLine/ViewAllProjects/ProjectDetails.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';
import '../theme.dart';

class AllProjects extends StatefulWidget {
  @override
  _AllProjectsState createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjects> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List allProjects = List();

  @override
  void initState() {
    super.initState();
  }

  Widget displayProject(int index, allProjects) {
    return Stack(
      children: [
        Positioned.fill(
          top: 150,
          bottom: -190,
          child: Container(
            decoration: BoxDecoration(
                boxShadow: customShadow,
                shape:BoxShape.circle,
                color:Colors.white38
            ),
          ),
        ),
        Positioned.fill(
          left: -300,
          top: -2,
          bottom: -80,
          child: Container(
            decoration: BoxDecoration(
                boxShadow: customShadow,
                shape: BoxShape.circle,
                color: Colors.white38
            ),
          ),
        ),
        Stack(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CircularPercentIndicator(
                      backgroundColor: Colors.grey[200],
                      radius: 120.0,
                      lineWidth: 10.0,
                      animation: true,
//                      percent: double.parse(
//                              allProjects[index]["progress"].toString()) /
//                          100,

                      percent: double.parse("70") / 100,
//                      center: new Text(
//                        allProjects[index]["progress"].toString() + "%",
//                        style: new TextStyle(
//                            fontWeight: FontWeight.bold, fontSize: 20.0),
//                      ),

                      center: new Text(
                        "70" + "%",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.indigo[400],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        height: 50,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Colors.indigo[300],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          color: Colors.deepPurple,
                          icon: Icon(
                            Icons.navigate_next,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProjectDetails(
                                        projectDetails: allProjects[index],
                                      )),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 60, left: 5),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Project Name:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        allProjects[index]["projectName"],
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
//                      Text(
//                        'Project Supervisor: ' +
//                            allProjects[index]["supervisorName"],
//                        style: TextStyle(
//                            fontSize: 16, fontWeight: FontWeight.bold),
//                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 150,
                        child: Text(
                          'Site Address: ' + allProjects[index]["siteAddress"],
                          overflow: TextOverflow.visible,
                          softWrap: true,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
//                      Text(
//                        allProjects[index]["siteAddress"],
//                        style: TextStyle(
//                            fontSize: 14, fontWeight: FontWeight.bold),
//                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Project Status: ' + allProjects[index]["projectStatus"],
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
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

            return new Column(
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
                                height: 280,
                                margin: EdgeInsets.all(10),
                                child: displayProject(index, allProjects));
                          },
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.orange),
            ));
          }
        });
  }
}
