import 'package:flutter/material.dart';

class TaskDetails extends StatefulWidget {
  @override
  _TaskDetailsState createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        child: Container(
          width: MediaQuery.of(context).width / 2,
        ),
      ),
    );
  }
}
