import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project_timeline/admin/reportGeneration/reportTest.dart';
import 'package:project_timeline/admin/supervisor/AllocatedProjects.dart';
import 'package:project_timeline/admin/worker/updateWork.dart';
import 'CommonWidgets.dart';

class DashBoard extends StatefulWidget {
  String name, email, mobile, password, uid, userType, assignedProject;
  DashBoard(
      {Key key,
      this.name,
      this.email,
      this.mobile,
      this.assignedProject,
      this.userType,
      this.uid})
      : super(key: key);
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  double percent = 10;
  double percent1 = 10;
  double percent2 = 80;
  bool isWorkerA=false,isSuperA=false;

  final databaseReference = FirebaseDatabase.instance.reference();

  int team = 0;

  List allProjects = List();
  int noOfProjects = 0;
  int completed = 0;
  int notStarted = 0;
  int ongoing = 0;
  double completedPercent = 0.0;
  double notStartedPercent = 0.0;
  double ongoingPercent = 0.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[_myAppBar2(), _body()],
      ),
    );
  }

  getDetails() async {
    int m = 0, s = 0, w = 0;
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

    await FirebaseFirestore.instance
        .collection('manager')
        .get()
        .then((myDocuments) {
      m = team + myDocuments.docs.length;
    });

    await FirebaseFirestore.instance
        .collection('supervisor')
        .get()
        .then((myDocuments) {
      s = team + myDocuments.docs.length;
    });

    await FirebaseFirestore.instance
        .collection('workers')
        .get()
        .then((myDocuments) {
      w = team + myDocuments.docs.length;
    });

    setState(() {
      team = m + s + w;
    });
  }

  @override
  void initState() {
    super.initState();
    getDetails();

    if( !widget.assignedProject.contains(" ") && !widget.assignedProject.contains("No project assigned"))
    {
      if(widget.userType.contains("Supervisor"))
      setState(() { debugPrint("trueeeeeeeeeeeeeee sssssssssssss");isSuperA= true;});
                 
      else  if(widget.userType.contains("Worker"))
      setState(() {debugPrint("trueeeeeeeeeeeeeee wwwwwwwwwww");isWorkerA = true;});
                

      debugPrint("trueeeeeeeeeeeeeee");
      debugPrint(widget.userType);
    }

  }

  Widget _myAppBar2() {
    return Container(
      height: MediaQuery.of(context).size.height / 3.5,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
//        gradient: LinearGradient(
//            colors: [ Colors.orange[200],Colors.orange[400],Colors.orange[600],Colors.orange[800],Colors.deepOrange[600]],
//            begin: Alignment.centerRight,
//            end: Alignment(-1.0,-2.0)
//        ),// Gradient
          gradient: gradients()),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0, left: 30),
        child: Center(
            child: Column(
          children: [
            SizedBox(height: 35),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.person_pin,
                      color: Colors.white,
                      size: 50,
                    )),
                SizedBox(width: 15),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 28.0),
                        ),
                        Text(
                          widget.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Projects',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 18)),
                    SizedBox(height: 10),
                    Text(noOfProjects.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 16)),
                  ],
                ),
                Container(
                    height: 60,
                    child: VerticalDivider(
                      color: Colors.grey[400],
                      width: 20,
                      thickness: 2,
                    )),
                Column(
                  children: [
                    Text('Team',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 18)),
                    SizedBox(height: 10),
                    Text(team.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 16)),
                  ],
                ),

              ],
            ),
            SizedBox(height: 35),
            Text(
              'Statistics',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800]),
            ),
            SizedBox(height: 15),
            Row(
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
            SizedBox(height: 70),
          

            widget.userType.contains("Manager")
                ? Center(
                    child: FlatButton(
                      child: buttonContainers(
                          double.infinity, 'Get Report', 18),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ReportGenerationTesting()),
                        );
                      },
                    ),
                  )
                : Container(),


                    isSuperA
                ? Center(
                    child: FlatButton(
                      child: buttonContainers(
                          double.infinity, 'Approve Work', 18),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>YourAllocatedProjects(
                                          name: widget.name,
                                          email: widget.email,
                                          uid: widget.uid,
                                          assignedProject: widget.assignedProject,
                                          mobile: widget.mobile,
                                          userType: widget.userType,
                              )
                            ),
                        );
                      },
                    ),
                  )
                : Container(),

                isWorkerA
                ? Center(
                    child: FlatButton(
                      child: buttonContainers(
                          double.infinity, 'Update Your Work', 18),
                      onPressed: () {
                         Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateWork(
                                          name: widget.name,
                                          email: widget.email,
                                          uid: widget.uid,
                                          assignedProject: widget.assignedProject,
                                          mobile: widget.mobile,
                                          userType: widget.userType,
                                        )),
                              );
                      },
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
