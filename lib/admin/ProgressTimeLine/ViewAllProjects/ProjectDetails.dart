import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:photo_view/photo_view.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/admin/ProgressTimeLine/theme.dart';
import 'package:project_timeline/crowdfunding/ApiRazorPay.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feedbackDetails.dart';

class ProjectDetails extends StatefulWidget {
  Map projectDetails;
  ProjectDetails({this.projectDetails});

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  List supervisors = List();
  List workers = List();
  List images = List();
  int w, s;
  bool isUser = false;
  List feedbackList = List();
  int feebackDisplayLimit=1;

  @override
  void initState() {
    super.initState();

    _loadData();
    images = widget.projectDetails["approvedImages"];
    ////debugPrint(images.toString());
    ///

    if(widget.projectDetails.containsKey("localFeedback"))
    {
    Map feedback = widget.projectDetails["localFeedback"];
    setState(() {
      feedbackList = feedback.values.toList();
    });
    }

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


  seeMoreFeedback()
  {
      if((feebackDisplayLimit +2)<=feedbackList.length)
      {
          setState(() {
            feebackDisplayLimit=feebackDisplayLimit+2;
          });
      }
      else if((feebackDisplayLimit +1)<=feedbackList.length)
      {
          setState(() {
            feebackDisplayLimit=feebackDisplayLimit+1;
          });
      }
      else showToast("No more feedback");
  }

  _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isUser = (prefs.getBool('isLoggedIn') ?? false);
    });
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
        padding: const EdgeInsets.only(right: 20.0, left: 20),
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
                                      .projectDetails["progressPercent"]) <
                                  100
                              ? double.parse(widget
                                          .projectDetails["progressPercent"]) >
                                      0
                                  ? double.parse(widget
                                          .projectDetails["progressPercent"]) /
                                      100
                                  : 0
                              : 1,
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
                        SizedBox(height: 8),
                        Text('Project Name',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 21,
                              color: Color(0xff005c9d),
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
                                      color: Color(0xff005c9d),
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
                                      color: Color(0xff005c9d),
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
                                      color: Color(0xff005c9d),
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
                                      color: Color(0xff005c9d),
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
                      color: Color(0xff005c9d),
                      fontStyle: FontStyle.italic,
                    )),
                Container(
                  // width: 160,
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
                // Text(
                //     'Soil Type',
                //     style: TextStyle(
                //       fontWeight: FontWeight.bold,
                //       fontSize: 18,
                //       color: Color(0xff005c9d),
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
                SizedBox(height: 20),
                isUser
                    ? Container(
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
                                        color: Color(0xff005c9d),
                                        fontStyle: FontStyle.italic,
                                      )),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    width: 150,
                                    child: new ListView.builder(
                                      itemCount: supervisors.length,
                                      itemBuilder: (context, index) {
                                        s = index + 1;
                                        return Text(
                                            "$s.  " +
                                                supervisors[index]["name"]
                                                    .toString(),
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
                                        color: Color(0xff005c9d),
                                        fontStyle: FontStyle.italic,
                                      )),
                                  Container(
                                    height:
                                        MediaQuery.of(context).size.height / 4,
                                    width: 150,
                                    child: new ListView.builder(
                                      itemCount: workers.length,
                                      itemBuilder: (context, index) {
                                        w = index + 1;
                                        return Text(
                                            "$w.  " +
                                                workers[index]["name"]
                                                    .toString(),
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
                      )
                    : Container(),
                SizedBox(height: 30),
                Text('Images',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xff005c9d),
                      fontStyle: FontStyle.italic,
                    )),

                buildGridView(),

                SizedBox(
                  height: 20,
                ),

                feedbackList.length!=0?Text('Feedback',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xff005c9d),
                      fontStyle: FontStyle.italic,
                    )):Container(),

                feedbackList.length!=0? Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(feebackDisplayLimit, (index) {
                      var keyboard_arrow_right_sharp;
                      return Container(
                        color: Colors.grey.withOpacity(0.1),
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        child: ExpansionTile(
                          title: Text("Name:  " + feedbackList[index]["name"]),
                          subtitle: Text("Time:  " +                   
                              feedbackList[index]["timestamp"] +
                              " hrs"),
                          children: <Widget>[
                            
                            Row(children: <Widget>[
                              Icon(Icons.arrow_right),
                              Flexible(
                                child: Text( feedbackList[index]["feedback"] ,
                                    maxLines: 10,
                                   ),
                              ),
                             
                            ]),
                            SizedBox(height: 10,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                            
                            GestureDetector(
                              onTap:() {
                                 showDialog(
                                  context: context,
                                  builder: (_) => FeedBackDetails(
                                      feedBackData: feedbackList[index]),
                                );  
                              },
                              child:Text("Read More",style: TextStyle(
                                  color: Colors.lightBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold))
                             
                              ),
                              
                               Icon(Icons.keyboard_arrow_right),
                            ]),
                          ],
                        ),
                      );
                    }),
                  ),
                ):Container(),

                   feedbackList.length!=0?GestureDetector(
                              onTap:() {
                                
                                  seeMoreFeedback();
                              },
                              child:Container(
                                margin: EdgeInsets.symmetric(vertical:10),
                                child:Text("See More",style: TextStyle(  
                                  color: Colors.lightBlue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)))
                             
                              ):Container(),

                SizedBox(
                  height: 20,
                ),

                FlatButton(
                  child: buttonContainers(double.infinity, 'Donate', 18),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ApiRazorPay(widget
                                .projectDetails["projectName"]
                                .toString())));
                  },
                ),

                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
