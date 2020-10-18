import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:project_timeline/admin/CommonWidgets.dart';

import 'package:searchable_dropdown/searchable_dropdown.dart';

import 'ReportPreview.dart';

class ReportGeneration extends StatefulWidget {
  @override
  _ReportGenerationState createState() => _ReportGenerationState();
}

class _ReportGenerationState extends State<ReportGeneration> {
  final pdf = pw.Document();

  final databaseReference = FirebaseDatabase.instance.reference();

  final DateTime date = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String todaysDate="12-09-2020";


  final DateTime now = DateTime.now();
  final DateFormat formatterForTime = DateFormat('dd-MM-yyyy hh:mm:ss');

  Map allMachinesData;
  String uid="8YiMHLBnBaNjmr3yPvk8NWvNPmm2";


  // List<ProjectsList> projectsList=List() ;
  List projects=[];

  List<int> selectedProjectsIndex = [];
  List selectedProjects= [];

  List selectedProjectsSupervisors= [];
  List selectedProjectsTodaysWorkersList= [];


  List selectedProjectsAllDaysWorkersList= [];
  List selectedProjectsAllDates= [];

  List<DropdownMenuItem> projectsDropdwnItems = [];


  List<String> _soilType = <String>[
    'Type A',
    'Type B',
    'Type C',
  ];

  String start,end;

