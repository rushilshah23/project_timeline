import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_timeline/CommonWidgets.dart';

class WorkerForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update work"),
      ),
      body: WorkerFormPage(),
    );
  }
}

class WorkerFormPage extends StatefulWidget {
  @override
  _WorkerFormPageState createState() => _WorkerFormPageState();
}

class _WorkerFormPageState extends State<WorkerFormPage> {
  List<String> machines = ['A', 'B', 'C', 'D'];
  String selectedMachine;
  var machineUsed,
      hoursWorked,
      depth,
      length,
      upperWidth,
      lowerWidth,
      todaysDate,
      volume;
  final databaseReference = FirebaseDatabase.instance.reference();
  final _formKey = GlobalKey<FormState>();
  TextEditingController hoursWorkedController = TextEditingController();
  TextEditingController depthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController upperWidthController = TextEditingController();
  TextEditingController lowerWidthController = TextEditingController();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  var projectID = 'project1';
  var workerID = 'worker1';

  @override
  void initState() {
    super.initState();
    todaysDate = formatter.format(now);
  }

  void submitForm() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        machineUsed = selectedMachine;
        hoursWorked = hoursWorkedController.text;
        depth = double.parse(depthController.text);
        length = double.parse(lengthController.text);
        upperWidth = double.parse(upperWidthController.text);
        lowerWidth = double.parse(lowerWidthController.text);
      });
      volume = length * depth * (upperWidth + lowerWidth) / 2;
      try {
        await databaseReference
            .child("projects")
            .child(projectID)
            .child("progress")
            .child(todaysDate)
            .child(workerID)
            .update({
          "MachineUsed": machineUsed,
          "hoursWorked": hoursWorked,
          "volumeExcavated": volume,
          "status": "pending",
        });
        showToast("Added successfully");
        Navigator.of(context).pop();
      } catch (e) {
        showToast("Failed. Check your Internet");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Update Work',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'For :' + ' $todaysDate',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(
                height: 20,
              ),
              DropdownButton(
                value: selectedMachine,
                hint: Text("Select Machine Used"),
                isExpanded: true,
                items: machines.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: new Text(value),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    selectedMachine = val;
                  });
                },
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: hoursWorkedController,
                keyboardType: TextInputType.number,
                validator: (String value) {
                  if (value.length == 0) {
                    return "Please Enter Hours Worked";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  labelText: "Hours Worked",
                  border: OutlineInputBorder(),
                  hintText: "Enter Hours Worked",
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0) //         <--- border radius here
                        ),
                  ),
                  child: Column(
                    children: [
                      Text('PROJECT GOALS',
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic)),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Flexible(
                            child: TextFormField(
                              controller: lengthController,
                              keyboardType: TextInputType.number,
                              validator: (String value) {
                                if (value.length == 0) {
                                  return "Please enter Length";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "Length ",
                                border: OutlineInputBorder(),
                                hintText: "Enter LengthController",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          new Flexible(
                            child: TextFormField(
                              controller: depthController,
                              keyboardType: TextInputType.number,
                              validator: (String value) {
                                if (value.length == 0) {
                                  return "Please Enter Depth";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "Depth",
                                border: OutlineInputBorder(),
                                hintText: "Enter Depth",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Flexible(
                            child: TextFormField(
                              controller: upperWidthController,
                              keyboardType: TextInputType.number,
                              validator: (String value) {
                                if (value.length == 0) {
                                  return "Please Enter Upper Width";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "Upper Width",
                                border: OutlineInputBorder(),
                                hintText: "Enter Upper Width",
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          new Flexible(
                            child: TextFormField(
                              controller: lowerWidthController,
                              keyboardType: TextInputType.number,
                              validator: (String value) {
                                if (value.length == 0) {
                                  return "Please Enter Lower Width";
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "Lower Width",
                                border: OutlineInputBorder(),
                                hintText: "Enter Lower Width",
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                    ],
                  )),
              SizedBox(height: 30),
              Container(
                width: double.infinity,
                height: 50,
                child: RaisedButton(
                  onPressed: submitForm,
                  child: Text("Submit"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
