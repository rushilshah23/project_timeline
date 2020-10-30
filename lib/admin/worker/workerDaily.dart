import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';

class WorkerDaily extends StatefulWidget {
  String name, email, mobile, password, uid, userType, assignedProject;
  WorkerDaily(
      {Key key,
      this.name,
      this.email,
      this.mobile,
      this.assignedProject,
      this.userType,
      this.uid})
      : super(key: key);
  @override
  _WorkerDailyState createState() => _WorkerDailyState();
}

class _WorkerDailyState extends State<WorkerDaily> {
  var projectID;
  var workerID; //not working

  @override
  void initState() {
    setState(() {
      projectID = widget.assignedProject;
      workerID = widget.uid;
      print(projectID);
      print(workerID);
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
      case "Updated":
        return Icon(Icons.done_all);
      case "Received":
        return Icon(Icons.check_circle);
    }
  }

  @override
  Widget build(BuildContext context) {
    final databaseReference = FirebaseDatabase.instance
        .reference()
        .child("projects")
        .child(projectID)
        .child("progress");

    return Scaffold(
      /*appBar: AppBar(
        title: Text("Daily Update"),
      ),*/
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(10),
          child: StreamBuilder(
              stream: databaseReference.onValue,
              builder: (context, snap) {
                print('aaaa');
                if (!snap.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snap.hasData &&
                    !snap.hasError &&
                    snap.data == null) {
                  return Center(
                    child: Text("No data found"),
                  );
                } else if (snap.hasData &&
                    !snap.hasError &&
                    snap.data != null) {
                  Map data = snap.data.snapshot.value;
                  List date = [];
                  data.forEach(
                    (index, data) => date.add({"key": index, ...data}),
                  );
                  print(data);
                  if (date[0][workerID] != null) {
                    return ListView.builder(
                      itemCount: date.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Colors.white,
                          elevation: 3,
                          child: ListTile(
                            leading: getIcon(date[index][workerID]["status"]),
                            title: Text(date[index]["key"]),
                            subtitle: Text(date[index][workerID]["status"]),
                            onTap: () {
                              print(date[index][workerID]);
                              showDialog(
                                context: context,
                                builder: (_) => WorkersDetailsDisplay(
                                    data: date[index][workerID]),
                              );
                            },
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: Text("No data found"),
                    );
                  }
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
                  ));
                }
              }),
        ),
      ),
    );
  }
}

class WorkersDetailsDisplay extends StatefulWidget {
  Map data;
  WorkersDetailsDisplay({Key key, this.data});
  @override
  _WorkersDetailsDisplayState createState() => _WorkersDetailsDisplayState();
}

class _WorkersDetailsDisplayState extends State<WorkersDetailsDisplay> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 1.7,
        padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
        child: Form(
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Text("Status: " + widget.data["status"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                      "Hours Worked: " + widget.data["hoursWorked"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Length: " + widget.data["length"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Depth: " + widget.data["depth"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Lower width: " + widget.data["lowerWidth"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Upper width: " + widget.data["upperWidth"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Volume Excavated: " +
                      widget.data["volumeExcavated"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Comment: " + widget.data["comment"].toString()),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
