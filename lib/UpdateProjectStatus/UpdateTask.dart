import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

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

  String test = "asfasfdas";

  final _formKey = GlobalKey<FormState>();

  TextEditingController taskNameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController hoursController = TextEditingController();

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

  @override
  void initState() {
    super.initState();
    getProjectDetails();
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
                  labelText: "Status Description",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
