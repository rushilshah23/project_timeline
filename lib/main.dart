import 'package:flutter/material.dart';
import 'package:project_timeline/manager/master/petrolMaster/petrolMaster.dart';
import 'CommonWidgets.dart';
import 'file:///E:/FLUTTER/Apps/aol/project_timeline/lib/supervisor/addWorkers.dart';
import 'package:project_timeline/supervisor/approveWork/WorkApproveModule.dart';
import 'file:///E:/FLUTTER/Apps/aol/project_timeline/lib/worker/workerDaily.dart';
import 'file:///E:/FLUTTER/Apps/aol/project_timeline/lib/worker/workerForm.dart';
import 'login.dart';
import 'manager/master/machineMaster/machineMaster.dart';


import 'manager/test.dart';
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
        backgroundColor: Colors.deepOrange,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            buttons(context, Test(), 'Add New Project'),
            SizedBox(
              height: 20,
            ),
            buttons(context, MachineMaster(), 'Machine Master'),
            SizedBox(
              height: 20,
            ),
            buttons(context, ApproveWork(), 'Supervisor Section'),
            SizedBox(
              height: 20,
            ),
            buttons(context, PetrolMaster(), 'Petrol Module'),
            SizedBox(
              height: 20,
            ),
            buttons(context, LoginPage(), 'Login'),
            SizedBox(
              height: 20,
            ),
            buttons(context, SearchWorker(), 'Search Worker'),
            SizedBox(
              height: 20,
            ),
            buttons(context, WorkerForm(), 'Worker Form'),
            SizedBox(
              height: 20,
            ),
            buttons(context, WorkerDaily(), 'Worker Daily Updates'),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
