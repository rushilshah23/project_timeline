//This page is under manager section

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/CreateNewProject/CreateNewProject.dart';
import 'package:project_timeline/CreateNewProject/YourCreatedTasks.dart';
import 'package:project_timeline/ViewAllProjects/ViewAllTasks.dart';


class ViewAllProjects extends StatefulWidget {

  @override
  _ViewAllProjectsState createState() => _ViewAllProjectsState();
}

class _ViewAllProjectsState extends State<ViewAllProjects> {


  final databaseReference = FirebaseDatabase.instance.reference();
  List allProjects=List() ;

  String uid="8YiMHLBnBaNjmr3yPvk8NWvNPmm2";



  @override
  void initState() {
    super.initState();
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
                                  "Project: "+allProjects[index]["projectName"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14,),
                                ),
                                SizedBox(height: 5,),

                                Text(
                                  "Site Address: " +allProjects[index]["siteAddress"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),

                                ),

                                Text(
                                  "Supervisor Name" +": "+allProjects[index]["supervisorName"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),

                                ),

                                Row(
                                  children: <Widget>[

                                    Text(
                                      "Progress" +": "+allProjects[index]["progress"].toString()+"%",
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: TextStyle(fontSize: 14),

                                    ),


                                    SizedBox(width: 10,),

                                    Text(
                                      "Status" +": "+allProjects[index]["status"],
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: TextStyle(fontSize: 14),

                                    ),


                                  ],
                                ),



                              ],

                            )
                        ),

                        Container(
                            margin: EdgeInsets.only(top: 5),
                            child:Column(
                              children: <Widget>[




                                IconButton(
                                  icon: Icon(Icons.arrow_forward_ios),
                                  color: Colors.grey,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => ViewAllTasks(projectID:allProjects[index]["projectID"] ,)),
                                    );

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

        title: Text("All Projects"),
      ),

      body: StreamBuilder(
          stream: databaseReference.child("projects").onValue,
          builder: (context, snap) {
            if (snap.hasData &&
                !snap.hasError &&
                snap.data.snapshot.value != null) {
              Map data = snap.data.snapshot.value;
              allProjects = [];
              data.forEach(
                    (index, data) => allProjects.add({"key": index, ...data}),
              );

//              for (int i = 0; i < allProjects.length; i++) {
//                if(allProjects[i]["managerUID"]==uid)
//                  myCreatedProjects.add(allProjects[i]);
//              }
              return
                new Column(
                  children: <Widget>[


                    new Expanded(
                      child: new ListView.builder(
                        itemCount: allProjects.length,
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
