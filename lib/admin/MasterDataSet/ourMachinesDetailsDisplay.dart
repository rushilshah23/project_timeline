import 'package:flutter/material.dart';

import '../CommonWidgets.dart';


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
                  child: titleStyles('Details:', 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Machine Name: " +
                      widget.data[widget.indexes]["machineName"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Machine Rent: " +
                      widget.data[widget.indexes]["machineRent"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Model Name: " +
                      widget.data[widget.indexes]["modelName"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Amount Of Excavation: " +
                      widget.data[widget.indexes]["amountOfExcavation"].toString()+" m3/hr"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Tank Capacity: " +
                      widget.data[widget.indexes]["tankCapacity"].toString()+" litre"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Fuel Consumption: " +
                      widget.data[widget.indexes]["fuelConsumption"]
                          .toString()+" litre"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Operating Weight: " +
                      widget.data[widget.indexes]["operatingWeight"]
                          .toString()+" kg"),
                
                  SizedBox(
                    height: 10,
                  ),
                  Text("Bucket Capacity: " +
                      widget.data[widget.indexes]["bucketCapacity"].toString() +" litre"),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Engine Power: " +
                      widget.data[widget.indexes]["enginePower"].toString()+" rpm"),

                        SizedBox(
                    height: 20,
                  ),
                  Text("Vendor Name: " +
                      widget.data[widget.indexes]["vendor"]["name"].toString()),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Vendor Contact No: " +
                      widget.data[widget.indexes]["vendor"]["contactNo"]
                          .toString()),

                  // Text(widget.data["petrolPumpName"].toString()),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Text("Address:"),
                  // Text(widget.data["petrolPumpAddress"].toString()),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Text("Phone Number: "),
                  // Text(widget.data["petrolPumpPhoneNumber"].toString()),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Text("District: "),
                  // Text(widget.data["petrolPumpDistrict"].toString()),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Text("Town:"),
                  // Text(widget.data["petrolPumpTown"].toString()),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // Text("Pin Code:"),
                  // Text(widget.data["petrolPumpPinCode"].toString()),
                  // SizedBox(
                  //   height: 20,
                  // ),
//                  Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      RaisedButton(
//                        onPressed: () {
//                          debugPrint('Edit');
//                          editPetrolPump(widget.data);
//                        },
//                        child: Text("Edit"),
//                      ),
//                      RaisedButton(
//                        onPressed: () {
//                          debugPrint("delete");
//                          deletePetrolPump(widget.data["key"]);
//                        },
//                        child: Text("Delete"),
//                      ),
//                    ],
//                  )
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
