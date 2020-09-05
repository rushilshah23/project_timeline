import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_timeline/CommonWidgets.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../CommonWidgets.dart';
import '../CommonWidgets.dart';

class WorkerForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Update work"),
//      ),
      body: WorkerFormPage(),
    );
  }
}

class WorkerFormPage extends StatefulWidget {
  @override
  _WorkerFormPageState createState() => _WorkerFormPageState();
}

class _WorkerFormPageState extends State<WorkerFormPage> {
  List<DropdownMenuItem> machines = [];
  List<int> selectedMachine = [];
  List<String> machineUsed = [];
  var hoursWorked,
      depth,
      length,
      upperWidth,
      lowerWidth,
      todaysDate,
      volume,
      comment;
  final databaseReference = FirebaseDatabase.instance.reference();
  final _formKey = GlobalKey<FormState>();
  TextEditingController hoursWorkedController = TextEditingController();
  TextEditingController depthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController upperWidthController = TextEditingController();
  TextEditingController lowerWidthController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  var projectID = 'project1';
  var workerID = 'Lm4oPWmWAkTELRXPc4nPv5i7pB92';
  var workerName = 'rajesh kumar';

  @override
  void initState() {
    loadMachines();
    super.initState();
    todaysDate = formatter.format(now);
  }

  void loadMachines() async {
    await databaseReference
        .child("masters")
        .child("machineMaster")
        .once()
        .then((snapshot) {
      snapshot.value.forEach((key, values) {
        setState(() {
          machines.add(
            DropdownMenuItem(
              child: Text(values["machineName"].toString()),
              value: values["machineID"].toString(),
            ),
          );
        });
        print(machines);
      });
    });
  }

  void submitForm() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        selectedMachine.forEach((i) {
          machineUsed.add(machines[i].value);
        });
        print(machineUsed);
        hoursWorked = hoursWorkedController.text;
        depth = double.parse(depthController.text);
        length = double.parse(lengthController.text);
        upperWidth = double.parse(upperWidthController.text);
        lowerWidth = double.parse(lowerWidthController.text);
        comment = commentController.text;
      });
      volume = length * depth * (upperWidth + lowerWidth) / 2;
      try {
        await databaseReference
            .child("projects")
            .child(projectID)
            .child("progress")
            .child(todaysDate)
            .child(workerID)
            .set({
          "MachineUsed": machineUsed,
          "hoursWorked": hoursWorked,
          "workerName": workerName,
          "depth": depth,
          "length": length,
          "upperWidth": upperWidth,
          "lowerWidth": lowerWidth,
          "volumeExcavated": volume,
          "status": "pending",
          "comment": comment,
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
    if (machines.length > 0)
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
                  'For :' + ' $todaysDate',
                  style: titlestyles(18, Colors.orange),
                ),
                SizedBox(
                  height: 10,
                ),
                SearchableDropdown.multiple(
                  items: machines,
                  selectedItems: selectedMachine,
                  hint: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Select any"),
                  ),
                  searchHint: "Select any",
                  onChanged: (value) {
                    setState(() {
                      selectedMachine = value;
                    });
                    print(value);
                    print(selectedMachine);
                  },
                  closeButton: (selectedMachine) {
                    return (selectedMachine.isNotEmpty
                        ? "Save ${selectedMachine.length == 1 ? '"' + machines[selectedMachine.first].value.toString() + '"' : '(' + selectedMachine.length.toString() + ')'}"
                        : "Save without selection");
                  },
                  isExpanded: true,
                ),
                SizedBox(
                  height: 10,
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
                  height: 10,
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
                            width: 10.0,
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
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: commentController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 5,
                  validator: (String value) {
                    if (value.length == 0) {
                      value = "No comment";
                      return null;
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: "(Optional) Comment",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  height: 50,
                  child: FlatButton(
                    onPressed: submitForm,
                    child: Container(
                      height: 50,
                        width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: gradients(),
                        borderRadius: BorderRadius.circular(10)
                      ), 
                      child: Center(child: Text("Submit",style: TextStyle(color: Colors.white),))
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    else
      return Center(
        child: CircularProgressIndicator(),
      );
  }
}

class MachineDetails {
  MachineDetails(this.machineName, this.machineID, this.modelName);
  var machineName;
  var machineID;
  var modelName;
}
