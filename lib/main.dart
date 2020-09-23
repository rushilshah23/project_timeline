import 'package:flutter/material.dart';
import 'package:project_timeline/PDFTesting.dart';
import 'package:project_timeline/ProgressCard.dart';
import 'package:project_timeline/imageTesting.dart';
import 'package:project_timeline/manager/CreateAcceptSupervisor/SupervisorFormCreation.dart';
import 'package:project_timeline/manager/CreateAcceptSupervisor/SupervisorRequestList.dart';
import 'package:project_timeline/manager/master/petrolMaster/petrolMaster.dart';
import 'package:project_timeline/progressProject/projectProgress.dart';
import 'package:project_timeline/sms/sms.dart';
import 'package:project_timeline/searchable_dropdown.dart';
import 'package:project_timeline/supervisor/approveWork/WorkApproveModule.dart';
import 'package:project_timeline/supervisor/createAcceptWorker/WorkerCreationForm.dart';
import 'package:project_timeline/supervisor/createAcceptWorker/workerRequestList.dart';
import 'login.dart';
import 'manager/master/machineMaster/machineMaster.dart';
import 'manager/createNewProject/test.dart';
import 'supervisor/addWorkers.dart';
import 'supervisor/approveWork/WorkApproveModule.dart';
import 'worker/workerDaily.dart';
import 'worker/workerForm.dart';

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
        child: ListView(
          children: <Widget>[
            RaisedButton(
              child: Text("Progress Card"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProgressCard()),
                );
              },
            ),
            RaisedButton(
              child: Text("SMS"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Sms()),
                );
              },
            ),
            RaisedButton(
              child: Text("PDF testing"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PDFTesting()),
                );
              },
            ),
            RaisedButton(
              child: Text("Add New Project"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Test()),
                );
              },
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
            RaisedButton(
              child: Text("Supervisor Section"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ApproveWork()),
                );
              },
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
            RaisedButton(
              child: Text("Login"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            RaisedButton(
              child: Text("Search Worker"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchWorkerPage()),
                );
              },
            ),
            RaisedButton(
              child: Text("Supervisor Rquest"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SupervisorRequestList()),
                );
              },
            ),
            RaisedButton(
              child: Text("Worker Request"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkerRequestList()),
                );
              },
            ),
            RaisedButton(
              child: Text("Worker Form- Supervisor can create himself"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkerCreationForm()),
                );
              },
            ),
            RaisedButton(
              child: Text("Supervisor Form- Manager can create himself"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SupervisorFormCreation()),
                );
              },
            ),
            RaisedButton(
              child: Text("Project Progress"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProjectProgress()),
                );
              },
            ),
            RaisedButton(
              child: Text("Worker Form"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WorkerFormPage()),
                );
              },
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
            RaisedButton(
              child: Text("Image test"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ImageTesting()),
                );
              },
            ),
            RaisedButton(
              child: Text("dropdown test"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TestPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
