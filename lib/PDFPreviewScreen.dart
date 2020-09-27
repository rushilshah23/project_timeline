import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PDFPreviewScreen extends StatefulWidget {
  final String path;

  PDFPreviewScreen({this.path});

  @override
  _PDFPreviewScreenState createState() => _PDFPreviewScreenState();
}

class _PDFPreviewScreenState extends State<PDFPreviewScreen> {
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
        appBar: AppBar(
          title: Text("Document"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () {},
            ),
          ],
        ),
        path: widget.path);
  }
}
