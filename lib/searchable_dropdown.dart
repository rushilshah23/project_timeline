import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:firebase_database/firebase_database.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  List<DropdownMenuItem> machines = [];
  List<DropdownMenuItem> workers = [];
  List<WorkerList> workersList = [];
  List<MachineDetails> machineDetails = [];
  var selectedMachine, selectedWorker;
  final databaseReference = FirebaseDatabase.instance.reference();
  var projectID = 'project1';
  var workerID;
  var workerName;
  var machineUsed;
  @override
  void initState() {
    setState(() {
      loadData();
    });
    super.initState();
  }

  void loadData() async {
    await databaseReference
        .child("projects")
        .child(projectID)
        .child("workers")
        .once()
        .then((snapshot) {
      //print(snapshot.value);
      snapshot.value.forEach((key, values) {
        setState(() {
          workers.add(
            DropdownMenuItem(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(values["name"].toString()),
                    Text(
                      values['mobile'].toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              value: key.toString(),
            ),
          );
          workersList.add(
              WorkerList(values['name'], values['mobile'], key.toString()));
        });
      });
    });
    await databaseReference
        .child("masters")
        .child("machineMaster")
        .once()
        .then((snapshot) {
      snapshot.value.forEach((key, values) {
        setState(() {
          machines.add(
            DropdownMenuItem(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(values["machineName"]),
                    Text(
                      values['modelName'],
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              value: values["machineID"].toString(),
            ),
          );
          machineDetails
              .add(MachineDetails(values["machineID"], values["excavation"]));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Container(
        child: Column(
          children: [
            SearchableDropdown.single(
              items: workers,
              value: selectedWorker,
              hint: "Select one",
              searchHint: "Select one",
              onChanged: (value) {
                setState(() {
                  selectedWorker = value;
                });
                print(value);
              },
              isExpanded: true,
            ),
            SearchableDropdown.single(
              items: machines,
              value: selectedMachine,
              hint: "Select one",
              searchHint: "Select one",
              onChanged: (value) {
                setState(() {
                  selectedMachine = value;
                });
                print(value);
              },
              isExpanded: true,
            ),
          ],
        ),
      ),
    );
  }
}

class MachineDetails {
  MachineDetails(this.machineID, this.excavation);
  var machineID;
  var excavation;
}

class WorkerList {
  WorkerList(this.name, this.mobile, this.uid);
  var name;
  var mobile;
  var uid;
}
