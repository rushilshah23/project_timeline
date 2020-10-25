import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/admin/ProgressTimeLine/theme.dart';
import 'package:project_timeline/crowdfunding/ApiRazorPay.dart';

class AllocProjDetails extends StatefulWidget {
  Map projectDetails;
  AllocProjDetails({this.projectDetails});

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<AllocProjDetails> {
  List supervisors = List();
  List workers = List();
  List images = List();
  List machines = List();
   List machinesNameModel = List();
  int w, s;

  final databaseReference = FirebaseDatabase.instance.reference();
    Map allMachinesData;
  
  void loadMachines() async {
    machinesNameModel.clear();
    machines.clear();


    machines = widget.projectDetails["machinesSelected"];

     debugPrint(machines.toString());
    await databaseReference
        .child("masters")
        .child("machineMaster")
        .once()
        .then((snapshot) {
      allMachinesData=snapshot.value;
    });


    for(int i=0;i<machines.length;i++)
    {
          if(allMachinesData.containsKey(machines[i]["machineID"]))
          {
            String machineModel=allMachinesData[machines[i]["machineID"]]["machineName"]+"\n"+allMachinesData[machines[i]["machineID"]]["modelName"];
            machinesNameModel.add({"machineName":machineModel,"usagePerDay":machines[i]["usagePerDay"]});

          }

    }

    debugPrint("----------------"+machinesNameModel.toString());
  }

  @override
  void initState() {
    super.initState();
    loadMachines();
    images = widget.projectDetails["approvedImages"];
    
    ////debugPrint(images.toString());

    if (images == null) {
      setState(() {
        images = [];
        images.length = 0;
      });
    }

    try {
      Map supervisorsMap = widget.projectDetails["supervisors"];
      supervisors = supervisorsMap.values.toList();
      //debugPrint(supervisors.toString());
    } catch (e) {
      setState(() {
        supervisors.length = 0;
      });
    }
    try {
      Map workersMap = widget.projectDetails["workers"];
      workers = workersMap.values.toList();
      //////debugPrint(workers.toString());
    } catch (e) {
      setState(() {
        workers.length = 0;
      });
    }



    
     
  }

  Widget buildGridView() {
    return Container(
        height: MediaQuery.of(context).size.height / 4,
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            return Container(
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return PhotoView(
                          imageProvider: NetworkImage(images[index]),
                        );
                      }));
                    },
                    child: Card(
                      child: Image.network(images[index]),
                    ))); //
          }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ThemeAppbar("Our Project", context),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        CircularPercentIndicator(
                          backgroundColor: Colors.grey[200],
                          radius: 140.0,
                          lineWidth: 10.0,
                          animation: true,
                          percent: double.parse(widget
                                  .projectDetails["progressPercent"]
                                  .toString()) /
                              100,
                          center: new Text(
                            widget.projectDetails["progressPercent"]
                                    .toString() +
                                "%",
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Colors.indigo[500],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Project Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                              color: Colors.indigo[300],
                              fontStyle: FontStyle.italic,
                            )),
                        SizedBox(height: 8),
                        Text(
                          widget.projectDetails["projectName"].toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text('Duration',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.indigo[300],
                                      fontStyle: FontStyle.italic,
                                    )),
                                SizedBox(height: 8),
                                Text(
                                  widget.projectDetails["projectDuration"]
                                          .toString() +
                                      " days",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            Container(
                                child: VerticalDivider(
                              color: Colors.grey[400],
                              width: 30,
                              thickness: 1,
                            )),
                            Column(
                              children: [
                                Text('Excavation',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.indigo[300],
                                      fontStyle: FontStyle.italic,
                                    )),
                                SizedBox(height: 8),
                                Text(
                                  widget.projectDetails["volumeExcavated"]
                                          .toString() +
                                      " m3",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text('Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.indigo[300],
                                      fontStyle: FontStyle.italic,
                                    )),
                                SizedBox(height: 8),
                                Text(
                                  widget.projectDetails["projectStatus"]
                                      .toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            ),
                            Container(
                                child: VerticalDivider(
                              color: Colors.grey[400],
                              width: 30,
                              thickness: 1,
                            )),
                            Column(
                              children: [
                                Text('Goals',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.indigo[300],
                                      fontStyle: FontStyle.italic,
                                    )),
                                SizedBox(height: 8),
                                Text(
                                  widget.projectDetails["volumeToBeExcavated"]
                                          .toString() +
                                      " m3",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),

                Text('Site Address',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.indigo[300],
                      fontStyle: FontStyle.italic,
                    )),


                Container(
                  width: MediaQuery.of(context).size.width-50,
                  child: Text(
                    widget.projectDetails["siteAddress"].toString(),
                    overflow: TextOverflow.visible,
                    maxLines: 5,
                    softWrap: true,
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                ),
                SizedBox(height: 10),
                // Text(
                //     'Soil Type',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 18,
                //       color: Colors.indigo[300],
                //       fontStyle: FontStyle.italic,
                //     )
                // ),
                // Text(
                //   widget.projectDetails["soilType"].toString(),
                //   style: TextStyle(
                //       fontSize: 15,
                //       fontWeight: FontWeight.w500,
                //       color: Colors.black
                //   ),
                // ),

                Text('Machines Provided',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.indigo[300],
                      fontStyle: FontStyle.italic,
                    )),

                Container(
                    child: Column( 
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(machinesNameModel.length, (index) {
                        return   Container(
                          margin: EdgeInsets.only(top:10,bottom:10),
                          child:ListTile(  
                            title:Text("Name:  "+ machinesNameModel[index]["machineName"]),
                            subtitle:  Text("Usage/day:  "+ machinesNameModel[index]["usagePerDay"]),
                            ));
                           
                         
                      }),
                  ),
                ),

                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: customShadow),
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3.5,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //SizedBox(height: 10),
                            Text('Our Supervisors',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.indigo[300],
                                  fontStyle: FontStyle.italic,
                                )),
                            Container(
                              height: MediaQuery.of(context).size.height / 4,
                              width: 150,
                              child: new ListView.builder(
                                itemCount: supervisors.length,
                                itemBuilder: (context, index) {
                                  s = index + 1;
                                  return Text(
                                      "$s.  " +
                                          supervisors[index]["name"].toString(),
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ));
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(
                            child: VerticalDivider(
                          color: Colors.grey[400],
                          width: 30,
                          thickness: 1,
                        )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Our Workers',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.indigo[300],
                                  fontStyle: FontStyle.italic,
                                )),
                            Container(
                              height: MediaQuery.of(context).size.height / 4,
                              width: 150,
                              child: new ListView.builder(
                                itemCount: workers.length,
                                itemBuilder: (context, index) {
                                  w = index + 1;
                                  return Text(
                                      "$w.  " +
                                          workers[index]["name"].toString(),
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      ));
                                },
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Text('Images',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.indigo[300],
                      fontStyle: FontStyle.italic,
                    )),

                buildGridView(),

                SizedBox(
                  height: 20,
                ),

                // FlatButton(
                //   child: buttonContainers(double.infinity, 20, 'Donate', 18),
                //   onPressed: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => ApiRazorPay(widget
                //                 .projectDetails["projectName"]
                //                 .toString())));
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}