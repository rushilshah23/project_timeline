import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_timeline/CommonWidgets.dart';

import '../CommonWidgets.dart';

class SearchWorkerPage extends StatefulWidget {
  @override
  _SearchWorkerPageState createState() => _SearchWorkerPageState();
}

class _SearchWorkerPageState extends State<SearchWorkerPage> {
  String selectedValue;
  List<int> selectedItems = [];
  List<String> prevSelected = [];
  final List<DropdownMenuItem> items = [];
  final List<WorkerList> workersList = [];
  final CollectionReference workers = Firestore.instance.collection("workers");
  final databaseReference = FirebaseDatabase.instance.reference();
  var projectID = "b570da70-fa93-11ea-9561-89a3a74b28bb";

  Future<void> getData() async {
    await workers.getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        setState(() {
          items.add(
            DropdownMenuItem(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result['name']),
                  Text(
                    result['mobile'].toString() +
                        "  " +
                        result['email'].toString(),
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              )),
              value: result['uid'].toString() +
                  "," +
                  result["name"].toString() +
                  "," +
                  result["mobile"].toString(),
            ),
          );
          workersList
              .add(WorkerList(result['name'], result['mobile'], result['uid']));
        });
      });
    });
    await databaseReference
        .child("projects")
        .child(projectID)
        .child("workers")
        .once()
        .then((snapshot) {
      if (snapshot != null) {
        snapshot.value.forEach((workerSelected, i) {
          workersList.forEach((worker) {
            if (workerSelected == worker.uid) {
              setState(() {
                prevSelected.add(workerSelected);
                selectedItems.add(workersList.indexOf(worker));
              });
            }
          });
        });
      }
    });
  }

  void submitForm() async {
    try {
      prevSelected.forEach((prevWorker) async {
        await workers
            .document(prevWorker)
            .updateData({"assignedProject": "No project assigned"});
      });
      await databaseReference
          .child("projects")
          .child(projectID)
          .child("workers")
          .set({});
      selectedItems.forEach((i) async {
        print(workersList[i].uid);
        await workers
            .document(workersList[i].uid)
            .updateData({"assignedProject": projectID});
        await databaseReference
            .child("projects")
            .child(projectID)
            .child("workers")
            .child(workersList[i].uid)
            .set({
          "name": workersList[i].name,
          "mobile": workersList[i].mobile,
        });
      });
      showToast("Added successfully");
      Navigator.of(context).pop();
    } catch (e) {
      showToast("Failed. Check your Internet");
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (items.length > 0)
      return Scaffold(
          appBar: ThemeAppbar("Add Workers"),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 10),
                    Center(
                      child: titleStyles('Add Workers', 18),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: SearchableDropdown.multiple(
                        items: items,
                        selectedItems: selectedItems,
                        hint: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text("Select any"),
                        ),
                        searchHint: "Select any",
                        onChanged: (value) {
                          setState(() {
                            selectedItems = value;
                          });
                          print(selectedItems);
                        },
                        closeButton: (selectedItems) {
                          return (selectedItems.isNotEmpty
                              ? "Save ${selectedItems.length == 1 ? '"' + items[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                              : "Save without selection");
                        },
                        isExpanded: true,
                      ),
                    ),
                    SizedBox(height: 20),
                    FlatButton(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: gradients()),
                        child: Center(
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: () {
                        submitForm();
                      },
                    ),
                    // buttons(context, submitForm, 'Save', 18)
                  ],
                ),
              ],
            ),
          ));
    else
      return Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
  }
}

class WorkerList {
  WorkerList(this.name, this.mobile, this.uid);
  var name;
  var mobile;
  var uid;
}
