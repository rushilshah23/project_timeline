import 'dart:io';

import 'package:flutter/material.dart';
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

  createPdf() {
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.all(32),
      build: (pw.Context context) {
        return <pw.Widget>[
          pw.Header(
            level: 0,
            child: pw.Text('Just getting how to create it'),
          ),
          pw.Paragraph(
              text:
                  ' klajsdlfkjak dflkajslkdfj;ka lkja;lksjfl;k ;lsjdf k;lasjdlj k;las flkjas;ldf k;lasjdflkajs;lkdf ;laksjf;lkajs flkjaskldfj;klasjflkjaslk lk;asjflkasjdfjkhkjashlkjfhasljdfh kl hlkjhaskdjfhklasfjh kjhaslkjdfh lkjashdf jashk fjhaskdjf aslkhf jkla haskjl ha kla  ask hkjh kjhaslkjf haslkhdfjkshkjsh'),
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
