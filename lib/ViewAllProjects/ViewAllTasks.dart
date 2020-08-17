//This page is under manager section

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/CommonWidgets.dart';
import 'package:project_timeline/CreateNewProject/CreateNewTask.dart';
import 'package:project_timeline/CreateNewProject/EditTask.dart';
import 'package:project_timeline/CreateNewProject/YourCreatedProjects.dart';

class ViewAllTasks extends StatefulWidget {

  final String projectID;
  ViewAllTasks({Key key, this.projectID}) : super(key: key);

  @override
  _ViewAllTasksState createState() => _ViewAllTasksState();
}

class _ViewAllTasksState extends State<ViewAllTasks> {


  final databaseReference = FirebaseDatabase.instance.reference();
  List allTasks;
  String projectName,siteAddress;
  String uid="8YiMHLBnBaNjmr3yPvk8NWvNPmm2";

  // Get json result and convert it to model. Then add
  getProjectDetails() async {

    databaseReference.child("projects").child(widget.projectID).once().then((DataSnapshot snapshot) {
      setState(() {
        projectName= snapshot.value["projectName"].toString();
        siteAddress= snapshot.value["siteAddress"].toString();


        Map alltasks= snapshot.value["tasks"];

        debugPrint(alltasks.values.toList().toString());
        List temp=alltasks.values.toList();
        debugPrint(temp[0]["taskName"]);
        debugPrint(temp[0]["status"]);

      });

    });

  }

  deleteTask(String taskID)
  {
    try {
      databaseReference.child("projects").child(widget.projectID)
          .child("tasks")
          .child(taskID)
          .remove();
      showToast("Removed Sucessfully");
    }
    catch(e){
      showToast("Check your internet");
    }
  }


  @override
  void initState() {
    super.initState();
    getProjectDetails();
  }


  Widget displayProject(int index)
  {
    return Container(


        child: Card(

            elevation: 4,
            margin: EdgeInsets.only(left:15 ,right:15 ,top: 7,bottom: 7),
            semanticContainer: true,
            color: Colors.amberAccent.shade50,

            child: Container(
                child:Column(
                  children: <Widget>[

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,

                      children: <Widget>[

                        Container(

                            width: MediaQuery.of(context).size.width/1.4,

                            padding: EdgeInsets.all(5),
                            child:Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: <Widget>[



                                Text(
                                  "task Name: "+allTasks[index]["taskName"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14,),
                                ),
                                SizedBox(height: 5,),


                                Text(
                                  "Progress" +": "+allTasks[index]["progress"].toString()+"%",
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),

                                ),


                                SizedBox(width: 10,),

                                Text(
                                  "Status" +": "+allTasks[index]["status"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),

                                ),



                              ],

                            )
                        ),

                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child:Column(
                              children: <Widget>[


                                SizedBox(width: 10,),


                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  color: Colors.grey,
                                  onPressed: () {

                                  },
                                ),




                              ],
                            )
                        )

                      ],
                    )
                  ],
                )
            )
        )
    );
  }



  @override
  Widget build(BuildContext context) {
    return new Scaffold(

      appBar: AppBar(

        title: Text("View All Tasks"),
      ),

      body: StreamBuilder(
          stream: databaseReference.child("projects").child(widget.projectID).child("tasks").onValue,
          builder: (context, snap) {
            if (snap.hasData &&
                !snap.hasError &&
                snap.data.snapshot.value != null) {
              Map data = snap.data.snapshot.value;
              allTasks = [];
              data.forEach(
                    (index, data) => allTasks.add({"key": index, ...data}),
              );



              return
                new Column(
                  children: <Widget>[



                    Container(
                        margin: EdgeInsets.only(left:15 ,right:15 ,top: 7,bottom: 7),
                        color: Colors.amberAccent.shade50,
                        child:Column(children: <Widget>[
                          Text(
                            "Project Name" +": "+projectName,
                            style: TextStyle(fontSize: 18),

                          ),
                          SizedBox(height: 10,),

                          Text(
                            "Site Address" +": "+siteAddress,
                            style: TextStyle(fontSize: 16),

                          ),
                        ],)
                    ),



                    new Expanded(
                      child: new ListView.builder(
                        itemCount: allTasks.length,
                        itemBuilder: (context, index) {
                          return displayProject(index);
                        },
                      ),
                    ),
                  ],

                );
            } else {
              return Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),));
            }
          }),



    );
  }

}
