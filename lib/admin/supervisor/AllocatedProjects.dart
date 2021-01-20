import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:project_timeline/languages/setLanguageText.dart';
import 'package:project_timeline/admin/reportGeneration/reportPreviewTesting.dart';
import '../CommonWidgets.dart';
import 'allocProjectDetails.dart';
import 'approveWork/WorkApproveModTabs.dart';
import 'addWorkers.dart';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class YourAllocatedProjects extends StatefulWidget {
  String name, email, mobile, password, uid, userType, assignedProject;
  YourAllocatedProjects(
      {Key key,
      this.name,
      this.email,
      this.mobile,
      this.assignedProject,
      this.userType,
      this.uid})
      : super(key: key);
  @override
  _YourAllocatedProjectsState createState() => _YourAllocatedProjectsState();
}

class _YourAllocatedProjectsState extends State<YourAllocatedProjects> {
  Map allMachinesData;

  final databaseReference = FirebaseDatabase.instance.reference();

  bool allocated = false;
  bool isLoading = true;

  List supervisors = List();

  List machines = [];
  List workers = [];

  List graphPoints = [];
  List allDaysReport = List();
  List allDates = List();
  List allDatesApprovedVolume = [];
  List perDayExcavation = List();
  double approvedVol = 0;

  Map projectData;

  final pdf = pw.Document();
  final DateTime date = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String todaysDate = "12-09-2020";
  final DateFormat formatterForTime = DateFormat('dd-MM-yyyy hh:mm:ss');

  void initState() {
    super.initState();
    loadMachines();
    getProjDetails();
  }

  void loadMachines() async {
    await databaseReference
        .child("masters")
        .child("machineMaster")
        .once()
        .then((snapshot) {
      allMachinesData = snapshot.value;
    });
  }

  getProjDetails() async {
    //debugPrint("----------------"+widget.assignedProject.toString());
    await databaseReference
        .child("projects")
        .child(widget.assignedProject)
        .once()
        .then((DataSnapshot dataSnapshot) {
      //debugPrint(dataSnapshot.value.toString());
      setState(() {
        projectData = dataSnapshot.value;
        machines = projectData["machinesSelected"];

        if (projectData.containsKey("workers")) {
          Map wrks = projectData["workers"];
          workers = wrks.keys.toList();
        }
      });
    });
  }

