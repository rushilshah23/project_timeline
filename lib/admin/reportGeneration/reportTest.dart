import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;


import '../CommonWidgets.dart';
import 'reportPreviewTesting.dart';


class ReportGenerationTesting extends StatefulWidget {
  @override
  _ReportGenerationTestingState createState() => _ReportGenerationTestingState();
}

class _ReportGenerationTestingState extends State<ReportGenerationTesting> {
  final pdf = pw.Document();

  final databaseReference = FirebaseDatabase.instance.reference();

  final DateTime date = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String todaysDate="12-09-2020";

  final DateFormat formatterForTime = DateFormat('dd-MM-yyyy hh:mm:ss');

  Map allMachinesData;
  List projects=[];
  List<DropdownMenuItem> projectsDropdwnItems = [];

  String uid="8YiMHLBnBaNjmr3yPvk8NWvNPmm2";
  final _formKey = GlobalKey<FormState>();

  String selectedProject;
  List todaysReport=List() ;
  List supervisors=List() ;
  Map projectData;
  double approvedVol=0;

  List allDaysReport=List();
  List allDates=List();
  List allDatesApprovedVolume= [];
  List graphPoints= [];
  List perDayExcavation=List();

  List alldayMachines=List();

  static const PdfColor tableHeaderColor = PdfColors.cyan100;
  static const PdfColor headerColor = PdfColors.cyan600;
  static const double headerFontSize = 20;
  static const PdfColor header2Color = PdfColors.grey600;
  static const double header2FontSize = 18;
  static const PdfColor textColor = PdfColors.grey600;
  static const double textFontSize = 17;
  static const PdfColor text2Color = PdfColors.black;
  static const double text2FontSize = 15;
  // static const double text3Color = PdfColors.black;
  static const double text3FontSize = 18;

  static const _darkColor = PdfColors.blueGrey800;
  static const _redColor = PdfColors.grey700;
  static const white = PdfColors.white;



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
              border: pw.TableBorder(color: PdfColors.grey400),

              headerDecoration: pw.BoxDecoration(
                borderRadius: 2,
                color: tableHeaderColor,
              ),

              cellStyle: const pw.TextStyle(
                color: _redColor,
                fontSize: 15,
              ),


