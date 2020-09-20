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
  List todaysReport=List() ;
  List supervisors=List() ;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  String todaysDate="12-09-2020";
  double totalVol=0;
  double approvedVol=0;
  Map projectData;
  Map allMachinesData;
  String uid="8YiMHLBnBaNjmr3yPvk8NWvNPmm2";
  String projectID="b570da70-fa93-11ea-9561-89a3a74b28bb";


  createPdf() {
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

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
            level: 0,
            child: pw.Center(child:pw.Text("Project name: "+projectData["projectName"])),
          ),

          pw.SizedBox(height: 25),
          pw.Center(child:pw.Text('Work Images: ')),
          pw.ListView.builder(
            itemCount: todaysReport.length,
            itemBuilder: (context, index) {
              return pw.Container(
                  child:pw.Column(
                    children: [
                      pw.Text("Images from "+todaysReport[index]["workerName"]+":"),
                      pw.GridView(
                        childAspectRatio: 1,
                        crossAxisCount: 4,
                        // Generate 100 widgets that display their index in the List.
                        children: List.generate(2, (index) {
                          return pw.Container(
                            child: pw.Text(
                              'Item $index',
                            ),
                          );
                        }),
                      )
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


  void loadMachines() async {
    await databaseReference
        .child("masters")
        .child("machineMaster")
        .once()
        .then((snapshot) {
          allMachinesData=snapshot.value;
    });
  }

  @override
  void initState() {
    super.initState();
    loadMachines();
    // todaysDate = formatter.format(now);
    // debugPrint(todaysDate);

    databaseReference.child("projects").child(projectID).once().then((DataSnapshot dataSnapshot) {

      projectData= dataSnapshot.value;
      if(projectData!=null) {
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

          }
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


