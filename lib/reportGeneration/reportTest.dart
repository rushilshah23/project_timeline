import 'dart:io';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:project_timeline/PDFPreviewScreen.dart';
import 'package:project_timeline/reportGeneration/reportPreviewTesting.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../CommonWidgets.dart';
import 'ReportPreview.dart';

class ReportGenerationTesting extends StatefulWidget {
  @override
  _ReportGenerationTestingState createState() => _ReportGenerationTestingState();
}

class _ReportGenerationTestingState extends State<ReportGenerationTesting> {
  final pdf = pw.Document();

  final databaseReference = FirebaseDatabase.instance.reference();

  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String todaysDate="12-09-2020";

  Map allMachinesData;
  List projects=[];
  List<DropdownMenuItem> projectsDropdwnItems = [];

  String uid="8YiMHLBnBaNjmr3yPvk8NWvNPmm2";


  String selectedProject;
  List todaysReport=List() ;
  List supervisors=List() ;
  Map projectData;
  double totalVol=0;
  double approvedVol=0;


  Future savePDF() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String documentPath = documentDirectory.path;
    File file = File("$documentPath/example.pdf");
    file.writeAsBytesSync(pdf.save());
  }



  createTodaysPdf() async{

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
            level: 0,
            child: pw.Center(child:pw.Text("Project name: "+projectData["projectName"])),
          ),
          pw.Center(child:pw.Text('Site Address: '+projectData["siteAddress"])),

          pw.SizedBox(height: 25),
          pw.Center(child:pw.Text('Report For: $todaysDate')),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Approved Excavation: '+approvedVol.toString()),
                pw.Text('Total Excavation: '+totalVol.toString()),
              ]
          ),

          pw.SizedBox(height: 25),
          pw.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['Supervisor Name', 'Contact No',],
            ...supervisors.map(
                    (msg) => [msg["name"], msg["mobile"]])
          ]),
          pw.SizedBox(height: 25),
          pw.Table.fromTextArray(context: context, data: <List<String>>[
            <String>['Worker Name', 'Hours Worked', 'Machine used', 'Volume Excavated','Approval Status'],
            ...todaysReport.map(
                    (msg) => [msg["workerName"], msg["hoursWorked"].toString(),msg["MachineUsed"], msg["volumeExcavated"].toString(), msg["status"]])
          ]),


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

      //debugPrint(projects.toString());
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
        //debugPrint(data.toString());

        Map supMap= dataSnapshot.value["supervisors"];
        supervisors=supMap.values.toList();

        todaysReport = [];
        if (data != null) {
          data.forEach(
                (index, data) => todaysReport.add({"workerID": index, ...data}),
          );
          debugPrint(todaysReport.toString());

          for (int i = 0; i < todaysReport.length; i++) {
            if(todaysReport[i]["status"].toString()=="Accepted")
              approvedVol = approvedVol + double.parse(todaysReport[i]["volumeExcavated"].toString());
            totalVol = totalVol + double.parse(todaysReport[i]["volumeExcavated"].toString());

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
    String fullPath = "$documentPath/example.pdf";

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
                                items:projectsDropdwnItems,
                                onChanged: (selectedAccountType) {
                                  setState(() {
                                    selectedProject=selectedAccountType;
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
                    child:Column(
                      children: [
                        // Center(
                        //   child: titleStyles('Get Todays Report: ', 18),
                        // ),

                        SizedBox(
                          height: 20,
                        ),

                        FlatButton(
                          child: buttonContainers(double.infinity, 20, 'Todays Report', 18),
                          onPressed: () async{

                            // await selectedProjs();
                            generatetodaysReport();

                          },
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        // FlatButton(
                        //   child: buttonContainers(double.infinity, 20, 'Generate Overall Report', 18),
                        //   onPressed: () async{
                        //     await selectedProjs();
                        //     await allDayReportPdf();
                        //     await savePDF();
                        //     Directory documentDirectory =
                        //     await getApplicationDocumentsDirectory();
                        //     String documentPath = documentDirectory.path;
                        //     String fullPath = "$documentPath/example.pdf";
                        //
                        //     Navigator.push(
                        //         context,
                        //         MaterialPageRoute(
                        //           builder: (context) => ReportPreview(path: fullPath),
                        //         ));
                        //   },
                        // ),

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
