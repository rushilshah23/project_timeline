import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project_timeline/PDFPreviewScreen.dart';

class PDFTesting extends StatefulWidget {
  @override
  _PDFTestingState createState() => _PDFTestingState();
}

class _PDFTestingState extends State<PDFTesting> {
  final pdf = pw.Document();

  final databaseReference = FirebaseDatabase.instance.reference();
  List todaysReport = List();
  List supervisors = List();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String todaysDate = "12-09-2020";
  double totalVol = 0;
  double approvedVol = 0;
  Map projectData;
  Map allMachinesData;
  String uid = "8YiMHLBnBaNjmr3yPvk8NWvNPmm2";
  String projectID = "b570da70-fa93-11ea-9561-89a3a74b28bb";

  static const _darkColor = PdfColors.blueGrey800;
  static const _redColor = PdfColors.grey700;
  static const white = PdfColors.white;

  static final tableHeadersTable = [
    'SKU#',
    'Item Description',
    // 'Price',
    // 'Quantity',
    // 'Total'
  ];

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

  // PdfColor get _baseTextColor =>
  //     _baseTextColor.luminance < 0.5 ? _lightColor : _darkColor;

  // PdfColor get _accentTextColor =>
  //     _baseTextColor.luminance < 0.5 ? _lightColor : _darkColor;