  allDayReportPdf() async{

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.ListView.builder(
            itemCount: selectedProjects.length,
            itemBuilder: (context, index) {

              //debugPrint(selectedProjectsTodaysWorkersList[index].toString());
              return pw.Container(

                  child:pw.Column(
                    children: [

                      pw.Header(
                        level: 0,
                        child: pw.Center(child:pw.Text(selectedProjects[index]["projectName"])),
                      ),
                      pw.Center(child:pw.Text('Site Address: '+selectedProjects[index]["siteAddress"])),

                      pw.SizedBox(height: 25),

                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Approved Excavation: '),
                            pw.Text('Total Excavation: '),
                          ]
                      ),

                      pw.SizedBox(height: 25),
                      pw.Table.fromTextArray(context: context, data: <List<dynamic>>[
                        <String>['Supervisor Name', 'Contact No',],
                        ...selectedProjectsSupervisors[index].map(
                                (msg) => [msg["name"], msg["mobile"]])
                      ]),
                      pw.SizedBox(height: 25),


                    pw.ListView.builder(
                    itemCount: selectedProjectsAllDaysWorkersList[index].length,
                    itemBuilder: (context, index2) {

                    //debugPrint(selectedProjectsAllDaysWorkersList[index][index2].toString());
                    return pw.Column(
                      children: [
                        pw.SizedBox(height: 20),
                        pw.Center(child:pw.Text('Report For: '+selectedProjectsAllDates[index][index2])),
                        pw.SizedBox(height: 10),
                    pw.Container(
                    child:pw.Table.fromTextArray(context: context, data: <List<dynamic>>[
                      <String>['Worker Name', 'Hours Worked', 'Machine used', 'Volume Excavated','Approval Status'],
                      ...selectedProjectsAllDaysWorkersList[index][index2].map(
                              (msg) => [msg["workerName"], msg["hoursWorked"].toString(),msg["MachineUsed"], msg["volumeExcavated"].toString(), msg["status"]])
                    ])
                    )]

                    );}),



                      pw.SizedBox(height: 50),

                    ],
                  )
              );
            },
          ),

        ];
      },
    ));

  }



  todaysReportPdf() async{



    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.ListView.builder(
            itemCount: selectedProjects.length,
            itemBuilder: (context, index) {

              //debugPrint(selectedProjectsTodaysWorkersList[index].toString());
              return pw.Container(

                  child:pw.Column(
                    children: [

                      pw.Header(
                        level: 0,
                        child: pw.Center(child:pw.Text(selectedProjects[index]["projectName"])),
                      ),
                      pw.Center(child:pw.Text('Site Address: '+selectedProjects[index]["siteAddress"])),

                      pw.SizedBox(height: 25),
                      pw.Center(child:pw.Text('Report For: $todaysDate')),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text('Approved Excavation: '),
                            pw.Text('Total Excavation: '),
                          ]
                      ),

                      pw.SizedBox(height: 25),
                      pw.Table.fromTextArray(context: context, data: <List<dynamic>>[
                        <String>['Supervisor Name', 'Contact No',],
                        ...selectedProjectsSupervisors[index].map(
                                (msg) => [msg["name"], msg["mobile"]])
                      ]),
                      pw.SizedBox(height: 25),



                      selectedProjectsTodaysWorkersList[index]!=[]?pw.Table.fromTextArray(context: context, data: <List<dynamic>>[
                        <String>['Worker Name', 'Hours Worked', 'Machine used', 'Volume Excavated','Approval Status'],
                        ...selectedProjectsTodaysWorkersList[index].map(
                                (msg) => [msg["workerName"], msg["hoursWorked"].toString(),msg["MachineUsed"], msg["volumeExcavated"].toString(), msg["status"]])
                      ]):pw.Container(),

                      pw.SizedBox(height: 50),

                    ],
                  )
              );
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


  void selectedProjs()
  {
    setState(() {
      selectedProjects.clear();
      selectedProjectsIndex.forEach((element) {

        //debugPrint(element.toString());
        Map selProjMap= projects[element];
        selectedProjects.add(selProjMap);

        Map supervisorMap= selProjMap["supervisors"];
        selectedProjectsSupervisors.add(supervisorMap.values.toList());
        //debugPrint(selectedProjectsSupervisors.toString());

        if(selProjMap.containsKey("progress"))
          {
            Map workerMap= selProjMap["progress"];
            if(workerMap.containsKey(todaysDate))
              {
                selectedProjectsTodaysWorkersList.add(workerMap[todaysDate].values.toList());
              }
            else
              {
                selectedProjectsTodaysWorkersList.add([]);
              }

            List finalAllDays=[];
            selectedProjectsAllDates.add(workerMap.keys.toList());

            for(int i=0;i<workerMap.values.toList().length;i++)
              {
                Map thisDayWorkersMap= workerMap.values.toList()[i];
                finalAllDays.add( thisDayWorkersMap.values.toList());
              }

            selectedProjectsAllDaysWorkersList.add(finalAllDays);
            //debugPrint("all days--------------"+selectedProjectsAllDaysWorkersList.toString());


          }
          else
            {
              selectedProjectsTodaysWorkersList.add([]);
              selectedProjectsAllDaysWorkersList.add([]);
              selectedProjectsAllDates.add([]);
            }
        //debugPrint(selectedProjectsTodaysWorkersList.toString());


      });

    });

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
      projects=projMap.values.toList();

      //debugPrint(projects.toString());
      projects.forEach((result) {
        setState(() {
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
        });
      });

    });
  }







  @override
  void initState() {
    super.initState();
    getProjectsData();

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
                      child: SearchableDropdown.multiple(
                        items: projectsDropdwnItems,
                        selectedItems: selectedProjectsIndex,
                        hint: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text("Select Supervisors"),
                        ),
                        searchHint: "Select any",
                        onChanged: (value) {
                          setState(() {
                            selectedProjectsIndex = value;
                            selectedProjs();
                          });
                          //debugPrint(selectedProjectsIndex.toString());
                        },
                        closeButton: (selectedItems) {
                          return (selectedItems.isNotEmpty
                              ? "Save ${selectedItems.length == 1 ? '"' + projectsDropdwnItems[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                              : "Save without selection");
                        },
                        isExpanded: true,
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

                          await selectedProjs();
                          await todaysReportPdf();
                          await savePDF();

                          Directory documentDirectory =
                              await getApplicationDocumentsDirectory();
                          String documentPath = documentDirectory.path;
                          String fullPath = "$documentPath/example.pdf";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportPreview(path: fullPath),
                              ));
                        },
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      FlatButton(
                        child: buttonContainers(double.infinity, 20, 'Generate Overall Report', 18),
                        onPressed: () async{
                          await selectedProjs();
                          await allDayReportPdf();
                          await savePDF();
                          Directory documentDirectory =
                          await getApplicationDocumentsDirectory();
                          String documentPath = documentDirectory.path;
                          String fullPath = "$documentPath/example.pdf";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReportPreview(path: fullPath),
                              ));
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

                Container(
                    // decoration: BoxDecoration(
                    //   border: Border.all(color: Colors.grey),
                    //   borderRadius: BorderRadius.circular(5),
                    // ),
                    padding: EdgeInsets.all(15),
                    child:Column(
                      children: [
                        // Center(
                        //   child: titleStyles('Generate Report: ', 18),
                        // ),
                        //
                        // SizedBox(
                        //   height: 10,
                        // ),

                        // Form(
                        //
                        //   child: Row(
                        //     children: [
                        //
                        //       Expanded(
                        //         child: new DropdownButtonFormField(
                        //           validator: (value) =>
                        //           value == null ? 'Enter Start Date' : null,
                        //           items: _soilType
                        //               .map((value) => DropdownMenuItem(
                        //             child: Text(
                        //               value,
                        //               style: TextStyle(color: Colors.deepPurple[900]),
                        //             ),
                        //             value: value,
                        //           ))
                        //               .toList(),
                        //           onChanged: (selectedAccountType) {
                        //             print('$selectedAccountType');
                        //             setState(() {
                        //               start = selectedAccountType;
                        //             });
                        //           },
                        //           value: start,
                        //           isExpanded: true,
                        //           hint: Text(
                        //             'Start Date',
                        //             style: TextStyle(color: Colors.black54, fontSize: 17),
                        //           ),
                        //         ),
                        //       ),
                        //
                        //       SizedBox(
                        //         width: 10,
                        //       ),
                        //
                        //       Expanded(
                        //         child: new DropdownButtonFormField(
                        //           validator: (value) =>
                        //           value == null ? 'Enter End Date' : null,
                        //           items: _soilType
                        //               .map((value) => DropdownMenuItem(
                        //             child: Text(
                        //               value,
                        //               style: TextStyle(color: Colors.deepPurple[900]),
                        //             ),
                        //             value: value,
                        //           ))
                        //               .toList(),
                        //           onChanged: (selectedAccountType) {
                        //             print('$selectedAccountType');
                        //             setState(() {
                        //               end = selectedAccountType;
                        //             });
                        //           },
                        //           value: end,
                        //           isExpanded: true,
                        //           hint: Text(
                        //             'End Date',
                        //             style: TextStyle(color: Colors.black54, fontSize: 17),
                        //           ),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        //
                        // ),

                        // SizedBox(
                        //   height: 10,
                        // ),
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
                      ],
                    )
                ),

              ],
            )
          ],
        ),
      ),

    );
  }
}
