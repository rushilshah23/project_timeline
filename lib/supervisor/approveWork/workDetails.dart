import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/CommonWidgets.dart';
import 'package:project_timeline/manager/master/petrolMaster/EditPetrolPump.dart';
import 'package:photo_view/photo_view.dart';
import '../../CommonWidgets.dart';
import '../../CommonWidgets.dart';
import '../../CommonWidgets.dart';

class WorkDetails extends StatefulWidget {
  Map data;

  WorkDetails({Key key, this.data,}) : super(key: key);

  @override
  _WorkDetailsState createState() => _WorkDetailsState();
}

class _WorkDetailsState extends State<WorkDetails> {

  Map data;
  int indexes;

  List images=[];

  @override
  void initState() {

    debugPrint(widget.data["images"].toString());
    images=widget.data["images"];
    setState(() {

    });
  }


  Widget buildGridView() {
    return Container(
        height: MediaQuery.of(context).size.height/4,
        child:GridView.count(
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            return Container(
                child: GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return PhotoView(
                        imageProvider:NetworkImage(images[index]),
                    );
                  }));
            },
                    child:Card(
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
            height: MediaQuery.of(context).size.height / 1.2,
            padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
            child: Container(

              child: ListView(


                    children: <Widget>[


                      Center(
                        child: Text('Details:',
                            style: titlestyles(18, Colors.orange)
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Text("Worker Name: " +widget.data["workerName"].toString() ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Volume Excavated: "+widget.data["volumeExcavated"].toString()),


                      SizedBox(
                        height: 10,
                      ),
                      Text("Hours Worked: "+widget.data["hoursWorked"].toString()),

                      SizedBox(
                        height: 10,
                      ),
                      Text("Length: "+widget.data["length"].toString()+" "+"Depth: "+widget.data["depth"].toString()),

                      SizedBox(
                        height: 10,
                      ),
                      Text("Upper Width: "+widget.data["upperWidth"].toString()+" "+"Lower Width: "+widget.data["lowerWidth"].toString()),


                      SizedBox(
                        height: 30,
                      ),
                      Text("Work difference: "),
                      SizedBox(
                        height: 15,
                      ),
                      Text("Approval status: "+widget.data["status"].toString()),
                      SizedBox(
                        height: 25,
                      ),
                      Text("Images: "),
                       buildGridView(),

                      SizedBox(
                        height: 50,
                      ),



                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Flexible(
                            child: FlatButton(
                              child: Container(
                                height: 40,
//                                width: 150,
                                decoration: BoxDecoration(
                                  gradient: gradients(),
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                  child: Center(child: Text("Approve",style: titlestyles(18, Colors.white),))
                              ),
                              onPressed: () {

                              },
                            ),
                          ),
                          Flexible(
                          child: FlatButton(

                            child: Container(
                                height:40,
                               // width: 150,
                                decoration: BoxDecoration(
                                    gradient: gradients(),
                                    borderRadius: BorderRadius.circular(5)
                                ),
                                child: Center(child: Text("Reject",style: titlestyles(18, Colors.white),))),
                            onPressed: () {

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
