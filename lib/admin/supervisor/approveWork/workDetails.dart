import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:photo_view/photo_view.dart';

class WorkDetails extends StatefulWidget {
  Map data;
  String projectID;

  WorkDetails({Key key, this.data, this.projectID}) : super(key: key);

  @override
  _WorkDetailsState createState() => _WorkDetailsState();
}

class _WorkDetailsState extends State<WorkDetails> {
  Map data;
  int indexes;
  List images = List();
  final databaseReference = FirebaseDatabase.instance.reference();
  Map projectData;
  String volumeExcavated;
  String volumeToBeExcavated;
  String progressPercent;
  double totalVol;
  double totalProgress;
  double workdiff = 0.0;

  List allApprovedImages = [];


  @override
  void initState() {
    debugPrint(widget.data["date"].toString());
    debugPrint(widget.data["images"].toString());

    if (widget.data.containsKey("images")) 
    setState(() {
       images = widget.data["images"];
    });
   

    setState(() {
      workdiff = double.parse(widget.data["workDifference"].toString());
    });

    databaseReference
        .child("projects")
        .child(widget.projectID)
        .once()
        .then((DataSnapshot dataSnapshot) {
      projectData = dataSnapshot.value;
      setState(() {
        volumeExcavated = projectData["volumeExcavated"];
        volumeToBeExcavated = projectData["volumeToBeExcavated"];
        progressPercent = projectData["progressPercent"];
        allApprovedImages.addAll(projectData["approvedImages"]);
      });
    });

    setState(() {});
  }

  repondToWork(String status) async {
    await databaseReference
        .child("projects")
        .child(widget.projectID)
        .child("progress")
        .child(widget.data["date"])
        .child(widget.data["workerUID"])
        .update({
      'status': status,
    });

    if (status == "Accepted") {
      
       images.forEach((element) {
        allApprovedImages.add(element);
      });

      totalVol = double.parse(volumeExcavated) +
          double.parse(widget.data["volumeExcavated"].toString());
      totalProgress = (totalVol / double.parse(volumeToBeExcavated)) * 100;

      await databaseReference.child("projects").child(widget.projectID).update({
        'approvedImages': allApprovedImages,
        'volumeExcavated': totalVol.ceil().toString(),
        'progressPercent': totalProgress.ceil().toString(),
      });
    }

    if (status == "Declined") {
       if(widget.data["status"].toString().contains("Accepted"))
      { 

        images.forEach((element) {
            allApprovedImages.remove(element);
          });
      totalVol = double.parse(volumeExcavated) -
          double.parse(widget.data["volumeExcavated"].toString());
      totalProgress = (totalVol / double.parse(volumeToBeExcavated)) * 100;

      await databaseReference.child("projects").child(widget.projectID).update({
        'approvedImages': allApprovedImages,
        'volumeExcavated': totalVol.ceil().toString(),
        'progressPercent': totalProgress.ceil().toString(),
      });
      }
    }

    showToast("$status successfully");
     Navigator.of(context).pop();
  }

  Widget buildGridView() {
    return Container(
        height: MediaQuery.of(context).size.height / 4,
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            return Container(
                child: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) {
                        return PhotoView(
                          imageProvider: NetworkImage(images[index]),
                        );
                      }));
                    },
                    child: Card(
                      child: Image.network(images[index]),
                    ))); //
          }),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 1.3,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Center(
//                        child: Text('Details:',
//                            style: titlestyles(18, Colors.orange)
//                        ),

                child: titleStyles('Work Details:', 18),
              ),
              SizedBox(
                height: 20,
              ),
              Text("Worker Name: " + widget.data["workerName"].toString()),
              SizedBox(
                height: 10,
              ),
              Text("Volume Excavated: " +
                  widget.data["volumeExcavated"].toString()),
              SizedBox(
                height: 10,
              ),
              Text("Hours Worked: " + widget.data["hoursWorked"].toString()),
              SizedBox(
                height: 10,
              ),
              Text("Length: " +
                  widget.data["length"].toString() +
                  " " +
                  "Depth: " +
                  widget.data["depth"].toString()),
              SizedBox(
                height: 10,
              ),
              Text("Upper Width: " +
                  widget.data["upperWidth"].toString() +
                  " " +
                  "Lower Width: " +
                  widget.data["lowerWidth"].toString()),
              SizedBox(
                height: 30,
              ),
              Text("Work difference: " + workdiff.toInt().toString() + " %"),
              SizedBox(
                height: 15,
              ),
              Text("Approval status: " + widget.data["status"].toString()),
              SizedBox(
                height: 25,
              ),
              Text("Images: "),
              buildGridView(),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: FlatButton(
//                              child: Container(
//                                height: 40,
////                                width: 150,
//                                decoration: BoxDecoration(
//                                  gradient: gradients(),
//                                  borderRadius: BorderRadius.circular(5)
//                                ),
//                                  child: Center(child: Text("Approve",style: titlestyles(18, Colors.white),))
//                              ),
                      child: buttonContainers(150, 10, 'Approve', 18),
                      onPressed: () {
                        if(widget.data["status"].toString().contains("Accepted"))
                        
                        { 
                          showToast("Already Accepted");
                          Navigator.of(context).pop();
                        }
                        else
                        repondToWork("Accepted");
                      },
                    ),
                  ),
                  Flexible(
                    child: FlatButton(
//                            child: Container(
//                                height:40,
//                               // width: 150,
//                                decoration: BoxDecoration(
//                                    gradient: gradients(),
//                                    borderRadius: BorderRadius.circular(5)
//                                ),
//                                child: Center(child: Text("Reject",style: titlestyles(18, Colors.white),))),
                      child: buttonContainers(150, 10, 'Reject', 18),
                      onPressed: () {
                         if(widget.data["status"].toString().contains("Declined"))
                         { Navigator.of(context).pop();
                        showToast("Already Declined");
                         }
                        else
                        repondToWork("Declined");
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
