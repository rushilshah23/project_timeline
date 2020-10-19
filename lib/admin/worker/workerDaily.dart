import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
                if (!snap.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snap.hasData &&
                    !snap.hasError &&
                    snap.data.snapshot.value != null) {
                  Map data = snap.data.snapshot.value;
                  List date = [];
                  data.forEach(
                    (index, data) => date.add({"key": index, ...data}),
                  );
                  print(data);
                  return ListView.builder(
                    itemCount: date.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Color(0xff93e1ed),
                        elevation: 3,
                        child: ListTile(
                          leading: getIcon(date[index][workerID]["status"]),
                          title: Text(date[index]["key"]),
                          subtitle: Text(date[index][workerID]["status"]),
                          onTap: () {
                            print(date[index]["key"]);
                          },
                        ),
                      );
                    },
                  );
                } else
                  return Center(
                    child: Text("No Data Found"),
                  );
              }),
        ),
      ),
    );
  }
}
