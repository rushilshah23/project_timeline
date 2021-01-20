import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project_timeline/languages/setLanguageText.dart';
import '../../CommonWidgets.dart';
import 'ProjectDetails.dart';
import 'package:project_timeline/multilingual/dynamic_translation.dart';

class AllProjects extends StatefulWidget {
  @override
  _AllProjectsState createState() => _AllProjectsState();
}

class _AllProjectsState extends State<AllProjects> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List allProjects = List();
  String projectName;
  @override
  void initState() {
    super.initState();
  }

  loadTranslatedText(String pName) async {
    await DynamicTranslation()
        .stringTranslate(data: pName)
        .then((value) {
          setState(() {
        projectName = value;
        print("------------------"+projectName);
          });
    });
  }

  Widget displayProject(int index, allProjects) {
    loadTranslatedText(allProjects[index]["projectName"]);

    return Container(
        child: GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProjectDetails(
                    projectDetails: allProjects[index],
                  )),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 8, right: 8),
        child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            elevation: 4,
            margin: EdgeInsets.only(left: 5, right: 0, top: 7, bottom: 7),
            semanticContainer: true,
            color: Colors.blue[50],
            child: Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(20)),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: Container(
                    padding: EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                        border: Border(
                            right: BorderSide(width: 1.0, color: Colors.grey))),
                    child: CircularPercentIndicator(
                      backgroundColor: Colors.grey[400],
                      radius: 48.0,
                      lineWidth: 5,
                      animation: true,
                      percent: double.parse(
                                  allProjects[index]["progressPercent"]) <
                              100
                          ? double.parse(
                                      allProjects[index]["progressPercent"]) >
                                  0
                              ? double.parse(
                                      allProjects[index]["progressPercent"]) /
                                  100
                              : 0
                          : 1,
                      center: new Text(
                        allProjects[index]["progressPercent"].toString() + "%",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.0),
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.blue[900],
                    ),
                  ),
                  title: titleStyles(allProjects[index]["projectName"], 16),
                  subtitle: Text(
                    allProjects[index]["projectStatus"],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
                ))),
      ),
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
                                  margin: EdgeInsets.all(8),
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
          } else if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value == null) {
            return Center(
              child: Text(proText[3]),
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
            ));
          }
        });
  }
}
