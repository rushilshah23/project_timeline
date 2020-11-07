import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/admin/headings.dart';
import 'workDetails.dart';

class ApproveWork extends StatefulWidget {
  String name, email, mobile, password, uid, userType, assignedProject;
  ApproveWork(
      {Key key,
      this.name,
      this.email,
      this.mobile,
      this.assignedProject,
      this.userType,
      this.uid})
      : super(key: key);
  @override
  _ApproveWorkState createState() => _ApproveWorkState();
}

class _ApproveWorkState extends State<ApproveWork> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List allDataList = List();
  List work = List();

  String projectID;

  List days = List();
  List finalDisplayList = List();

  List listOfWork = List();

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    setState(() {
      projectID = widget.assignedProject;
    });
    super.initState();
  }

  Widget getIcon(status) {
    switch (status) {
      case "Pending":
        return Icon(Icons.error_outline);
      case "Accepted":
        return Icon(Icons.done);
      case "Declined":
        return Icon(Icons.clear);
    }
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      //appBar:  ThemeAppbar("Approve Work",context),

      body: StreamBuilder(
          stream: databaseReference
              .child("projects")
              .child(widget.assignedProject)
              .onValue,
          builder: (context, snap) {
            if (snap.hasData &&
                !snap.hasError &&
                snap.data.snapshot.value != null) {
              Map data = snap.data.snapshot.value;
              //debugPrint(data.toString());
              if (data.containsKey("progress")) {
                Map data = snap.data.snapshot.value["progress"];
                allDataList = [];
                data.forEach(
                  (index, data) => allDataList.add({"date": index, ...data}),
                );

                //debugPrint(allMachines.toString());
                // debugPrint(data.keys.toList().toString());
                days = data.keys.toList();
                work = data.values.toList();
                Map temp;
                List uidTemp = [];
                finalDisplayList.clear();

                for (int i = 0; i < work.length; i++) {
                  //debugPrint(work[i].toString());
                  temp = work[i];
                  uidTemp = temp.keys.toList();
                  //debugPrint(temp.values.toList().toString());
                  listOfWork = temp.values.toList();

                  for (int j = 0; j < listOfWork.length; j++) {
                    listOfWork[j]["workerUID"] = uidTemp[j];
                    listOfWork[j]["date"] = days[i];
                    finalDisplayList.add(listOfWork[j]);
                  }
                  //  debugPrint(listOfWork.toString());

                }
                //debugPrint(finalDisplayList.toString());

                finalDisplayList.sort((a,b) {
                  var adate = a['date']; //before -> var adate = a.expiry;
                  var bdate = b['date']; //before -> var bdate = b.expiry;
                  return adate.compareTo(bdate); //to get the order other way just switch `adate & bdate`
                  });
              }
              return new GroupedListView<dynamic, String>(
                groupBy: (element) => element['date'],
                elements: finalDisplayList,
                order: GroupedListOrder.DESC,
                useStickyGroupSeparators: true,
                groupSeparatorBuilder: (String value) => Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.indigo,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                itemBuilder: (c, element) {
                  return Card(
                      elevation: 4.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => WorkDetails(
                              data: element,
                              projectID: projectID,
                            ),
                          );
                        },
                        child: Container(
                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            leading: getIcon(element['status']),
                            title: Text(element['workerName']),
                            subtitle: Text(element['status']),
                            trailing: Icon(Icons.arrow_forward),
                          ),
                        ),
                      ));
                },
              );
            } else if (snap.hasData &&
                !snap.hasError &&
                snap.data.snapshot.value == null) {
              return Center(
                child: Text(superText4[3]),
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
              ));
            }
          }),
    );
  }
}
