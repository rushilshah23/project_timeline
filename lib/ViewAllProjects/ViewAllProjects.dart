//This page is for both supervisor and manager

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewAllProjects extends StatefulWidget {

  @override
  _ViewAllProjectsState createState() => _ViewAllProjectsState();
}

class _ViewAllProjectsState extends State<ViewAllProjects> {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(

          title: Text("View All Projects"),
        ),
        body: Container(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.

        ));
  }
}
