import 'package:flutter/material.dart';
import 'package:project_timeline/worker/workerDaily.dart';
import 'package:project_timeline/worker/workerForm.dart';



class UpdateWork extends StatefulWidget {
  @override
  _UpdateWorkState createState() => _UpdateWorkState();
}

class _UpdateWorkState extends State<UpdateWork> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: new PreferredSize(
            preferredSize: Size.fromHeight(kToolbarHeight),
            child: new Container(
              color: Colors.orange,
              child: new SafeArea(
                child: Column(
                  children: <Widget>[
                    new Expanded(child: new Container()),
                     TabBar(

                      tabs: [
                        Tab(text: "Update",),
                        Tab(text: "Approvals"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          body: TabBarView(
            children: [
              WorkerForm(),
              WorkerDaily(),
            ],
          ),
        ),
      ),
    );
  }
}