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
                        percent: double.parse(percent.toString()) / 100,
                        center: new Text(
                          percent.toString() + "%",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.orange[800],
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
                        percent: double.parse(percent1.toString()) / 100,
                        center: new Text(
                          percent1.toString() + "%",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.orange[600],
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
                        percent: double.parse(percent2.toString()) / 100,
                        center: new Text(
                          percent2.toString() + "%",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.orange[300],
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
