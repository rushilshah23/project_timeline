import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../CommonWidgets.dart';


class CreateNewTask extends StatefulWidget {
  final String projectID;
  CreateNewTask({Key key, this.projectID}) : super(key: key);

  @override
  _CreateNewTaskState createState() => _CreateNewTaskState();
}

class _CreateNewTaskState extends State<CreateNewTask> with SingleTickerProviderStateMixin {
  String taskName,description,start,end,hours;
  String supervisorUID = "cHvmoDkm5fQC34NalR0GFa9ZMMJ2";

  DateTime startDate,endDate;
  int noOfRequest, selectedProjectIndex;
  final _formKey = GlobalKey<FormState>();

  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController hoursController = TextEditingController();

  final databaseReference = FirebaseDatabase.instance.reference();

  addTask() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        taskName = taskNameController.text;
        description = descriptionController.text;
        hours = hoursController.text;
      });

      if (startDate == null)
        start = "not specified";
      else
        start = startDate.toString();

      if (endDate == null)
        end = "not specified";
      else
        end = endDate.toString();

      if (description == "" ||description ==null)
        description = "not specified";
      else
        description = description;

      if (hours == "" ||hours == null)
        hours = "not specified";
      else
        hours = hours;

      var uuid = Uuid();
      String uniqueID = uuid.v1();

      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
      final String requestTime = formatter.format(now);

      try {
        databaseReference.child("projects").child(widget.projectID).child("tasks").child(uniqueID).set({

          'taskName': taskName,
          'taskID': uniqueID,
          'taskDescription': description,
          'status': "Not started",
          'hoursOfWorks': hours,
          'progress': "0",
          'duration':{
            'startDate':start,
            'endDate':end,
          }
        });
        showToast("Task added \nSuccessfully");
      } catch (e) {
        showToast("Failed. check your internet!");
      }
    }
  }


  @override
  void initState() {
    super.initState();
  }

  Future<DateTime> _selectDate(BuildContext context) async {
    DateTime d = await showDatePicker(
        builder: (BuildContext context, Widget widget) {
          return Theme(data: ThemeData.light(), child: widget);
        },
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1990),
        lastDate: DateTime(2100));
    return d;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child : Material(
//      appBar: AppBar(
//        title: Text(
//          "Send Request",
//        ),
//      ),
        child: Container(

          height: MediaQuery.of(context).size.height/1.3,
          width: MediaQuery.of(context).size.width/1.2,
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Add a new Task",
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    TextFormField(
                      minLines: 1,
                      maxLines: 2,
                      validator: (String content) {
                        if (content.length == 0) {
                          return "Please enter task name";
                        } else {
                          return null;
                        }
                      },
                      controller: taskNameController,
                      decoration: InputDecoration(
                        labelText: "Task Name",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      minLines: 1,
                      maxLines: 4,
//                      validator: (String content) {
//                        if (content.length == 0) {
//                          return "Please enter valid address";
//                        } else {
//                          return null;
//                        }
//                      },
                      controller: descriptionController,
                      decoration: InputDecoration(
                        labelText: "Task description(Optional)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),

                    Text(
                      "Duration (optional)",
                      style: TextStyle(fontSize: 16),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new Container(
                            width: MediaQuery.of(context).size.width/3,

                            child: Card(

                                child: ListTile(
                                  leading: Icon(
                                    Icons.date_range,
                                  ),
                                  title: Text(
                                    (startDate == null)
                                        ? 'start'
                                        : DateFormat.yMMMd().format(startDate),
                                    textAlign: TextAlign.left,
                                  ),
                                  onTap: () {
                                    _selectDate(context).then((date) {
                                      setState(() {
                                        startDate = date;
                                      });
                                    });
                                  },
                                )),
                        ),

                        new Container(
                            width: MediaQuery.of(context).size.width/3,

                            child: Card(

                                child: ListTile(
                                  leading: Icon(
                                    Icons.date_range,
                                  ),
                                  title: Text(
                                    (endDate == null)
                                        ? 'end'
                                        : DateFormat.yMMMd().format(endDate),
                                    textAlign: TextAlign.left,
                                  ),
                                  onTap: () {
                                    _selectDate(context).then((date) {
                                      setState(() {
                                        endDate = date;
                                      });
                                    });
                                  },
                                )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),


                    TextFormField(

                      controller: hoursController,
                      decoration: InputDecoration(
                        labelText: "Hours/day (Optional)",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text("Add task"),
                      onPressed: () {
                        addTask();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        )));
  }
}
