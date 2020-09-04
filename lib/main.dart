import 'package:flutter/material.dart';
import 'package:project_timeline/manager/createNewProject.dart';
import 'package:project_timeline/manager/master/petrolMaster/petrolMaster.dart';
import 'package:project_timeline/addWorkers.dart';
import 'package:project_timeline/workerDaily.dart';
import 'package:project_timeline/workerForm.dart';
import 'manager/master/machineMaster/machineMaster.dart';
import 'package:project_timeline/supervisor/SupervIsorTaskModule.dart';

import 'manager/test.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text("Add New Project"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Test()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Machine Master"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MachineMaster()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Supervisor Section"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SupervisorTaskModule()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Petrol Module"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PetrolMaster()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Search Worker"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchWorker()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Worker Form"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkerForm()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Worker Daily Updates"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkerDaily()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
