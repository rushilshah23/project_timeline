import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class ReportPreviewTesting extends StatefulWidget {
  final String path;

  ReportPreviewTesting({this.path});

  @override
  _ReportPreviewTestingState createState() => _ReportPreviewTestingState();
}

class _ReportPreviewTestingState extends State<ReportPreviewTesting> with WidgetsBindingObserver{
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

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
