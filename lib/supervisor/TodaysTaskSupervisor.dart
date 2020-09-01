import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TodaysTaskSupervisor extends StatefulWidget {
  @override
  _TodaysTaskSupervisorState createState() => _TodaysTaskSupervisorState();
}

class _TodaysTaskSupervisorState extends State<TodaysTaskSupervisor> {
  final databaseReference = FirebaseDatabase.instance.reference();
  Map taskDataDbRef;
  List todaysDatesTasks = List();

  var todaysDate;

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('MM-dd-yyyy');

  @override
  void initState() {
    super.initState();

    todaysDate = formatter.format(now);

    databaseReference
        .child("projects")
        .child("project1")
        .once()
        .then((DataSnapshot snapshot) {
      Map alltask = snapshot.value["progress"];
      setState(() {
        taskDataDbRef = alltask;
      });
      debugPrint(taskDataDbRef.toString());
      print(todaysDate);
    });
  }

  Widget allTaskList(int index, todaysDatesTasks) {
    return Container(
        child: GestureDetector(
      dragStartBehavior: DragStartBehavior.start,
      onTap: () {
        debugPrint("Todays task in details");
        // showDialog(context: context, builder: (_) => );
      },
      child: Card(
          elevation: 4,
          margin: EdgeInsets.only(left: 15, right: 15, top: 7, bottom: 7),
          semanticContainer: true,
          color: Colors.amberAccent.shade50,
          child: Container(
              child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.4,
                    padding: EdgeInsets.only(
                        top: 30, bottom: 30, left: 10, right: 10),
                    //padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Machine Used " +
                              todaysDatesTasks[index]["MachineUsed"].toString(),
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ))),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: databaseReference
            .child("projects")
            .child("project1")
            .child("progress")
            .child(todaysDate.toString())
            .onValue,
        builder: (context, snap) {
          if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value != null) {
            Map data = snap.data.snapshot.value;
            todaysDatesTasks = [];
            data.forEach(
              (index, data) => todaysDatesTasks.add({"key": index, ...data}),
            );

            return Column(
              children: <Widget>[
                Text("sdsadsd"),
                new Expanded(
                  child: new ListView.builder(
                    itemCount: todaysDatesTasks.length,
                    itemBuilder: (context, index) {
                      return allTaskList(index, todaysDatesTasks);
                    },
                  ),
                ),
              ],
            );
          } else {
            return Center(
                child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
            ));
          }
        },
      ),
    );
  }
}