  createPdf() {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(60),
      build: (pw.Context context) {
        return <pw.Widget>[
          // pw.Chart(
          //   left: pw.Container(
          //     alignment: pw.Alignment.topCenter,
          //     margin: const pw.EdgeInsets.only(right: 5, top: 10),
          //     child: pw.Transform.rotateBox(
          //       angle: pi / 2,
          //       child: pw.Text('Amount'),
          //     ),
          //   ),
          //   overlay: pw.ChartLegend(
          //     position: const pw.Alignment(-.7, 1),
          //     decoration: const pw.BoxDecoration(
          //       color: PdfColors.white,
          //       border: pw.BoxBorder(
          //         bottom: true,
          //         top: true,
          //         left: true,
          //         right: true,
          //         color: PdfColors.black,
          //         width: .5,
          //       ),
          //     ),
          //   ),
          //   grid: pw.CartesianGrid(
          //     xAxis: pw.FixedAxis.fromStrings(
          //       List<String>.generate(
          //           dataTable.length, (index) => dataTable[index][0]),
          //       marginStart: 30,
          //       marginEnd: 30,
          //       ticks: true,
          //     ),
          //     yAxis: pw.FixedAxis(
          //       [0, 100, 200, 300, 400, 500, 600, 700],
          //       format: (v) => '\$$v',
          //       divisions: true,
          //     ),
          //   ),
          //   datasets: [
          //     pw.BarDataSet(
          //       color: PdfColors.blue100,
          //       legend: tableHeaders[2],
          //       width: 30,
          //       offset: -10,
          //       borderColor: PdfColors.cyan,
          //       data: List<pw.LineChartValue>.generate(
          //         dataTable.length,
          //         (i) {
          //           final num v = dataTable[i][2];
          //           return pw.LineChartValue(i.toDouble(), v.toDouble());
          //         },
          //       ),
          //     ),
          //     // pw.BarDataSet(
          //     //   color: PdfColors.amber100,
          //     //   legend: tableHeaders[1],
          //     //   width: 15,
          //     //   offset: 10,
          //     //   borderColor: PdfColors.amber,
          //     //   data: List<pw.LineChartValue>.generate(
          //     //     dataTable.length,
          //     //     (i) {
          //     //       final num v = dataTable[i][1];
          //     //       return pw.LineChartValue(i.toDouble(), v.toDouble());
          //     //     },
          //     //   ),
          //     // ),
          //   ],
          // ),

          // pw.Chart(
          //   grid: pw.CartesianGrid(
          //     xAxis: pw.FixedAxis([0, 1, 2, 3, 4, 5, 6]),
          //     yAxis: pw.FixedAxis(
          //       [0, 200, 400, 600],
          //       divisions: true,
          //     ),
          //   ),
          //   datasets: [
          //     pw.LineDataSet(
          //       drawSurface: false,
          //       isCurved: true,
          //       drawPoints: true,
          //       color: PdfColors.cyan,
          //       data: List<pw.LineChartValue>.generate(
          //         dataTable.length,
          //         (i) {
          //           final num v = dataTable[i][2];
          //           return pw.LineChartValue(i.toDouble(), v.toDouble());
          //         },
          //       ),
          //     ),
          //   ],
          // ),
          pw.Header(
            level: 0,
            child: pw.Center(
                child: pw.Text(
              "Project name: " + projectData["projectName"],
              textScaleFactor: 3,
            )),
          ),
          pw.Center(
              child: pw.Text(
            'Site Address: ' + projectData["siteAddress"],
            textScaleFactor: 2,
          )),
          pw.SizedBox(height: 40),
          pw.Center(
              child: pw.Text('Report For: $todaysDate',
                  style: pw.TextStyle(
                    fontSize: 18,
                  ))),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Approved Excavation: ' + approvedVol.toString(),
                    style: pw.TextStyle(
                      fontSize: 18,
                    )),
                pw.Text('Total Excavation: ' + totalVol.toString(),
                    style: pw.TextStyle(
                      fontSize: 18,
                    )),
              ]),
          pw.SizedBox(height: 25),
          // pw.Table.fromTextArray(context: context, data: <List<String>>[
          //   <String>[
          //     'Supervisor Name',
          //     'Contact No',
          //   ],
          //   ...supervisors.map((msg) => [msg["name"], msg["mobile"]])
          // ]),
          pw.SizedBox(height: 25),
          pw.Table.fromTextArray(
            border: null,
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: pw.BoxDecoration(
              borderRadius: 2,
              color: _redColor,
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
              (col) => tableHeaders[col],
            ),
            data: <List<String>>[
              <String>[
                'Supervisor Name',
                'Contact No',
              ],
              ...supervisors.map((msg) => [msg["name"], msg["mobile"]])
            ],
          ),
          pw.Table.fromTextArray(context: context, data: <List<String>>[
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
                      fontSize: 18,
                    ))),
          ),
          pw.SizedBox(height: 25),
          // pw.Flexible(
          //   child: pw.CircularProgressIndicator(value: 23),
          // ),
          pw.Center(
              child: pw.Text('Work Images: ',
                  style: pw.TextStyle(
                    fontSize: 18,
                  ))),
          pw.ListView.builder(
            itemCount: todaysReport.length,
            itemBuilder: (context, index) {
              return pw.Container(
                  child: pw.Column(
                children: [
                  pw.Text(
                      "Images from " + todaysReport[index]["workerName"] + ":",
                      style: pw.TextStyle(
                        fontSize: 18,
                      )),
                  pw.GridView(
                    childAspectRatio: 1,
                    crossAxisCount: 4,
                    // Generate 100 widgets that display their index in the List.
                    children: List.generate(2, (index) {
                      return pw.Container(
                        child: pw.Text('Item $index',
                            style: pw.TextStyle(
                              fontSize: 18,
                            )),
                      );
                    }),
                  )
                ],
              ));
            },
          ),
        ];
      },
    ));
  }

  Future savePDF() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/example.pdf");
    file.writeAsBytesSync(pdf.save());
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

  @override
  void initState() {
    super.initState();
    loadMachines();
    // todaysDate = formatter.format(now);
    // debugPrint(todaysDate);

    databaseReference
        .child("projects")
        .child(projectID)
        .once()
        .then((DataSnapshot dataSnapshot) {
      projectData = dataSnapshot.value;
      if (projectData != null) {
        Map data = dataSnapshot.value["progress"][todaysDate];
        //debugPrint(data.toString());

        Map supMap = dataSnapshot.value["supervisors"];
        supervisors = supMap.values.toList();

        todaysReport = [];
        if (data != null) {
          data.forEach(
            (index, data) => todaysReport.add({"workerID": index, ...data}),
          );
          debugPrint(todaysReport.toString());
          for (int i = 0; i < todaysReport.length; i++) {}
          for (int i = 0; i < todaysReport.length; i++) {
            if (todaysReport[i]["status"].toString() == "Accepted")
              approvedVol = approvedVol +
                  double.parse(todaysReport[i]["volumeExcavated"].toString());
            totalVol = totalVol +
                double.parse(todaysReport[i]["volumeExcavated"].toString());

            if (allMachinesData.containsKey(todaysReport[i]["MachineUsed"])) {
              String machineModel =
                  allMachinesData[todaysReport[i]["MachineUsed"]]
                          ["machineName"] +
                      "\n" +
                      allMachinesData[todaysReport[i]["MachineUsed"]]
                          ["modelName"];
              todaysReport[i]["MachineUsed"] = machineModel;
            }
          }
        } else
          debugPrint("true");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF testing"),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text("asdfasfd"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          createPdf();
          await savePDF();

          Directory documentDirectory =
              await getApplicationDocumentsDirectory();
          String documentPath = documentDirectory.path;
          String fullPath = "$documentPath/example.pdf";

          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PDFPreviewScreen(path: fullPath),
              ));
        },
        child: Text('Create PDF'),
      ),
    );
  }
}