              data: <List<String>>[
                <String>[
                  'Supervisor Name',
                  'Contact No',
                ],
                ...supervisors.map((msg) => [msg["name"], msg["mobile"]])
              ]),
          pw.SizedBox(height: 25),
          todaysReport.length!=0?pw.Table.fromTextArray(
              context: context,
              border: pw.TableBorder(color: PdfColors.grey400),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: pw.BoxDecoration(
                borderRadius: 2,
                color: tableHeaderColor,
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
              ]):pw.Center(child:pw.Text('No work recorded today' ,
                  style: pw.TextStyle(
                  color: text2Color,
                  fontSize: text2FontSize,
                  )
          ),
          ),
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
                    fontSize: 16,
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

                              pw.Text('Estimated Fuel : ',
                                  style: pw.TextStyle(
                                    color: textColor,
                                    fontSize: textFontSize,
                                  )),

                              pw.Text(
                                  projectData["totalFuelConsumption"] + " litre",
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
                          pw.Text('Approved Excavation: ',
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
                        value:
                         double.parse(projectData["progressPercent"])<100? double.parse(projectData["progressPercent"])>0?
                              double.parse(projectData["progressPercent"])/ 100:0:1,
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
              child: pw.Text('Project Supervisors Details: ',
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
                'Name',
                'Contact no',
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
      allMachinesData=snapshot.value;
    });
  }


  Future<void> getProjectsData() async {
    databaseReference.child("projects").once().then((DataSnapshot dataSnapshot) {

      Map projMap= dataSnapshot.value;

      ////debugPrint(projects.toString());
      projMap.values.toList().forEach((result) {
        setState(() {
          Map resultMap=result;
          if(resultMap.containsKey("progress")){
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



  void generatetodaysReport() async
  {
    await databaseReference.child("projects").child(selectedProject).once().then((DataSnapshot dataSnapshot) {

      projectData= dataSnapshot.value;

      Map data = dataSnapshot.value["progress"][todaysDate];
      ////debugPrint(data.toString());

      Map supMap= dataSnapshot.value["supervisors"];
      supervisors=supMap.values.toList();

      todaysReport = [];
      if (data != null) {
        data.forEach(
              (index, data) => todaysReport.add({"workerID": index, ...data}),
        );
        //debugPrint(todaysReport.toString());

        for (int i = 0; i < todaysReport.length; i++) {
          if(todaysReport[i]["status"].toString()=="Accepted")
            approvedVol = approvedVol + double.parse(todaysReport[i]["volumeExcavated"].toString());

          if(allMachinesData.containsKey(todaysReport[i]["MachineUsed"]))
          {
            String machineModel=allMachinesData[todaysReport[i]["MachineUsed"]]["machineName"]+"\n"+allMachinesData[todaysReport[i]["MachineUsed"]]["modelName"];
            todaysReport[i]["MachineUsed"]=machineModel;
          }
        }


      }
      else
        debugPrint("true");
    }
    );

    await createTodaysPdf();
    await savePDF();

    Directory documentDirectory =
    await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    String fullPath = "$documentPath/todaysReport.pdf";

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReportPreviewTesting(path: fullPath),
        ));

  }



  void generateOverallReport() async
  {
    allDaysReport.clear();
    allDates.clear();
    approvedVol=0;
    allDatesApprovedVolume.clear();
    graphPoints.clear();
    await databaseReference.child("projects").child(selectedProject).once().then((DataSnapshot dataSnapshot) {

      projectData= dataSnapshot.value;
      Map progdata = dataSnapshot.value["progress"];
    
      var sortedEntries = progdata.entries.toList()..sort((e1, e2) {
      return e2.key.compareTo(e1.key);
    });

    Map data1= Map();

    for(int i=0;i<sortedEntries.length;i++)
      data1.putIfAbsent(sortedEntries[i].key, () => sortedEntries[i].value);

      Map supMap= dataSnapshot.value["supervisors"];
      supervisors=supMap.values.toList();

      allDates= data1.keys.toList();
      List allDatesData= data1.values.toList();

      allDatesApprovedVolume =List.generate(allDates.length, (i) =>0.0);
      graphPoints =List.generate(allDates.length, (i) =>[allDates[i],0.0]);

      //debugPrint(allDatesData.toString());

      for(int i=0;i<allDates.length;i++)
      {
        Map todaysDataMap= allDatesData[i];
        //debugPrint(todaysDataMap.values.toList().toString());
        allDaysReport.add(todaysDataMap.values.toList());
      }

      //debugPrint(allDaysReport.toString());

      for (int i = 0; i < allDaysReport.length; i++) {
        //debugPrint(allDaysReport[i].toString());

        List todaysWorkersDataList = allDaysReport[i];


        for(int j=0;j<todaysWorkersDataList.length;j++)
        {
          if(todaysWorkersDataList[j]["status"]=="Accepted")
          {
            //debugPrint(todaysWorkersDataList[j]["workerName"].toString());
            allDatesApprovedVolume[i]=allDatesApprovedVolume[i]+double.parse(todaysWorkersDataList[j]["volumeExcavated"].toString());
            approvedVol= approvedVol+double.parse(todaysWorkersDataList[j]["volumeExcavated"].toString());
            graphPoints[i][1]=graphPoints[i][1]+double.parse(todaysWorkersDataList[j]["volumeExcavated"].toString());

            debugPrint("------------"+todaysWorkersDataList[j].toString());


          }

          if(allMachinesData.containsKey(todaysWorkersDataList[j]["MachineUsed"]))
          {
            debugPrint("sjhdaaaaaaaaaaaaaaaaaaaaaaaaaatr");
            String machineModel=allMachinesData[todaysWorkersDataList[j]["MachineUsed"]]["machineName"]+"\n"+allMachinesData[todaysWorkersDataList[j]["MachineUsed"]]["modelName"];
            debugPrint("------------"+machineModel);
            allDaysReport[i][j]["MachineUsed"]=machineModel;
           
          }
        }
      }

      //debugPrint(allDatesApprovedVolume.toString());

       graphPoints.sort((a,b) {
                  var adate = a[0]; //before -> var adate = a.expiry;
                  var bdate = b[0]; //before -> var bdate = b.expiry;
                  return adate.compareTo(bdate); //to get the order other way just switch `adate & bdate`
                  });
    }
    );

    await createOverallPdf();
    await savePDFOverall();

    Directory documentDirectory =
    await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    String fullPath = "$documentPath/overallProgress.pdf";

    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ReportPreviewTesting(path: fullPath),
        ));

  }



  @override
  void initState() {
    super.initState();
    setState(() {
      todaysDate= formatter.format(date);
    });
    getProjectsData();
    loadMachines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: ThemeAppbar("Reports", context),

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
                Form(
                  key:_formKey ,
                child:Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Center(
                      child: new DropdownButtonFormField(
                        validator: (value) =>
                        value == null ? 'Select Project' : null,
                        items:projectsDropdwnItems,
                        onChanged: (selectedAccountType) {
                          setState(() {
                            selectedProject=selectedAccountType;
                            //debugPrint(selectedProject);
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
                )
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
                    child:Column(
                      children: [
                        // Center(
                        //   child: titleStyles('Get Todays Report: ', 18),
                        // ),

                        SizedBox(
                          height: 20,
                        ),

                        FlatButton(
                          child: buttonContainers(double.infinity, 'Todays Report', 18),
                          onPressed: () async{

                            // await selectedProjs();
                            if(_formKey.currentState.validate())
                            generatetodaysReport();

                          },
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        FlatButton(
                          child: buttonContainers(double.infinity, 'Generate Overall Report', 18),
                          onPressed: () async{
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
                            if(_formKey.currentState.validate())
                            generateOverallReport();
                          },
                        ),

                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )
                ),


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
