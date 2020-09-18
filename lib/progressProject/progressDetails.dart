import 'package:flutter/material.dart';

class ProgressDetails extends StatefulWidget {
  Map allProjectDetails;
  ProgressDetails({this.allProjectDetails});

  @override
  ProgressDetailsState createState() => ProgressDetailsState();
}

class ProgressDetailsState extends State<ProgressDetails> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    debugPrint(widget.allProjectDetails["progress"].toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progess Details'),
      ),
      body: Container(
        child: Column(
          children: [
            Text(widget.allProjectDetails["progress"].toString()),
            FlatButton(
              onPressed: () {
                // debugPrint()
              },
              child: Text('Print progresses in console'),
              color: Colors.blue[100],
            ),
          ],
        ),
      ),
    );
  }
}
