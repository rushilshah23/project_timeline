import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/languages/setLanguageText.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class SearchWorkerPage extends StatefulWidget {
  String name, email, mobile, password, uid, userType, assignedProject;
  SearchWorkerPage(
      {Key key,
      this.name,
      this.email,
      this.mobile,
      this.assignedProject,
      this.userType,
      this.uid})
      : super(key: key);
  @override
  _SearchWorkerPageState createState() => _SearchWorkerPageState();
}

class _SearchWorkerPageState extends State<SearchWorkerPage> {
  String selectedValue;
  List<int> selectedItems = [];
  List<String> prevSelected = [];
  final List<DropdownMenuItem> items = [];
  final List<WorkerList> workersList = [];
  final CollectionReference workers =
      FirebaseFirestore.instance.collection("workers");
  final databaseReference = FirebaseDatabase.instance.reference();
  var projectID;

  Future<void> getData() async {
    await workers.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {

        Color color;
        String status='';
        String isAssng= result["assignedProject"];
        if(isAssng.contains(" ")||isAssng.contains("No project assigned"))
        {
          color = Colors.green[700];
          status= 'No project assigned';
        }
        else  {
          color = Colors.blue[700];
          status= "Project assigned";
          }
        setState(() {


          items.add(
            DropdownMenuItem(
                 child: Container(
                //color: color,
                padding: EdgeInsets.all(10),
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result['name']),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    result.data().containsKey("email")?Text(
                    result['email'].toString(),
                    style: TextStyle(color: Colors.grey),
                  ):Container(),
                   result.data().containsKey("mobile")? Text(
                    result['mobile'],
                    style: TextStyle(color: Colors.grey),
                  ):Container(),
                    ],
                  ),

                  Text(
                    status,
                    style: TextStyle(color:color),
                  )
                 
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
            .doc(prevWorker)
            .update({"assignedProject": 'No project assigned'});
      });
      await databaseReference
          .child("projects")
          .child(projectID)
          .child("workers")
          .set({});
      selectedItems.forEach((i) async {
        print(workersList[i].uid);
        await workers
            .doc(workersList[i].uid)
            .update({"assignedProject": projectID});
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
      showToast(superText2[27]);
      Navigator.of(context).pop();
    } catch (e) {
      showToast(superText2[28]);
    }
  }

  @override
  void initState() {
    setState(() {
      projectID = widget.assignedProject;
    });

    debugPrint("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx" +
        widget.assignedProject.toString());
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (items.length > 0)
      return Scaffold(
          appBar: ThemeAppbar(superText2[29], context),
          body: Container(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: ListView(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 10),
                    Center(
                      child: titleStyles(superText2[29], 18),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: SearchableDropdown.multiple(
                        items: items,
                        selectedItems: selectedItems,
                        hint: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(superText2[30]),
                        ),
                        searchHint: superText2[30],
                        onChanged: (value) {
                          setState(() {
                            selectedItems = value;
                          });
                          print(selectedItems);
                        },
                        closeButton: (selectedItems) {
                          return (selectedItems.isNotEmpty
                              ? "Save ${selectedItems.length == 1 ? '"' + items[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                              : superText3[0]);
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
                          color: Color(0xff018abd),
                        ),
                        child: Center(
                          child: Text(
                            superText3[1],
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
