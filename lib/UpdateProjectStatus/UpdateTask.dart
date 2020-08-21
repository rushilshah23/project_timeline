import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../CommonWidgets.dart';

class UpdateTask extends StatefulWidget {
  final Map taskID;
  final dynamic projectID;
  UpdateTask({Key key, this.taskID, this.projectID}) : super(key: key);

  @override
  _UpdateTaskState createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final databaseReference = FirebaseDatabase.instance.reference();
  String taskName, taskDescription;
  List taskDetails;

  final String test = "asfasfdas";

  final _formKey = GlobalKey<FormState>();

  TextEditingController taskNameController = TextEditingController();
  TextEditingController statusDescriptionController = TextEditingController();
  TextEditingController status = TextEditingController();

  getProjectDetails() async {
    debugPrint("task " + widget.taskID["taskID"].toString());
    debugPrint("projectID " + widget.projectID);

    databaseReference
        .child("projects")
        .child(widget.projectID)
        .child("tasks")
        // .child(widget.taskID["taskID"].toString())
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        taskName = snapshot.value[widget.taskID["taskID"]].toString();
        taskDescription = snapshot.value["taskDescription"].toString();
      });
    });

    debugPrint(taskName);
    debugPrint(taskDescription);
  }

  updateTask() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        // taskName = taskNameController.text;
        taskDescription = statusDescriptionController.text;
        // hours = hoursController.text;
      });

      if (taskDescription == "" || taskDescription == null)
        taskDescription = "not specified";
      else
        taskDescription = taskDescription;

      // if (hours == "" || hours == null)
      //   hours = "not specified";
      // else
      //   hours = hours;

      var uuid = Uuid();
      String uniqueID = uuid.v1();

      // final DateTime now = DateTime.now();
      // final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm');
      // final String requestTime = formatter.format(now);

      try {
        databaseReference
            .child("projects")
            .child(widget.projectID)
            .child("tasks")
            .child(widget.taskID["taskID"].toString())
            .update({
          'taskDescription': taskDescription,
        });
        showToast("Edited \nSuccessfully");
      } catch (e) {
        showToast("Failed. check your internet!");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getProjectDetails();
    debugPrint(widget.taskID.toString());
    setState(() {
      taskNameController.text = widget.taskID["taskName"].toString();
      statusDescriptionController.text =
          widget.taskID["taskDescription"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Tasks"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Task Name: " + widget.taskID["taskName"],
                    overflow: TextOverflow.clip,
                    maxLines: 1,
                    softWrap: false,
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Task Desc: " + widget.taskID["taskDescription"],
                    overflow: TextOverflow.clip,
                    maxLines: 3,
                    softWrap: false,
                    style: TextStyle(fontSize: 23),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Start Date:" + widget.taskID["duration"]["startDate"],
                    overflow: TextOverflow.clip,
                    maxLines: 3,
                    softWrap: false,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "End Date:" + widget.taskID["duration"]["endDate"],
                    overflow: TextOverflow.clip,
                    maxLines: 3,
                    softWrap: false,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // TextFormField(
              //   minLines: 1,
              //   maxLines: 2,
              //   validator: (String content) {
              //     if (content.length == 0) {
              //       return "Please enter task name";
              //     } else {
              //       return null;
              //     }
              //   },
              //   controller: taskNameController,
              //   decoration: InputDecoration(
              //     labelText: "Task Name",
              //     border: OutlineInputBorder(),
              //   ),
              // ),
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
                // onChanged: (content) {
                //   debugPrint("tesing on changes it changes or not");
                //   updateTask(content);
                // },
                controller: statusDescriptionController,
                decoration: InputDecoration(
                  labelText: "Status Description",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              RaisedButton(
                  color: Colors.amber[300],
                  onPressed: () {
                    updateTask();
                  },
                  child: Text("Update")),
            ],
          ),
        ),
      ),
    );
  }
}
