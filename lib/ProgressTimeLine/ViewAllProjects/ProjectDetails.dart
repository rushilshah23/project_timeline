import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project_timeline/ProgressTimeLine/theme.dart';

class ProjectDetails extends StatefulWidget {
  Map projectDetails;
  ProjectDetails({this.projectDetails});

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}



class _ProjectDetailsState extends State<ProjectDetails> {

  List supervisors=[];
  List workers=[];
  int w,s;
  @override
  void initState() {
    super.initState();
    Map supervisorsMap= widget.projectDetails["supervisors"];
    supervisors= supervisorsMap.values.toList();
    debugPrint(supervisors.toString());


    Map workersMap= widget.projectDetails["workers"];
    workers= workersMap.values.toList();
    debugPrint(workers.toString());

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                          percent: double.parse(widget.projectDetails["progressPercent"].toString()) / 100,
                          center: new Text(
                            widget.projectDetails["progressPercent"].toString() + "%",
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
                        Text(
                            'Project Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                              color: Colors.indigo[300],
                              fontStyle: FontStyle.italic,
                            )
                        ),
                        SizedBox(height: 8),
                        Text(
                            widget.projectDetails["projectName"].toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: Colors.black
                          ),
                        ),
                        SizedBox(height: 30),
                        Row(
                          children: [
                            Column(
                              children: [
                                Text(
                                    'Duration',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.indigo[300],
                                      fontStyle: FontStyle.italic,
                                    )
                                ),
                                SizedBox(height: 8),
                                Text(
                                    widget.projectDetails["projectDuration"].toString()+" days",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                  ),
                                )
                              ],
                            ),
                            Container(child: VerticalDivider(color: Colors.grey[400],width: 30,thickness: 1,)),
                            Column(
                              children: [
                                Text(
                                    'Excavation',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.indigo[300],
                                      fontStyle: FontStyle.italic,
                                    )
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.projectDetails["volumeExcavated"].toString()+" m3",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                  ),
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
                                Text(
                                    'Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.indigo[300],
                                      fontStyle: FontStyle.italic,
                                    )
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.projectDetails["projectStatus"].toString(),
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                  ),
                                )
                              ],
                            ),
                            Container(child: VerticalDivider(color: Colors.grey[400],width: 30,thickness: 1,)),
                            Column(
                              children: [
                                Text(
                                    'Goals',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.indigo[300],
                                      fontStyle: FontStyle.italic,
                                    )
                                ),
                                SizedBox(height: 8),
                                Text(
                                  widget.projectDetails["volumeToBeExcavated"].toString()+" m3",
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 40),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white70,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: customShadow
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Site Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.indigo[300],
                                  fontStyle: FontStyle.italic,
                                )
                            ),
                            Container(
                              width: 160,
                              child: Text(
                                widget.projectDetails["siteAddress"].toString(),
                                overflow: TextOverflow.visible,
                                softWrap: true,
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                                'Soil Type',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.indigo[300],
                                  fontStyle: FontStyle.italic,
                                )
                            ),
                            Text(
                                widget.projectDetails["soilType"].toString(),
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                                'Supervisors Selected',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.indigo[300],
                                  fontStyle: FontStyle.italic,
                                )
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height/6,
                              width: 150,
                              child:   new ListView.builder(
                                itemCount: supervisors.length,
                                itemBuilder: (context, index) {
                                  s = index + 1;
                                  return Text(
                                      "$s.  "+supervisors[index]["name"].toString(),
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      )
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Container(child: VerticalDivider(color: Colors.grey[400],width: 30,thickness: 1,)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Workers Selected',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.indigo[300],
                                  fontStyle: FontStyle.italic,
                                )
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height/3,
                              width: 150,
                              child:   new ListView.builder(
                                itemCount: workers.length,
                                itemBuilder: (context, index) {
                                  w = index + 1;
                                  return Text("$w.  "+workers[index]["name"].toString(),
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                      )
                                  );
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
                Text(
                    'Images',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.indigo[300],
                      fontStyle: FontStyle.italic,
                    )
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
