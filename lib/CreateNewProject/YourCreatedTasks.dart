//This page is under manager section

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/CreateNewProject/CreateNewTask.dart';
import 'package:project_timeline/CreateNewProject/YourCreatedProjects.dart';

class YourCreatedTasks extends StatefulWidget {

  final String projectID;
  YourCreatedTasks({Key key, this.projectID}) : super(key: key);



  @override
  _YourCreatedTasksState createState() => _YourCreatedTasksState();
}

class _YourCreatedTasksState extends State<YourCreatedTasks> {


  final databaseReference = FirebaseDatabase.instance.reference();
  List allTasks;
  Map allTasksMap = Map();
  String uid="8YiMHLBnBaNjmr3yPvk8NWvNPmm2";

  // Get json result and convert it to model. Then add
  Future<List> getCreatedTasks() async {


    databaseReference.child("projects").child(widget.projectID).child("tasks").once().then((DataSnapshot snapshot) {


      allTasksMap = snapshot.value;

      setState(() {
        allTasks = allTasksMap.values.toList();
      });



    }).catchError((onError) {
      debugPrint(onError.toString());
    });
    return allTasks;

  }


  @override
  void initState() {
    super.initState();
    getCreatedTasks();
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
                                  icon: Icon(Icons.edit),
                                  color: Colors.grey,
                                  onPressed: () {},
                                ),

                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.grey,
                                  onPressed: () {},
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

          title: Text("Your Created Tasks"),
        ),

        body:
        FutureBuilder(
            future: getCreatedTasks(),
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {

                allTasks=allTasks;
                return
        new Column(
          children: <Widget>[


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

            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (_) => CreateNewTask(projectID: widget.projectID,),
                );
              },
              child: Icon(Icons.add),
            ),

    );
  }

}
