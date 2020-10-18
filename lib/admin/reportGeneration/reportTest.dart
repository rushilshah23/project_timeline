import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';

import 'reportPreviewTesting.dart';


// import '../CommonWidgets.dart';
//
class ReportGenerationTesting extends StatefulWidget {
  @override
  _ReportGenerationTestingState createState() =>
      _ReportGenerationTestingState();
}

class _ReportGenerationTestingState extends State<ReportGenerationTesting> {
  final pdf = pw.Document();

  final databaseReference = FirebaseDatabase.instance.reference();

  final DateTime date = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String todaysDate = "12-09-2020";

  final DateFormat formatterForTime = DateFormat('dd-MM-yyyy hh:mm:ss');

  Map allMachinesData;
  List projects = [];
  List<DropdownMenuItem> projectsDropdwnItems = [];

  String uid = "8YiMHLBnBaNjmr3yPvk8NWvNPmm2";

  String selectedProject;
  List todaysReport = List();
  List supervisors = List();
  Map projectData;
  double approvedVol = 0;

  List allDaysReport = List();
  List allDates = List();
  List allDatesApprovedVolume = [];
  List perDayExcavation = List();

  static const tableHeaders = ['Category', 'Budget', 'Expense', 'Result'];
  static const pi = 22 / 7;
  static const dataTable = [
    ['Phone', 80, 95, -15],
    ['Internet', 250, 230, 20],
    ['Electricity', 300, 375, -75],
    ['Movies', 85, 80, 5],
    ['Food', 300, 350, -50],
    ['Fuel', 650, 550, 100],
    ['Insurance', 250, 310, -60],
  ];

  static const PdfColor tableHeaderColor = PdfColors.blue300;
  static const PdfColor headerColor = PdfColors.grey700;
  static const double headerFontSize = 20;
  static const PdfColor header2Color = PdfColors.grey600;
  static const double header2FontSize = 18;
  static const PdfColor textColor = PdfColors.grey600;
  static const double textFontSize = 17;
  static const PdfColor text2Color = PdfColors.black;
  static const double text2FontSize = 17;
  // static const double text3Color = PdfColors.black;
  static const double text3FontSize = 20;

  static const _darkColor = PdfColors.blueGrey800;
  static const _redColor = PdfColors.grey700;
  static const white = PdfColors.white;

  static final tableHeadersTable = [
    'Supervisor Name',
    'Contact Number',
  ];

  static final tableHeadersTable2 = [
    'Worker Name',
    'Hours Worked',
    'Machine used',
    'Volume Excavated',
    'Approval Status'
  ];
  // const PdfColor green = PdfColor.fromInt(0xff9ce5d0);
  // const PdfColor lightGreen = PdfColor.fromInt(0xffcdf1e7);
  // const sep = 120.0;

  // Future
  // final pw.PageTheme pageTheme = _myPageTheme(format);

