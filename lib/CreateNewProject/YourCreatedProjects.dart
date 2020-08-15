//This page is under manager section

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'YourCreatedTasks.dart';

class YourCreatedProjects extends StatefulWidget {

  @override
  _YourCreatedProjectsState createState() => _YourCreatedProjectsState();
}

class _YourCreatedProjectsState extends State<YourCreatedProjects> {


  final databaseReference = FirebaseDatabase.instance.reference();
  List myCreatedProjects=List() ;
  List allProjects =List();
  Map allProjectsMap = Map();
  String uid="8YiMHLBnBaNjmr3yPvk8NWvNPmm2";

  // Get json result and convert it to model. Then add
  Future<List> getCreatedProjects() async {

    databaseReference.child("projects").once().then((DataSnapshot snapshot) {

      allProjects.clear();
      myCreatedProjects.clear();
      allProjectsMap = snapshot.value;
      allProjects = allProjectsMap.values.toList();



      for (int i = 0; i < allProjects.length; i++) {
        if(allProjects[i]["managerUID"]==uid)
          myCreatedProjects.add(allProjects[i]);
      }
      setState(() {
        myCreatedProjects = myCreatedProjects;
      });

     // debugPrint(myCreatedProjects.toString());

    }).catchError((onError) {
      debugPrint(onError.toString());
    });
    return myCreatedProjects;

  }


  @override
  void initState() {
    super.initState();
    getCreatedProjects();
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
                                  "Project: "+myCreatedProjects[index]["projectName"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14,),
                                ),
                                SizedBox(height: 5,),

                                Text(
                                  "Site Address: " +myCreatedProjects[index]["siteAddress"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),

                                ),

                                Text(
                                  "Supervisor Name" +": "+myCreatedProjects[index]["supervisorName"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(fontSize: 14),

                                ),

                                Row(
                                  children: <Widget>[

                                    Text(
                                      "Progress" +": "+myCreatedProjects[index]["progress"].toString()+"%",
                                      overflow: TextOverflow.clip,
                                      maxLines: 2,
                                      softWrap: false,
                                      style: TextStyle(fontSize: 14),

                                    ),


                                    SizedBox(width: 10,),

                                    Text(
                                      "Status" +": "+myCreatedProjects[index]["status"],
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

                                IconButton(
                                  icon: Icon(Icons.add_box),
                                  color: Colors.grey,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => YourCreatedTasks(projectID:myCreatedProjects[index]["projectID"] ,)),
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

          title: Text("Your Created Projects"),
        ),

        body:
        FutureBuilder(
            future: getCreatedProjects(),
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              if (snapshot.hasData) {

                myCreatedProjects=myCreatedProjects;
                return
                  new Column(
                  children: <Widget>[


                    new Expanded(
                      child: new ListView.builder(
                        itemCount: myCreatedProjects.length,
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
            })
    );
  }

}
