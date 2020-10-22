import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'ViewAllProjects/ViewAllProjects.dart';

// void main() {
//   runApp(MaterialApp(
//     home: ProgressPage(),
//     debugShowCheckedModeBanner: false,
//   ));
// }

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  double percent = 10;
  double percent1 = 10;
  double percent2 = 80;
  final databaseReference = FirebaseDatabase.instance.reference();
  List allProjects = List();
  int noOfProjects = 0;
  int completed = 0;
  int notStarted = 0;
  int ongoing = 0;
  double completedPercent = 0.0;
  double notStartedPercent = 0.0;
  double ongoingPercent = 0.0;

  @override
  void initState() {
    super.initState();

    databaseReference
        .child("projects")
        .once()
        .then((DataSnapshot dataSnapshot) {
      Map data = dataSnapshot.value;
      allProjects = [];
      allProjects = data.values.toList();

      noOfProjects = allProjects.length;
      for (int i = 0; i < allProjects.length; i++) {
        var progPercent = double.parse(allProjects[i]["progressPercent"]);
        if (progPercent > 0 && progPercent < 100) ongoing++;
        if (progPercent <= 0) notStarted++;
        if (progPercent >= 100) completed++;
      }

      setState(() {
        ongoingPercent = (ongoing / noOfProjects) * 100;
        notStartedPercent = (notStarted / noOfProjects) * 100;
        completedPercent = (completed / noOfProjects) * 100;

        debugPrint(ongoingPercent.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            // height: 70,
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 6.0,
                        animation: true,
                        percent: completedPercent / 100,
                        center: new Text(
                          completedPercent.toInt().toString() + "%",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.blue[800],
                      ),
                      SizedBox(height: 10),
                      Text('Completed',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                              fontSize: 17)),
                    ],
                  ),
                  Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 6.0,
                        animation: true,
                        percent: ongoingPercent / 100,
                        center: new Text(
                          (ongoingPercent.toInt()).toString() + "%",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.blue[600],
                      ),
                      SizedBox(height: 10),
                      Text('Ongoing',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                              fontSize: 17)),
                    ],
                  ),
                  Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 60.0,
                        lineWidth: 6.0,
                        animation: true,
                        percent: notStartedPercent / 100,
                        center: new Text(
                          notStartedPercent.toInt().toString() + "%",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.blue[300],
                      ),
                      SizedBox(height: 10),
                      Text('Not Started',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                              fontSize: 17)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: AllProjects(),
          ),
        ],
      ),
    );
  }
}
