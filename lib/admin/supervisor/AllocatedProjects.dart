import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../CommonWidgets.dart';
import 'approveWork/WorkApproveModTabs.dart';
import 'addWorkers.dart';






class YourAllocatedProjects extends StatefulWidget {
  String name , email,  mobile , password,uid, userType,assignedProject;
  YourAllocatedProjects({Key key, this.name, this.email, this.mobile, this.assignedProject, this.userType, this.uid}) : super(key: key);
  @override
  _YourAllocatedProjectsState createState() => _YourAllocatedProjectsState();
}

class _YourAllocatedProjectsState extends State<YourAllocatedProjects> {

  double percent = 10;
  double percent1 = 10;
  Map projectDetails;
  double percent2 = 80;

  final databaseReference = FirebaseDatabase.instance.reference().child("projects");

  bool allocated= false;
  bool isLoading= true;

  void initState(){
    super.initState();
    getProjDetails();
  }


  getProjDetails()
  {
    debugPrint("----------------"+widget.assignedProject.toString());
    try {
      if(widget.assignedProject!="No project assigned"|| widget.assignedProject!='' )
      {
        databaseReference.child(widget.assignedProject).once().then((
            DataSnapshot dataSnapshot) {
          debugPrint(dataSnapshot.value.toString());
          setState(() {
            projectDetails = dataSnapshot.value;
            allocated=true;
            isLoading=false;
          });
        });
      }
      else
        setState(() {
          allocated=false;
          isLoading=true;
        });
    }
    catch(e)
    {
      debugPrint(e.toString());
      setState(() {
        allocated=false;
        isLoading=true;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    debugPrint(allocated.toString());

    if (isLoading == false)
    {
      if (allocated == true) {
        if (projectDetails != null) {
          return Scaffold(

              body: ListView(
                children: <Widget>[
                  _myAppBar2(),
                  _body()
                ],
              )
          );
        }

      }
      else {
        return Scaffold(
          body: Center(
            child: Text("You've not been assigned\nto any project"),),
        );
      }
    }else{

      return Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );

    }

  }

  Widget _myAppBar2() {
    return Container(
      height: MediaQuery.of(context).size.height/3.5,
      width: MediaQuery
          .of(context)
          .size
          .width,
      decoration: BoxDecoration(
//        gradient: LinearGradient(
//            colors: [ Colors.orange[200],Colors.orange[400],Colors.orange[600],Colors.orange[800],Colors.deepOrange[600]],
//            begin: Alignment.centerRight,
//            end: Alignment(-1.0,-2.0)
//        ),// Gradient
          gradient: gradients()

      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5,left: 30),
        child: Container(

            child: Column(
              children: [
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[

                    SizedBox(width: 15),
                    Expanded(
                      flex: 5,
                      child:Container(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              projectDetails["projectName"].toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18.0
                              ),
                            ),
                            Text(
                              projectDetails["siteAddress"].toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14.0
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 5,
                      child:Container(
                        child:Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircularPercentIndicator(
                              backgroundColor: Colors.grey[200],
                              radius: 120.0,
                              lineWidth: 13.0,
                              animation: true,
                              percent: double.parse("70") / 100,
                              center: new Text(
                                "70" + "%",
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20.0),
                              ),
                              circularStrokeCap: CircularStrokeCap.round,
                              progressColor: Color(0xff93e1ed),
                            ),
                            Text(
                              'Project Completion',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            )
        ),
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0,left: 20,right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                        'Goals',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 18
                        )
                    ),
                    SizedBox(height: 10),
                    Text(
                        projectDetails["volumeToBeExcavated"].toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 12
                        )
                    ),
                  ],
                ),
                Container(height: 60, child: VerticalDivider(color: Colors.grey[400],width: 20,thickness: 2,)),
                Column(
                  children: [
                    Text(
                        'Machines',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 18
                        )
                    ),
                    SizedBox(height: 10),
                    Text(
                        "2",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 12
                        )
                    ),

                  ],
                ),
                Container(height: 60, child: VerticalDivider(color: Colors.grey[400],width: 20,thickness: 2,)),
                Column(
                  children: [
                    Text(
                        'Workers',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 18
                        )
                    ),
                    SizedBox(height: 10),
                    Text(
                        '4',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 12
                        )
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 35),


            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: (){

                    },
                    child:Card(
                      child:Container(
                          height: MediaQuery.of(context).size.height/5,
                          width: MediaQuery.of(context).size.width/2.5,
                          padding: EdgeInsets.only(top: 10),
                          child:ListView(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.description,size: 50, color: Colors.grey,),
                                  SizedBox(height:10),
                                  Text("Project Details"),
                                ],
                              ),
                            ],
                          )
                      ),
                    )),

                GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchWorkerPage(name: widget.name,email: widget.email, uid: widget.uid,
                              assignedProject: widget.assignedProject,mobile: widget.mobile,userType: widget.userType,)),
                      );
                    },
                    child:Card(
                      child:Container(
                          height: MediaQuery.of(context).size.height/5,
                          width: MediaQuery.of(context).size.width/2.5,
                          padding: EdgeInsets.only(top: 10),
                          child:ListView(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.people,size: 50, color: Colors.grey,),
                                  SizedBox(height:10),
                                  Text("Add Workers"),
                                ],
                              ),
                            ],
                          )

                      ),
                    )),

              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  WorkApproveModTabs(name: widget.name,email: widget.email, uid: widget.uid,
                            assignedProject: widget.assignedProject,mobile: widget.mobile,userType: widget.userType,),),
                      );
                    },
                    child: Card(
                      child:Container(
                          height: MediaQuery.of(context).size.height/5,
                          width: MediaQuery.of(context).size.width/2.5,
                          padding: EdgeInsets.only(top: 10),
                          child:ListView(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle_outline,size: 50, color: Colors.grey,),
                                  SizedBox(height:10),
                                  Text("Approve Work"),
                                ],
                              ),
                            ],
                          )

                      ),
                    )),

                GestureDetector(
                    onTap: (){

                    },
                    child:Card(
                      child:Container(
                          height: MediaQuery.of(context).size.height/5,
                          width: MediaQuery.of(context).size.width/2.5,
                          padding: EdgeInsets.only(top: 10),
                          child:ListView(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.insert_drive_file,size: 50, color: Colors.grey,),
                                  SizedBox(height:10),
                                  Text("Today's Report"),
                                ],
                              ),
                            ],
                          )

                      ),
                    )),

              ],
            ),


            // SizedBox(height: 70),
            // Center(
            //   child: FlatButton(
            //     child: Container(
            //       height: 50,
            //       width: double.infinity,
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.all(Radius.circular(5.0)),
            //         gradient: LinearGradient(
            //             colors: [ Colors.orange[200],Colors.orange[400],Colors.orange[600],Colors.orange[800],Colors.deepOrange[600]],
            //             begin: Alignment.centerRight,
            //             end: Alignment(-1.0,-2.0)
            //         ), //Gradient
            //       ),
            //       child: Center(
            //
            //         child: Text(
            //           'Our Projects',
            //           style: TextStyle(
            //               color: Colors.white,
            //               fontWeight: FontWeight.bold
            //           ),
            //         ),
            //       ),
            //     ),
            //     // child: buttonContainers(double.infinity, 20, 'Our Projects', 18),
            //     onPressed: () {},
            //   ),
            // )
          ],
        ),
      ),
    );
  }

}