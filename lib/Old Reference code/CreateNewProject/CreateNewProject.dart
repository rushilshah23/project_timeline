//This page is under supervisor section


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateNewProject extends StatefulWidget {

  @override
  _CreateNewProjectState createState() => _CreateNewProjectState();
}

class _CreateNewProjectState extends State<CreateNewProject> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(

          title: Text("Create New Project"),
        ),
        body: Container(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.

        ));
  }
}
