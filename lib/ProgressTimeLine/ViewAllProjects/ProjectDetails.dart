import 'package:flutter/material.dart';

class ProjectDetails extends StatefulWidget {
  Map projectDetails;
  ProjectDetails({this.projectDetails});

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}



class _ProjectDetailsState extends State<ProjectDetails> {

  List supervisors=[];
  List workers=[];

  @override
  void initState() {
    super.initState();
    Map supervisorsMap= widget.projectDetails["supervisors"];
    supervisors= supervisorsMap.values.toList();
    debugPrint(supervisors.toString());


    Map workersMap= widget.projectDetails["workers"];
    workers= workersMap.values.toList();
    debugPrint(workers.toString());

  }


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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),

            Text(
              'Status: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),

            Text(
              widget.projectDetails["projectStatus"].toString(),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Duration: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
            Text(
              widget.projectDetails["projectDuration"].toString()+" days",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),

            Text(
              'Project Goals: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
            Text(
              widget.projectDetails["volumeToBeExcavated"].toString()+" m3",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),


            Text(
              'volume Excavated: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
            Text(
              widget.projectDetails["volumeExcavated"].toString()+" m3",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            SizedBox(
              height: 10,
            ),
            Text(
              'Supervisors Selected: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),


           Container(
             height: MediaQuery.of(context).size.height/5,
             child:   new ListView.builder(
               itemCount: supervisors.length,
               itemBuilder: (context, index) {
                 return Text("$index:  "+supervisors[index]["name"].toString(),
                     style: TextStyle(
                     fontSize: 16,
                     fontWeight: FontWeight.bold,
                     )
                 );
               },
             ),
           ),


            SizedBox(
              height: 10,
            ),
            Text(
              'Supervisors Selected: ',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]),
            ),
            Container(
              height: MediaQuery.of(context).size.height/5,
              child:   new ListView.builder(
                itemCount: workers.length,
                itemBuilder: (context, index) {
                  return Text("$index:  "+workers[index]["name"].toString(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )
                  );
                },
              ),
            )



          ],
        ),
      ),
    );
  }
}
