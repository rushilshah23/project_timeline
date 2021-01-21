import 'package:flutter/material.dart';

import '../CommonWidgets.dart';
import 'package:project_timeline/lib/languages/rawText/admin/adminEnglish.dart';

class OurMachinesDetailsDisplay extends StatefulWidget {
  List data;
  int indexes;
  OurMachinesDetailsDisplay({Key key, this.data, this.indexes})
      : super(key: key);

  @override
  _OurMachinesDetailsDisplayState createState() =>
      _OurMachinesDetailsDisplayState();
}

class _OurMachinesDetailsDisplayState extends State<OurMachinesDetailsDisplay> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Material(
      child: Container(
        width: MediaQuery.of(context).size.width / 1.3,
        height: MediaQuery.of(context).size.height / 1.7,
        padding: EdgeInsets.fromLTRB(20, 40, 20, 10),
        child: Form(
          child: ListView(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                  child: titleStyles(machinesDataPageEnglish[11] + ':', 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(machinesDataPageEnglish[0] + ": " +
                      widget.data[widget.indexes]["machineName"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(machinesDataPageEnglish[1] + ": " +
                      widget.data[widget.indexes]["machineRent"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(machinesDataPageEnglish[2] + ": " +
                      widget.data[widget.indexes]["modelName"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(machinesDataPageEnglish[3] + ": " +
                      widget.data[widget.indexes]["amountOfExcavation"].toString()+" m3/hr"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(machinesDataPageEnglish[4] + ": " +
                      widget.data[widget.indexes]["tankCapacity"].toString()+" litre"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(machinesDataPageEnglish[5] + ": " +
                      widget.data[widget.indexes]["fuelConsumption"]
                          .toString()+" litre"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(machinesDataPageEnglish[6] + ": " +
                      widget.data[widget.indexes]["operatingWeight"]
                          .toString()+" kg"),
                
                  SizedBox(
                    height: 10,
                  ),
                  Text(machinesDataPageEnglish[7] + ": " +
                      widget.data[widget.indexes]["bucketCapacity"].toString() +" litre"),
                  SizedBox(
                    height: 10,
                  ),
                  Text(machinesDataPageEnglish[8] + ": " +
                      widget.data[widget.indexes]["enginePower"].toString()+" rpm"),

                        SizedBox(
                    height: 20,
                  ),
                  Text(machinesDataPageEnglish[9] + ": " +
                      widget.data[widget.indexes]["vendor"]["name"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text(machinesDataPageEnglish[10] + ": " +
                      widget.data[widget.indexes]["vendor"]["contactNo"]
                          .toString()),

                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
