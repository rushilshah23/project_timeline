import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../CommonWidgets.dart';


class UpdateTask extends StatefulWidget {
  final Map taskID;
  final dynamic projectID;
  UpdateTask({Key key, this.taskID, this.projectID}) : super(key: key);

  @override
  _UpdateTaskState createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  final databaseReference = FirebaseDatabase.instance.reference();
  String taskName, statusDescription;
  double statusProgress;
  List taskDetails;
  String dropdownValue = "Not Started";
  double _currentSliderValue = 25;
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
        .child(widget.taskID["taskID"])
        .once()
        .then((DataSnapshot snapshot) {
      setState(() {
        taskName = snapshot.value["taskID"].toString();
        // statusDescription = snapshot.value["statusDescription"].toString();
        // statusProgress = snapshot.value["progress"];
      });
    });

    debugPrint("this is just a taste" + taskName);
    debugPrint(statusDescription);
    debugPrint(statusProgress.toString());
  }

  updateTask() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        // taskName = taskNameController.text;
        statusDescription = statusDescriptionController.text;
        // hours = hoursController.text;
      });

      if (statusDescription == "" || statusDescription == null)
        statusDescription = "not specified";
      else
        statusDescription = statusDescription;

      var uuid = Uuid();
      String uniqueID = uuid.v1();
      try {
        databaseReference
            .child("projects")
            .child(widget.projectID)
            .child("tasks")
            .child(widget.taskID["taskID"])
            .update({
          'statusDescription': statusDescription,
          'status': dropdownValue,
          'progress': _currentSliderValue,
        });
        showToast("Edited \nSuccessfully");
      } catch (e) {
        showToast("Failed. check your internet!");
      }
    }
  }

  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 0);
  }

  @override
  void initState() {
    super.initState();
    getProjectDetails();
    debugPrint(widget.taskID.toString());
    setState(() {
      taskNameController.text = widget.taskID["taskName"].toString();
      statusDescriptionController.text =
          widget.taskID["statusDescription"].toString();
      dropdownValue = widget.taskID["status"].toString();
      _currentSliderValue = widget.taskID["progress"].toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Work Details"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Task Name: " + widget.taskID["taskName"],
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      softWrap: false,
                      style: TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        "Task Desc: " + widget.taskID["taskDescription"],
                        overflow: TextOverflow.clip,
                        maxLines: 3,
                        softWrap: true,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                  mainAxisAlignment: MainAxisAlignment.start,
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
                  height: 30,
                ),
                Text(
                  "Update Work Details",
                  style: TextStyle(fontSize: 23),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Status"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: dropdownValue,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    elevation: 16,
                    hint: Text('What is the work Status '),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                    ),
                    underline: Container(
                      height: 2,
                      color: Colors.blue[300],
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>[
                      'Not Started',
                      'On Going',
                      'Completed',
                      'Stuck'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Progress : ",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        format(_currentSliderValue).toString() + "%",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                Slider(
                  value: _currentSliderValue,
                  min: 0,
                  max: 100,
                  divisions: 100,
                  label: _currentSliderValue.round().toString(),
                  onChanged: (double value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: TextFormField(
                    minLines: 1,
                    maxLines: 3,
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
                ),
                SizedBox(
                  height: 30,
                ),
                RaisedButton(
                    color: Colors.indigo[300],
                    onPressed: () {
                      updateTask();
                    },
                    child: Text("Update Details")),

                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
