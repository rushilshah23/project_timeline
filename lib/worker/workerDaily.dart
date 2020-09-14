import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class WorkerDaily extends StatefulWidget {
  @override
  _WorkerDailyState createState() => _WorkerDailyState();
}

class _WorkerDailyState extends State<WorkerDaily> {
  var workerID = "8YiMHLBnBaNjmr3yPvk8NWvNPmm2"; //not working
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
        .child("project1")
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
                if (snap.hasData &&
                    !snap.hasError &&
                    snap.data.snapshot.value != null) {
                  Map data = snap.data.snapshot.value;
                  List date = [];
                  data.forEach(
                    (index, data) => date.add({"key": index, ...data}),
                  );
                  return ListView.builder(
                    itemCount: date.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.amber[100],
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
                    child: CircularProgressIndicator(),
                  );
              }),
        ),
      ),
    );
  }
}
