import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:photo_view/photo_view.dart';
import 'package:project_timeline/languages/setLanguageText.dart';

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
         'projectStatus': totalProgress.ceil()>= 100?"Completed": totalProgress.ceil()< 100?"Ongoing":'Not Started',
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

                child: titleStyles(superText4[4], 18),
              ),
              SizedBox(
                height: 20,
              ),
              Text(superText4[5] + widget.data["workerName"].toString()),
              SizedBox(
                height: 10,
              ),
              Text(superText4[6] +
                  widget.data["volumeExcavated"].toString()+" m3"),
              SizedBox(
                height: 10,
              ),
              Text(superText4[7] + widget.data["hoursWorked"].toString()+" hrs"),
              SizedBox(
                height: 10,
              ),
              Text(superText4[8] +
                  widget.data["length"].toString() + " m"
                  "    " +
                  superText4[9] +
                  widget.data["depth"].toString() + " m"),
              SizedBox(
                height: 10,
              ),
              Text(superText4[10] +
                  widget.data["upperWidth"].toString() + " m" 
                  "   " +
                  superText4[11] +
                  widget.data["lowerWidth"].toString()+ " m"),
              SizedBox(
                height: 30,
              ),
              Text(superText4[12] + workdiff.toInt().toString() + " %"),
              SizedBox(
                height: 15,
              ),
              Text(superText4[13] + widget.data["status"].toString()),
              SizedBox(
                height: 25,
              ),
              Text(superText4[14]),
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
                      child: buttonContainers(150, superText4[15], 18),
                      onPressed: () {
                        if(widget.data["status"].toString().contains("Accepted"))
                        
                        { 
                          showToast(superText4[16]);
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
                      child: buttonContainers(150, superText4[17], 18),
                      onPressed: () {
                         if(widget.data["status"].toString().contains("Declined"))
                         { Navigator.of(context).pop();
                        showToast(superText4[18]);
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