  Future savePDFOverall() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/overallProgress.pdf");
    file.writeAsBytesSync(pdf.save());
  }

  createOverallPdf() async {
    PdfColor tableHeaderColor = PdfColors.cyan100;
    PdfColor headerColor = PdfColors.cyan600;
    double headerFontSize = 20;
    PdfColor header2Color = PdfColors.grey600;
    double header2FontSize = 18;
    PdfColor textColor = PdfColors.grey600;
    double textFontSize = 17;
    PdfColor text2Color = PdfColors.black;
    double text2FontSize = 15;
    double text3FontSize = 18;

    PdfColor _redColor = PdfColors.grey700;

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Center(
              child: pw.Text(
                  superText[24] + formatterForTime.format(date).toString(),
                  style: pw.TextStyle(
                    color: headerColor,
                    fontSize: 16,
                    // fontWeight: pw.FontWeight.bold,
                  ))),
          pw.SizedBox(height: 25),
          pw.Header(
            level: 0,
            child: pw.Center(
                child: pw.Text(superText[25] + projectData["projectName"],
                    style: pw.TextStyle(
                      color: headerColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 25,
                    ))),
          ),
          pw.Center(
              child: pw.Text(superText[26] + projectData["siteAddress"],
                  style: pw.TextStyle(
                    color: header2Color,
                    fontSize: header2FontSize,
                  ))),
          pw.SizedBox(height: 25),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.end,
                          children: [
                            pw.Text(superText[27],
                                style: pw.TextStyle(
                                  color: textColor,
                                  fontSize: textFontSize,
                                )),
                            pw.Text(projectData["soilType"],
                                style: pw.TextStyle(
                                  color: text2Color,
                                  fontSize: text2FontSize,
                                )),
                          ]),
                      pw.SizedBox(height: 40),
                      pw.Row(children: [
                        pw.Column(children: [
                          pw.Text(superText[28],
                              style: pw.TextStyle(
                                color: textColor,
                                fontSize: textFontSize,
                              )),
                          pw.SizedBox(height: 2),
                          pw.Text(projectData["volumeToBeExcavated"] + " m3",
                              style: pw.TextStyle(
                                color: text2Color,
                                fontSize: text3FontSize,
                              )),
                        ]),
                        pw.SizedBox(width: 40),
                        pw.Column(children: [
                          pw.Text(superText[29],
                              style: pw.TextStyle(
                                color: textColor,
                                fontSize: textFontSize,
                              )),
                          pw.SizedBox(height: 2),
                          pw.Text(
                              projectData["projectDuration"] + superText[30],
                              style: pw.TextStyle(
                                color: text2Color,
                                fontSize: text3FontSize,
                              )),
                        ]),
                      ]),
                      pw.SizedBox(height: 20),
                      // pw.SizedBox(height: 20),
                      pw.Row(
                          // mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
                          children: [
                            pw.Column(children: [
                              pw.Text(superText2[0],
                                  style: pw.TextStyle(
                                    color: textColor,
                                    fontSize: textFontSize,
                                  )),
                              pw.SizedBox(height: 2),
                              pw.Text(
                                  projectData["totalMachineRent"] +
                                      superText2[1],
                                  style: pw.TextStyle(
                                    color: text2Color,
                                    fontSize: text3FontSize,
                                  )),
                            ]),
                            pw.SizedBox(width: 50),
                            pw.Column(children: [
                              pw.Text(superText2[2],
                                  style: pw.TextStyle(
                                    color: textColor,
                                    fontSize: textFontSize,
                                  )),
                              pw.Text(
                                  projectData["totalFuelConsumption"] +
                                      superText2[3],
                                  style: pw.TextStyle(
                                    color: text2Color,
                                    fontSize: text3FontSize,
                                  )),
                            ]),
                          ]),
                      pw.SizedBox(height: 20),
                      pw.Column(children: [
                        pw.Text(superText2[4],
                            style: pw.TextStyle(
                              color: textColor,
                              fontSize: textFontSize,
                            )),
                        pw.Text(projectData["progressPercent"] + " %",
                            style: pw.TextStyle(
                              color: text2Color,
                              fontSize: text3FontSize,
                            )),
                      ]),
                      pw.SizedBox(height: 10),
                      pw.Center(
                        child: pw.Column(children: [
                          pw.Text(superText2[5],
                              style: pw.TextStyle(
                                color: textColor,
                                fontSize: text2FontSize,
                              )),
                          pw.SizedBox(height: 2),
                          pw.Text(projectData["volumeExcavated"] + " m3",
                              style: pw.TextStyle(
                                color: text2Color,
                                fontSize: text3FontSize,
                              )),
                        ]),
                      ),
                    ]),
                pw.Container(
                  width: 130,
                  height: 130,
                  child: pw.Stack(
                    alignment: pw.Alignment.center,
                    fit: pw.StackFit.expand,
                    children: <pw.Widget>[
                      pw.Center(
                        child: pw.Text(
                          (double.parse(projectData["progressPercent"]))
                                  .toString() +
                              '%',
                          style: pw.TextStyle(
                            color: textColor,
                            fontSize: textFontSize,
                          ),
                          textScaleFactor: 1.2,
                        ),
                      ),
                      pw.CircularProgressIndicator(
                        value: double.parse(projectData["progressPercent"]) <
                                100
                            ? double.parse(projectData["progressPercent"]) > 0
                                ? double.parse(projectData["progressPercent"]) /
                                    100
                                : 0
                            : 1,
                        backgroundColor: PdfColors.grey300,
                        color: PdfColors.cyan600,
                        strokeWidth: 10,
                      ),
                    ],
                  ),
                )
              ]),
          pw.SizedBox(height: 25),
          pw.Container(
            height: 300,
            child: pw.Chart(
              grid: pw.CartesianGrid(
                xAxis: pw.FixedAxis.fromStrings(
                  List<String>.generate(
                      graphPoints.length, (index) => graphPoints[index][0]),
                  marginStart: 30,
                  marginEnd: 30,
                  ticks: true,
                ),
                yAxis: pw.FixedAxis(
                  [
                    0,
                    20,
                    40,
                    60,
                    80,
                    100,
                    120,
                    140,
                    160,
                    180,
                    200,
                  ],
                  divisions: true,
                ),
              ),
              datasets: [
                pw.LineDataSet(
                  drawSurface: false,
                  isCurved: true,
                  drawPoints: true,
                  color: PdfColors.cyan,
                  data: List<pw.LineChartValue>.generate(
                    graphPoints.length,
                    (i) {
                      final num v = graphPoints[i][1];
                      return pw.LineChartValue(i.toDouble(), v.toDouble());
                    },
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 25),
          pw.Center(
              child: pw.Text(superText2[6],
                  style: pw.TextStyle(
                    color: textColor,
                    fontSize: textFontSize,
                  ))),
          pw.SizedBox(height: 25),
          pw.Table.fromTextArray(
            context: context,
            headerDecoration: pw.BoxDecoration(
              borderRadius: 2,
              color: tableHeaderColor,
            ),
            border: pw.TableBorder(color: PdfColors.grey400),
            data: <List<String>>[
              <String>[
                superText2[7],
                superText2[8],
              ],
              ...supervisors.map((msg) => [msg["name"], msg["mobile"]])
            ],
          ),
          // ]),
          pw.SizedBox(height: 25),
          pw.ListView.builder(
              itemCount: allDates.length,
              itemBuilder: (context, index) {
                //debugPrint(selectedProjectsAllDaysWorkersList[index][index2].toString());
                return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        height: 20,
                      ),
                      pw.Center(
                          child: pw.Text(superText2[9] + allDates[index],
                              style: pw.TextStyle(
                                color: textColor,
                                fontSize: textFontSize,
                              ))),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Text(
                          superText2[10] +
                              allDatesApprovedVolume[index].toString(),
                          style: pw.TextStyle(
                            color: textColor,
                            fontSize: text2FontSize,
                          )),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Table.fromTextArray(
                          context: context,
                          border: pw.TableBorder(color: PdfColors.grey400),
                          headerDecoration: pw.BoxDecoration(
                            borderRadius: 2,
                            color: tableHeaderColor,
                          ),
                          data: <List<dynamic>>[
                            <String>[
                              superText2[11],
                              superText2[12],
                              superText2[13],
                              superText2[14],
                              superText2[15]
                            ],
                            ...allDaysReport[index].map((msg) => [
                                  msg["workerName"],
                                  msg["hoursWorked"].toString(),
                                  msg["MachineUsed"],
                                  msg["volumeExcavated"].toString(),
                                  msg["status"]
                                ])
                          ]),
                    ]);
              }),
        ];
      },
    ));
  }

  void generateOverallReport() async {
    bool state = false;
    allDaysReport.clear();
    allDates.clear();
    approvedVol = 0;
    allDatesApprovedVolume.clear();
    graphPoints.clear();
    await databaseReference
        .child("projects")
        .child(widget.assignedProject)
        .once()
        .then((DataSnapshot dataSnapshot) {
      projectData = dataSnapshot.value;

      if (projectData.containsKey("progress")) {
        state = true;
        Map supMap = dataSnapshot.value["supervisors"];
        supervisors = supMap.values.toList();

        Map progdata = dataSnapshot.value["progress"];

        var sortedEntries = progdata.entries.toList()
          ..sort((e1, e2) {
            return e2.key.compareTo(e1.key);
          });

        Map data1 = Map();

        for (int i = 0; i < sortedEntries.length; i++)
          data1.putIfAbsent(sortedEntries[i].key, () => sortedEntries[i].value);

        allDates = data1.keys.toList();
        List allDatesData = data1.values.toList();

        allDatesApprovedVolume = List.generate(allDates.length, (i) => 0.0);
        graphPoints = List.generate(allDates.length, (i) => [allDates[i], 0.0]);

        //debugPrint(allDatesData.toString());

        for (int i = 0; i < allDates.length; i++) {
          Map todaysDataMap = allDatesData[i];
          //debugPrint(todaysDataMap.values.toList().toString());
          allDaysReport.add(todaysDataMap.values.toList());
        }

        //debugPrint(allDaysReport.toString());

        for (int i = 0; i < allDaysReport.length; i++) {
          //debugPrint(allDaysReport[i].toString());

          List todaysWorkersDataList = allDaysReport[i];

          for (int j = 0; j < todaysWorkersDataList.length; j++) {
            if (todaysWorkersDataList[j]["status"] == "Accepted") {
              //debugPrint(todaysWorkersDataList[j]["workerName"].toString());
              allDatesApprovedVolume[i] = allDatesApprovedVolume[i] +
                  double.parse(
                      todaysWorkersDataList[j]["volumeExcavated"].toString());
              approvedVol = approvedVol +
                  double.parse(
                      todaysWorkersDataList[j]["volumeExcavated"].toString());

              graphPoints[i][1] = graphPoints[i][1] +
                  double.parse(
                      todaysWorkersDataList[j]["volumeExcavated"].toString());

              //debugPrint("------------"+todaysWorkersDataList[j].toString());

            }

            if (allMachinesData
                .containsKey(todaysWorkersDataList[j]["MachineUsed"])) {
              String machineModel =
                  allMachinesData[todaysWorkersDataList[j]["MachineUsed"]]
                          ["machineName"] +
                      "\n" +
                      allMachinesData[todaysWorkersDataList[j]["MachineUsed"]]
                          ["modelName"];
              allDaysReport[i][j]["MachineUsed"] = machineModel;
            }
          }
        }
      }

      graphPoints.sort((a, b) {
        var adate = a[0]; //before -> var adate = a.expiry;
        var bdate = b[0]; //before -> var bdate = b.expiry;
        return adate.compareTo(
            bdate); //to get the order other way just switch `adate & bdate`
      });

      //debugPrint(allDatesApprovedVolume.toString());
    });

    if (state) {
      await createOverallPdf();
      await savePDFOverall();

      Directory documentDirectory = await getApplicationDocumentsDirectory();
      String documentPath = documentDirectory.path;
      String fullPath = "$documentPath/overallProgress.pdf";

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReportPreviewTesting(path: fullPath),
          ));
    } else
      showToast(superText2[16]);
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint(allocated.toString());

    if (projectData != null) {
      return Scaffold(
        body: StreamBuilder(
            stream: databaseReference
                .child("projects")
                .child(widget.assignedProject)
                .onValue,
            builder: (context, snap) {
              getProjDetails();

              if (snap.hasData &&
                  !snap.hasError &&
                  snap.data.snapshot.value != null) {
                return ListView(
                  children: <Widget>[_myAppBar2(), _body()],
                );
              } else {
                return Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }),
      );
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Widget _myAppBar2() {
    return Container(
      padding: EdgeInsets.only(bottom: 25),
      //height: MediaQuery.of(context).size.height/3.5,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
//        gradient: LinearGradient(
//            colors: [ Colors.orange[200],Colors.orange[400],Colors.orange[600],Colors.orange[800],Colors.deepOrange[600]],
//            begin: Alignment.centerRight,
//            end: Alignment(-1.0,-2.0)
//        ),// Gradient
          gradient: gradients()),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, left: 30),
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
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          projectData["projectName"].toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0),
                        ),
                        Text(
                          projectData["siteAddress"].toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircularPercentIndicator(
                          backgroundColor: Colors.grey[200],
                          radius: MediaQuery.of(context).size.height / 6,
                          lineWidth: 13.0,
                          animation: true,
                          percent: double.parse(
                                      projectData["progressPercent"]) <
                                  100
                              ? double.parse(projectData["progressPercent"]) > 0
                                  ? double.parse(
                                          projectData["progressPercent"]) /
                                      100
                                  : 0
                              : 1,
                          center: new Text(
                            projectData["progressPercent"] + "%",
                            style: new TextStyle(
                                color: Color(0xff93e1ed),
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: Color(0xff93e1ed),
                        ),
                        Text(
                          superText2[17],
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  Widget _body() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(superText[16],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 18)),
                    SizedBox(height: 10),
                    Text(projectData["volumeToBeExcavated"].toString() + " m3",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 12)),
                  ],
                ),
                Container(
                    height: 60,
                    child: VerticalDivider(
                      color: Colors.grey[400],
                      width: 20,
                      thickness: 2,
                    )),
                Column(
                  children: [
                    Text(superText2[18],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 18)),
                    SizedBox(height: 10),
                    Text(machines.length.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 12)),
                  ],
                ),
                Container(
                    height: 60,
                    child: VerticalDivider(
                      color: Colors.grey[400],
                      width: 20,
                      thickness: 2,
                    )),
                Column(
                  children: [
                    Text(superText2[19],
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 18)),
                    SizedBox(height: 10),
                    Text(workers.length.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            fontSize: 12)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 35),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllocProjDetails(
                                  projectDetails: projectData,
                                )),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        padding: EdgeInsets.symmetric(vertical: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.description,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(superText2[20]),
                          ],
                        ),
                      ),
                    )),
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchWorkerPage(
                                  name: widget.name,
                                  email: widget.email,
                                  uid: widget.uid,
                                  assignedProject: widget.assignedProject,
                                  mobile: widget.mobile,
                                  userType: widget.userType,
                                )),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        padding: EdgeInsets.symmetric(vertical: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(superText2[21]),
                          ],
                        ),
                      ),
                    )),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WorkApproveModTabs(
                            name: widget.name,
                            email: widget.email,
                            uid: widget.uid,
                            assignedProject: widget.assignedProject,
                            mobile: widget.mobile,
                            userType: widget.userType,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        padding: EdgeInsets.symmetric(vertical: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(superText2[22]),
                          ],
                        ),
                      ),
                    )),
                GestureDetector(
                    onTap: () {
                      generateOverallReport();
                    },
                    child: Card(
                      elevation: 2,
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2 - 30,
                        padding: EdgeInsets.symmetric(vertical: 35),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.insert_drive_file,
                              size: 50,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 10),
                            Text(superText2[23]),
                          ],
                        ),
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
