import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AllTasksSupervisor extends StatefulWidget {
  @override
  _AllTasksSupervisorState createState() => _AllTasksSupervisorState();
}

class _AllTasksSupervisorState extends State<AllTasksSupervisor> {
  final databaseReference = FirebaseDatabase.instance.reference();
  Map taskDataDbRef;
  List allDatesTasks = List();
  List keyList = List();

  Widget allTaskList(int index, allDatesTasks) {
    return Container(
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
                                allDatesTasks["worker2"].toString(),
                            overflow: TextOverflow.clip,
                            maxLines: 3,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          // Container(
                          //     child: creatingList(allDatesTasks[index]["key"])),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ))));
  }

  Widget creatingList(allDatesTasks) {
    return ListView.builder(
      itemCount: allDatesTasks.length,
      itemBuilder: (context, index) {
        return allTaskList(index, allDatesTasks);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: databaseReference.child("projects").child("project1").onValue,
        builder: (context, snap) {
          if (snap.hasData &&
              !snap.hasError &&
              snap.data.snapshot.value != null) {
            Map data = snap.data.snapshot.value;

            allDatesTasks = [];
            // // data.forEach(
            // //   (index, data) => allDatesTasks.add({"key": index, ...data}),
            // // );
            List data2 = data.values.toList();
            debugPrint("data in stream builder" + data2.toString());
            keyList = data.keys.toList();
            debugPrint("data in keys " + keyList.toString());

            // debugPrint(allDatesTasks.toString());
            // allDatesTasks = data.values.toList();
            // debugPrint("testign asjdlajsldjalqsjfaj aslkjf" +
            //     allDatesTasks.toString());
            // for (int i = 0; i < allDatesTasks.length; i++) {
            //   debugPrint(allDatesTasks[i].toString() + "\n");
            // }

            // allDatesTasks2 = allDatesTasks.toList();
            for (int i = 0; i < keyList.length; i++) {
              debugPrint(data[keyList[i]].toString());
            }
            for (int i = 0; i < keyList.length; i++) {
              List temp = data[keyList[i]].toList();

              return Column(
                children: <Widget>[
                  Text("All tasks"),
                  new Expanded(
                    child: ListView.builder(
                      itemCount: data2.length,
                      itemBuilder: (context, index) {
                        return allTaskList(index, data2);
                      },
                    ),
                  ),
                ],
              );
            }
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
