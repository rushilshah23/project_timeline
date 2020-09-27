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
    return Scaffold(
      appBar: AppBar(
        title: Text('asdfasf'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Container(
            child: PDFViewerScaffold(
              path: widget.path,
            ),
          ),
          FlatButton(
            onPressed: () {},
            child: Text('ajsd;asf'),
          )
        ],
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: null, child: Text('kl;asdjfa')),
    );
  }
}
