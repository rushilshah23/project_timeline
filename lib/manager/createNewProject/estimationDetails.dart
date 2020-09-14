import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/CommonWidgets.dart';
import 'package:project_timeline/manager/createNewProject/test.dart';
import 'package:project_timeline/manager/master/petrolMaster/EditPetrolPump.dart';


class EstimationDetailsPage extends StatefulWidget {
  EstimationDetails data;
  EstimationDetailsPage({Key key, this.data, }) : super(key: key);

  @override
  _EstimationDetailsPageState createState() => _EstimationDetailsPageState();
}

class _EstimationDetailsPageState extends State<EstimationDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final databaseReference = FirebaseDatabase.instance.reference();
  int indexes;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
          child: Container(
            width: MediaQuery.of(context).size.width / 1.3,
            height: MediaQuery.of(context).size.height / 2,
            padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
            child: ListView(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Center(
                        child: Text('Details:',
                            style: titlestyles(18, Colors.deepOrange)
                        ),
                      ),
                      Text("Total Volume: "+widget.data.totalExcavation +"m3"),

                      SizedBox(
                        height: 20,
                      ),
                      Text("No of Days: "+widget.data.noOfDays),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Total Rent of Machines Used: "+widget.data.totalRent+" Rs"),
                      SizedBox(
                        height: 20,
                      ),
                      Text("Total Fuel requires: "+widget.data.totalFuel+ " litre"),
                      SizedBox(
                        height: 20,
                      ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          debugPrint('Create Project');
                        },
                        child: Text("Create Project"),
                      ),

                    ],
                  )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
  }
}
