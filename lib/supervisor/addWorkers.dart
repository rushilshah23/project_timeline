import 'package:flutter/material.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_timeline/CommonWidgets.dart';

import '../CommonWidgets.dart';
import '../CommonWidgets.dart';

class SearchWorker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(
          title: Text("Add Workers"),
        ),*/
        body: SearchWorkerPage());
  }
}

class SearchWorkerPage extends StatefulWidget {
  @override
  _SearchWorkerPageState createState() => _SearchWorkerPageState();
}

class _SearchWorkerPageState extends State<SearchWorkerPage> {
  String selectedValue;
  List<int> selectedItems = [];
  final List<DropdownMenuItem> items = [];
  final List<WorkerList> workersList = [];
  final CollectionReference workers = Firestore.instance.collection("workers");
  final databaseReference = FirebaseDatabase.instance.reference();
  var projectID = "project1";

  Future<void> getData() async {
    await workers.getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        setState(() {
          items.add(
            DropdownMenuItem(
              child: Text(result['name']),
              value: result['uid'],
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
                selectedItems.add(workersList.indexOf(worker));
              });
            }
          });
        });
      }
    });
  }

  void submitForm() {
    try {
      selectedItems.forEach((i) async {
        await databaseReference
            .child("projects")
            .child(projectID)
            .child("workers")
            .child(workersList[i].uid)
            .update({
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
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 10),
                Center(
                  child: Text('Add Workers',
                      style: titlestyles(18, Colors.orange)
                  ),
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
                SizedBox(height: 10),
                FlatButton(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: gradients()
                    ),
                    child: Center(
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  onPressed: () {
                    submitForm();
                  },
                ),
              ],
            ),
          ],
        ),
      );
    else
      return Center(
        child: CircularProgressIndicator(),
      );
  }
}

class WorkerList {
  WorkerList(this.name, this.mobile, this.uid);
  var name;
  var mobile;
  var uid;
}