import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/admin/DocumentManager/core/services/database.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:progress_dialog/progress_dialog.dart';

class DeleteUserPage extends StatefulWidget {
  String userType, collectionName;
  DeleteUserPage({
    Key key,
    this.userType,
    this.collectionName,
  }) : super(key: key);
  @override
  _DeleteUserPageState createState() => _DeleteUserPageState();
}

class _DeleteUserPageState extends State<DeleteUserPage> {
  //var projectID;
  var selectedValue;
  List<int> selectedItems = [];
  final List<DropdownMenuItem> items = [];
  final List<WorkerList> workersList = [];
  CollectionReference workers;

  final CollectionReference user =
      FirebaseFirestore.instance.collection("user");
  final databaseReference = FirebaseDatabase.instance.reference();

  var userid;

  Future<void> getData() async {
    workers = FirebaseFirestore.instance.collection(widget.collectionName);
    await workers.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        setState(() {
          // ------doc manager code-----
          userid = result['uid'].toString();
          // ---------------------------
          items.add(
            DropdownMenuItem(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result['name']),
                  Text(
                    "Contact no:  "+result['mobile'].toString() ,
                    // +  "  " +
                    //     result['email'].toString(),
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
  }

  void submitForm(pr, context) async {
    await pr.show();
    await workers.get().then((w) {
      selectedItems.forEach((i) async {
        w.docs.forEach((e) async {
          if (e.id == workersList[i].uid) {
            print(e.id);
            await user.doc(e.id).set(e.data()).then((value) async {
              await workers.doc(e.id).delete();

              // Document Manager delete folder

              DatabaseService(

                      // globalRef:
                      //     widget.globalRef.child(widget.folderId),
                      userID: userid)
                  .deleteFolder(
                folderId: userid,
                driveRef: databaseReference.child('users'),
                // widget.folderModel.globalRef,

                // folderName: widget.folderName,
              );

              // -------
            });
          }
        });
      });
    });
    await pr.hide();
    showToast("User Deleted Successfully");
    Navigator.of(context).pop();
  }

  @override
  void initState() {
     getData();
    setState(() {
    });
    debugPrint(items.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ProgressDialog pr = ProgressDialog(context);
    if (items.length > 0)
      return Scaffold(
          body: Container(
        padding: EdgeInsets.symmetric(horizontal: 7),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(height: 10),
              Center(
                child: titleStyles('Delete ' + widget.userType, 18),
              ),
              SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                margin: EdgeInsets.all(20),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SearchableDropdown.multiple(
                    items: items,
                    selectedItems: selectedItems,
                    displayClearIcon: false,
                    hint: "Select " + widget.userType,
                    searchHint: "Select any",
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        selectedItems = value;
                      });
                    },
                    dialogBox: false,
                    // closeButton: (selectedItemsClose) {
                    //   return Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: <Widget>[
                    //       RaisedButton(
                    //           onPressed: () {
                    //             setState(() {
                    //               selectedItems.clear();
                    //               selectedItems.addAll(
                    //                   Iterable<int>.generate(items.length)
                    //                       .toList());
                    //             });
                    //           },
                    //           child: Text("Select all")),
                    //       RaisedButton(
                    //           onPressed: () {
                    //             setState(() {
                    //               selectedItems.clear();
                    //             });
                    //           },
                    //           child: Text("Select none")),
                    //     ],
                    //   );
                    // },
                    menuConstraints: BoxConstraints.tight(Size.fromHeight(350)),
                    isExpanded: true,
                  ),
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
                      'Delete ' + widget.userType + "s",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                onPressed: () {
                  submitForm(pr, context);
                },
              ),
              // buttons(context, submitForm, 'Save', 18)
            ],
          ),
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
