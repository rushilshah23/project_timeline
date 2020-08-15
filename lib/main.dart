import 'package:flutter/material.dart';


import 'CreateNewProject/YourCreatedProjects.dart';
import 'UpdateProjectStatus/UpdateProjectStutus.dart';
import 'ViewAllProjects/ViewAllProjects.dart';

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
              child: Text("All Projects \n(manager and supervisor)"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewAllProjects()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Create New Project(manager)"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => YourCreatedProjects()),
                );
              },
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              child: Text("Update Project Status(supervisor)"),
              onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateProjectStatus()),
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