  Future savePDF() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/todaysReport.pdf");
    file.writeAsBytesSync(pdf.save());
  }

  Future savePDFOverall() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/overallProgress.pdf");
    file.writeAsBytesSync(pdf.save());
  }

  createTodaysPdf() async {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
            level: 0,
            child: pw.Center(
                child: pw.Text("Project name: " + projectData["projectName"],
                    style: pw.TextStyle(
                      color: headerColor,
                      fontSize: 25,
                      fontWeight: pw.FontWeight.bold,
                    ))),
          ),
          pw.Center(
              child: pw.Text('Site Address: ' + projectData["siteAddress"],
                  style: pw.TextStyle(
                    color: header2Color,
                    fontSize: header2FontSize,
                    fontWeight: pw.FontWeight.bold,
                  ))),
          pw.SizedBox(height: 25),
          pw.Center(
              child: pw.Text('Report For: $todaysDate',
                  style: pw.TextStyle(
                    color: text2Color,
                    fontSize: text2FontSize,
                  ))),
          pw.SizedBox(height: 25),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Approved Excavation: ' + approvedVol.toString(),
                    style: pw.TextStyle(
                      color: text2Color,
                      fontSize: text2FontSize,
                    )),
                // pw.Text('Total Excavation: '+totalVol.toString()),
              ]),
          pw.SizedBox(height: 25),
          pw.Table.fromTextArray(
              context: context,
              border: null,
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: pw.BoxDecoration(
                borderRadius: 2,
                color: tableHeaderColor,
              ),
              headerHeight: 25,
              cellHeight: 40,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.center,
                4: pw.Alignment.centerRight,
              },
              headerStyle: pw.TextStyle(
                color: white,
                fontSize: textFontSize,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle: const pw.TextStyle(
                color: _redColor,
                fontSize: textFontSize,
              ),
              rowDecoration: pw.BoxDecoration(
                border: pw.BoxBorder(
                  bottom: true,
                  color: _darkColor,
                  width: 1,
                ),
              ),
              headers: List<String>.generate(
                tableHeadersTable.length,
                (col) => tableHeadersTable[col],
              ),
              data: <List<String>>[
                <String>[
                  'Supervisor Name',
                  'Contact No',
                ],
                ...supervisors.map((msg) => [msg["name"], msg["mobile"]])
              ]),
          pw.SizedBox(height: 25),
          pw.Table.fromTextArray(
              context: context,
              border: null,
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: pw.BoxDecoration(
                borderRadius: 2,
                color: tableHeaderColor,
              ),
              headerHeight: 25,
              cellHeight: 40,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerRight,
                3: pw.Alignment.center,
                4: pw.Alignment.centerRight,
              },
              headerStyle: pw.TextStyle(
                color: white,
                fontSize: textFontSize,
                fontWeight: pw.FontWeight.bold,
              ),
              cellStyle:
                  const pw.TextStyle(color: _redColor, fontSize: textFontSize),
              rowDecoration: pw.BoxDecoration(
                border: pw.BoxBorder(
                  bottom: true,
                  color: _darkColor,
                  width: 1,
                ),
              ),
              headers: List<String>.generate(
                tableHeadersTable2.length,
                (col) => tableHeadersTable2[col],
              ),
              data: <List<String>>[
                <String>[
                  'Worker Name',
                  'Hours Worked',
                  'Machine used',
                  'Volume Excavated',
                  'Approval Status'
                ],
                ...todaysReport.map((msg) => [
                      msg["workerName"],
                      msg["hoursWorked"].toString(),
                      msg["MachineUsed"],
                      msg["volumeExcavated"].toString(),
                      msg["status"]
                    ])
              ]),
        ];
      },
    ));
  }

  createOverallPdf() async {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Center(
              child: pw.Text(
                  'Report is generated on ' +
                      formatterForTime.format(date).toString(),
                  style: pw.TextStyle(
                    color: headerColor,
                    fontSize: headerFontSize,
                    // fontWeight: pw.FontWeight.bold,
                  ))),
          pw.SizedBox(height: 25),
          pw.Header(
            level: 0,
            child: pw.Center(
                child: pw.Text("Project name: " + projectData["projectName"],
                    style: pw.TextStyle(
                      color: headerColor,
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 25,
                    ))),
          ),
          pw.Center(
              child: pw.Text('Site Address: ' + projectData["siteAddress"],
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
                            pw.Text('Soil Type: ',
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
                          pw.Text('Excavation Goals: ',
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
                          pw.Text('Estimated Duration: ',
                              style: pw.TextStyle(
                                color: textColor,
                                fontSize: textFontSize,
                              )),
                          pw.SizedBox(height: 2),
                          pw.Text(projectData["projectDuration"] + " days",
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
                              pw.Text('Estimated Rent: ',
                                  style: pw.TextStyle(
                                    color: textColor,
                                    fontSize: textFontSize,
                                  )),
                              pw.SizedBox(height: 2),
                              pw.Text(projectData["totalMachineRent"] + " rs",
                                  style: pw.TextStyle(
                                    color: text2Color,
                                    fontSize: text3FontSize,
                                  )),
                            ]),
                            pw.SizedBox(width: 50),
                            pw.Column(children: [
                              pw.Text('Approved Excavation: ',
                                  style: pw.TextStyle(
                                    color: textColor,
                                    fontSize: textFontSize,
                                  )),
                              pw.Text(projectData["volumeExcavated"] + " m3",
                                  style: pw.TextStyle(
                                    color: text2Color,
                                    fontSize: text3FontSize,
                                  )),
                            ]),
                          ]),
                      pw.SizedBox(height: 20),
                      pw.Column(children: [
                        pw.Text('Completion Percent: ',
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
                          pw.Text('Estimated Fuel Consumption: ',
                              style: pw.TextStyle(
                                color: textColor,
                                fontSize: textFontSize,
                              )),
                          pw.SizedBox(height: 2),
                          pw.Text(
                              projectData["totalFuelConsumption"] + " litre",
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
                        value:
                            double.parse(projectData["progressPercent"]) / 100,
                        backgroundColor: PdfColors.grey400,
                        color: PdfColors.blue,
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
                      allDates.length, (index) => allDates[index]),
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
                    allDatesApprovedVolume.length,
                    (i) {
                      final num v = allDatesApprovedVolume[i];
                      return pw.LineChartValue(i.toDouble(), v.toDouble());
                    },
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 25),
          pw.Center(
              child: pw.Text('Project Supervisors Details: ',
                  style: pw.TextStyle(
                    color: textColor,
                    fontSize: textFontSize,
                  ))),
          pw.SizedBox(height: 25),
          pw.Table.fromTextArray(
            context: context,
            border: null,
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: pw.BoxDecoration(
              borderRadius: 2,
              color: tableHeaderColor,
            ),
            headerHeight: 25,
            cellHeight: 40,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.centerLeft,
              2: pw.Alignment.centerRight,
              3: pw.Alignment.center,
              4: pw.Alignment.centerRight,
            },
            headerStyle: pw.TextStyle(
              color: white,
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: const pw.TextStyle(
              color: _redColor,
              fontSize: 18,
            ),
            rowDecoration: pw.BoxDecoration(
              border: pw.BoxBorder(
                bottom: true,
                color: _darkColor,
                width: 1,
              ),
            ),
            headers: List<String>.generate(
              tableHeadersTable.length,
              (col) => tableHeadersTable[col],
            ),
            data: <List<String>>[
              <String>[
                '1',
                '2',
              ],
              ...supervisors.map((msg) => [msg["name"], msg["mobile"]])
            ],
            // data: <List<dynamic>.generate(
            //   supervisors.length,
            //   (row) => supervisors[row],
            // ),
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
                          child: pw.Text('Work Details of ' + allDates[index],
                              style: pw.TextStyle(
                                color: textColor,
                                fontSize: textFontSize,
                              ))),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Text(
                          'Approved Excavation: ' +
                              allDatesApprovedVolume[index].toString(),
                          style: pw.TextStyle(
                            color: textColor,
                            fontSize: textFontSize,
                          )),
                      pw.SizedBox(
                        height: 10,
                      ),
                      pw.Table.fromTextArray(
                          context: context,
                          border: null,
                          cellAlignment: pw.Alignment.centerLeft,
                          headerDecoration: pw.BoxDecoration(
                            borderRadius: 2,
                            color: tableHeaderColor,
                          ),
                          headerHeight: 25,
                          cellHeight: 40,
                          cellAlignments: {
                            0: pw.Alignment.centerLeft,
                            1: pw.Alignment.centerLeft,
                            2: pw.Alignment.centerRight,
                            3: pw.Alignment.center,
                            4: pw.Alignment.centerRight,
                          },
                          headerStyle: pw.TextStyle(
                            color: white,
                            fontSize: 18,
                            fontWeight: pw.FontWeight.bold,
                          ),
                          cellStyle: const pw.TextStyle(
                            color: _redColor,
                            fontSize: 18,
                          ),
                          rowDecoration: pw.BoxDecoration(
                            border: pw.BoxBorder(
                              bottom: true,
                              color: _darkColor,
                              width: 1,
                            ),
                          ),
                          headers: List<String>.generate(
                            tableHeadersTable2.length,
                            (col) => tableHeadersTable2[col],
                          ),
                          data: <List<dynamic>>[
                            <String>[
                              'Worker Name',
                              'Hours Worked',
                              'Machine used',
                              'Volume Excavated',
                              'Approval Status'
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

  void loadMachines() async {
    await databaseReference
        .child("masters")
        .child("machineMaster")
        .once()
        .then((snapshot) {
      allMachinesData = snapshot.value;
    });
  }

  Future<void> getProjectsData() async {
    databaseReference
        .child("projects")
        .once()
        .then((DataSnapshot dataSnapshot) {
      Map projMap = dataSnapshot.value;

      //debugPrint(projects.toString());
      projMap.values.toList().forEach((result) {
        setState(() {
          Map resultMap = result;
          if (resultMap.containsKey("progress")) {
            projectsDropdwnItems.add(
              DropdownMenuItem(
                child: Container(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(result['projectName']),
                    Text(
                      result['siteAddress'],
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                )),
                value: result['projectID'],
              ),
            );
          }
        });
      });
    });
  }

  void generatetodaysReport() async {
    await databaseReference
        .child("projects")
        .child(selectedProject)
        .once()
        .then((DataSnapshot dataSnapshot) {
      projectData = dataSnapshot.value;

      Map data = dataSnapshot.value["progress"][todaysDate];
      //debugPrint(data.toString());

      Map supMap = dataSnapshot.value["supervisors"];
      supervisors = supMap.values.toList();

      debugPrint(supervisors.toString());

      todaysReport = [];
      if (data != null) {
        data.forEach(
          (index, data) => todaysReport.add({"workerID": index, ...data}),
        );
        debugPrint(todaysReport.toString());

        for (int i = 0; i < todaysReport.length; i++) {
          if (todaysReport[i]["status"].toString() == "Accepted")
            approvedVol = approvedVol +
                double.parse(todaysReport[i]["volumeExcavated"].toString());

          if (allMachinesData.containsKey(todaysReport[i]["MachineUsed"])) {
            String machineModel =
                allMachinesData[todaysReport[i]["MachineUsed"]]["machineName"] +
                    "\n" +
                    allMachinesData[todaysReport[i]["MachineUsed"]]
                        ["modelName"];
            todaysReport[i]["MachineUsed"] = machineModel;
          }
        }
      } else
        debugPrint("true");
    });

    await createTodaysPdf();
    await savePDF();

    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    String fullPath = "$documentPath/todaysReport.pdf";

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ReportPreviewTesting(path: fullPath),
        ));
  }

  void generateOverallReport() async {
    allDaysReport.clear();
    allDates.clear();
    approvedVol = 0;
    allDatesApprovedVolume.clear();
    await databaseReference
        .child("projects")
        .child(selectedProject)
        .once()
        .then((DataSnapshot dataSnapshot) {
      projectData = dataSnapshot.value;

      Map data1 = dataSnapshot.value["progress"];
      //debugPrint(data.toString());

      Map supMap = dataSnapshot.value["supervisors"];
      supervisors = supMap.values.toList();

      // Supervisors data [{name: Shraddha, mobile: 989887877}, {name: Amit	, mobile: 987649821}]
      debugPrint('Supervisors data ' + supervisors.toString());

      allDates = data1.keys.toList();
      List allDatesData = data1.values.toList();

      allDatesApprovedVolume = List.generate(allDates.length, (i) => 0.0);

      debugPrint(allDatesData.toString());

      for (int i = 0; i < allDates.length; i++) {
        Map todaysDataMap = allDatesData[i];
        debugPrint(todaysDataMap.values.toList().toString());
        allDaysReport.add(todaysDataMap.values.toList());
      }

      debugPrint(allDaysReport.toString());

      for (int i = 0; i < allDaysReport.length; i++) {
        debugPrint(allDaysReport[i].toString());

        List todaysWorkersDataList = allDaysReport[i];

        for (int j = 0; j < todaysWorkersDataList.length; j++) {
          if (todaysWorkersDataList[j]["status"] == "Accepted") {
            debugPrint(todaysWorkersDataList[j]["workerName"].toString());
            allDatesApprovedVolume[i] = allDatesApprovedVolume[i] +
                double.parse(
                    todaysWorkersDataList[j]["volumeExcavated"].toString());
            approvedVol = approvedVol +
                double.parse(
                    todaysWorkersDataList[j]["volumeExcavated"].toString());
          }
        }
      }

      debugPrint(allDatesApprovedVolume.toString());
    });

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
  }

  @override
  void initState() {
    super.initState();
    getProjectsData();
    loadMachines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: titleStyles('Report Generation ', 18),
                ),
                SizedBox(height: 20.0),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: new DropdownButtonFormField(
                        validator: (value) =>
                            value == null ? 'Enter Start Date' : null,
                        items: projectsDropdwnItems,
                        onChanged: (selectedAccountType) {
                          setState(() {
                            selectedProject = selectedAccountType;
                            debugPrint(selectedProject);
                          });
                        },
                        value: selectedProject,
                        isDense: false,
                        isExpanded: true,
                        hint: Text(
                          'Select Projects',
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  height: 10,
                ),
                Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        // Center(
                        //   child: titleStyles('Get Todays Report: ', 18),
                        // ),

                        SizedBox(
                          height: 20,
                        ),

                        FlatButton(
                          child: buttonContainers(
                              double.infinity, 20, 'Todays Report', 18),
                          onPressed: () async {
                            // await selectedProjs();
                            generatetodaysReport();
                          },
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        FlatButton(
                          child: buttonContainers(double.infinity, 20,
                              'Generate Overall Report', 18),
                          onPressed: () async {
                            // await selectedProjs();
                            // await allDayReportPdf();
                            // await savePDF();
                            // Directory documentDirectory =
                            // await getApplicationDocumentsDirectory();
                            // String documentPath = documentDirectory.path;
                            // String fullPath = "$documentPath/example.pdf";
                            //
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //       builder: (context) => ReportPreview(path: fullPath),
                            //     ));

                            generateOverallReport();
                          },
                        ),

                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
