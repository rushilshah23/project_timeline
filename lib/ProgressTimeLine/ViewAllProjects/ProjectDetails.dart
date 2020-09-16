import 'package:flutter/material.dart';

class ProjectDetails extends StatefulWidget {
  Map projectDetails;
  ProjectDetails({this.projectDetails});

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Project Name: ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600]),
                ),
                Text(
                  widget.projectDetails["projectName"].toString(),
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Site Address: ',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600]),
                ),
                Text(
                  widget.projectDetails["siteAddress"].toString(),
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              'Progress Percent: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),

            Text(
              widget.projectDetails["progressPercent"].toString(),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [],
            //     ),
            //     SizedBox(
            //       height: 8,
            //     ),
            //     Column(
            //       children: [],
            //     ),
            //   ],
            // ),
            Text(
              'Soil Type: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),

            Text(
              widget.projectDetails["soilType"].toString(),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   children: [
            //     Column(
            //       children: [],
            //     ),
            //     SizedBox(
            //       height: 15,
            //     ),
            //     Column(
            //       children: [],
            //     ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceAround,
            //   // crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Column(
            //       mainAxisAlignment: MainAxisAlignment.start,
            //       children: [],
            //     ),
            //     SizedBox(
            //       height: 10,
            //     ),
            //     Column(
            //       children: [],
            //     ),
            //   ],
            // ),

            Text(
              'Status: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),

            Text(
              widget.projectDetails["status"].toString(),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Supervisor Name: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
            Text(
              widget.projectDetails["supervisorName"].toString(),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Progress Percent: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
            Text(
              widget.projectDetails["progressPercent"].toString(),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Soil Type: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
            Text(
              widget.projectDetails["soilType"].toString(),
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
