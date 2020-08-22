//This page is under manager section
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';


import '../theme.dart';
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
        debugPrint(temp[0]["taskDescription"]);
        debugPrint(temp[0]["taskID"]);

      });

    });

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

            elevation: 7,
            margin: EdgeInsets.only(left:15 ,right:15 ,top: 15,bottom: 7),
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

                                LinearPercentIndicator(
                                  percent: double.parse(allTasks[index]["progress"].toString())/100,
                                  center: Text(allTasks[index]["progress"].toString()+"%"),
                                  progressColor: Colors.green,
                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                  animationDuration: 5000,
                                  lineHeight: 20,
                                  animation: true,

                                ),


                                Center(
                                  child: Text(
                                    "Progress" +": "+allTasks[index]["progress"].toString()+"%",
                                    overflow: TextOverflow.clip,
                                    maxLines: 2,
                                    softWrap: false,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic
                                    ),

                                  ),
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  "task Name: "+allTasks[index]["taskName"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                  softWrap: false,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    color: Colors.redAccent
                                  ),
                                ),


                                SizedBox(width: 10,),

                                Text(
                                  "Status" +": "+allTasks[index]["status"],
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  softWrap: false,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold
                                  ),

                                ),


                              ],

                            )
                        ),



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
      backgroundColor: primaryColor,

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
              return new Column(
                  children: [
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.navigate_before,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    Container(
                      height: 100,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TASKS',
                            style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Project Name" +": "+projectName,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              color: Colors.indigo[900]
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 30,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Site Address" +": "+siteAddress,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo[900]
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
                        ),
                        child: new ListView.builder(
                          itemCount: allTasks.length,
                          itemBuilder: (context, index) {
                            return displayProject(index);
                          },
                        ),
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
