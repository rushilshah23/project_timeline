//This page is under supervisor section

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';

import 'machineMaster.dart';

String machineType = 'One';
List<String> soilTypeSelected = List.generate(74, (i) => 'None');
List<TextEditingController> excavationAmount =
    List.generate(74, (i) => TextEditingController());
int amountOfExavationCount;

class EditMachineData extends StatefulWidget {
  final Map machineDetails;
  EditMachineData({Key key, this.machineDetails}) : super(key: key);

  @override
  _EditMachineDataState createState() => _EditMachineDataState();
}

class _EditMachineDataState extends State<EditMachineData> {
  final _formKey = GlobalKey<FormState>();
  String machineName,
      tankCapacity,
      fuelConsumption,
      machineRent,
      vendorName,
      enginePower,
      bucketCapacity,
      operatingWeight,
      modelName,
      vendorContact, amountOfExavation;
  String machineID;
  List allProjects = List();
 int noOfProjects = 0;
  final databaseReference = FirebaseDatabase.instance.reference();

  deleteMachine() async{
    bool isthere=false;
   try {

       await databaseReference
        .child("projects")
        .once()
        .then((DataSnapshot dataSnapshot) {
          Map data = dataSnapshot.value;
          allProjects = [];
          allProjects = data.values.toList();
        });

        for(int i=0;i<allProjects.length;i++)
        {
          List machinesSelected = allProjects[i]["machinesSelected"];
          for(int j=0;j<machinesSelected.length;j++)
          {
            if(machinesSelected[j]["machineID"]==machineID)
            {
              isthere=true;
              break;
            }
          }
        }

        if(isthere)
        {
          showToast("Machine is or was used in some projects.\nHence it cannot be deleted in order to maintain records ");
         Navigator.of(context).pop();

        }
        else{
          
          databaseReference
        .child("masters")
        .child("machineMaster")
        .child(machineID)
        .remove();

        showToast("Removed Sucessfully");
        Navigator.of(context).pop();
      
        }
     


  
   }
   catch(e){
     debugPrint(e.toString());
     showToast("Check your internet");
   }
  }

  addDynamic() {
    amountOfExavationCount = amountOfExavationCount + 1;
    setState(() {});
  }

  addMachine() {
    if (_formKey.currentState.validate()) {
      try {
        databaseReference
            .child("masters")
            .child("machineMaster")
            .child(machineID)
            .update({
          'machineName': machineName,
          'modelName': modelName,
          'tankCapacity': tankCapacity,
          'bucketCapacity': bucketCapacity,
          'enginePower': enginePower,
          'operatingWeight': operatingWeight,
          'fuelConsumption': fuelConsumption,
          'rent': machineRent,
          'vendor': {
            'name': vendorName,
            'contactNo': vendorContact,
          },
          'amountOfExcavation':amountOfExavation.toString(),
          // 'excavation': {
          //   for (int i = 0; i < amountOfExavationCount; i++)
          //     '$i': {
          //       'soilType': soilTypeSelected[i].toString(),
          //       'amountOfExcavation': excavationAmount[i].text.toString(),
          //     }
          // },
        });
        showToast("Details Edited Successfully");
          Navigator.of(context).pop();
      } catch (e) {
        showToast("Failed. check your internet!");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // amountOfExavationCount = 1;

    setState(() {
      machineName = widget.machineDetails["machineName"];
      modelName = widget.machineDetails["modelName"];
      tankCapacity = widget.machineDetails["tankCapacity"];
      bucketCapacity = widget.machineDetails["bucketCapacity"];
      enginePower = widget.machineDetails["enginePower"];
      operatingWeight = widget.machineDetails["operatingWeight"];
      fuelConsumption = widget.machineDetails["fuelConsumption"];
      machineRent = widget.machineDetails["machineRent"];
       amountOfExavation = widget.machineDetails["amountOfExcavation"].toString();
      machineID = widget.machineDetails["machineID"];
      vendorName = widget.machineDetails["vendor"]["name"];
      vendorContact = widget.machineDetails["vendor"]["contactNo"];

      // List temp = widget.machineDetails["excavation"];
      // amountOfExavationCount = temp.length;

      // for (int i = 0; i < temp.length; i++) {
      //   excavationAmount[i].text = temp[i]["amountOfExcavation"];
      //   soilTypeSelected[i] = temp[i]["soilType"];
      // }
      // debugPrint(temp.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: ThemeAppbar("Edit Machine Details", context),
        body: Container(
            child: Form(
                key: _formKey,
                child: ListView(
                    // Center is a layout widget. It takes a single child and positions it
                    // in the middle of the parent.
                    children: [
                      Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text('Edit machine details',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    )),
                              ),

                              SizedBox(height: 15),
                              TextFormField(
                                initialValue: machineName,
                                decoration: InputDecoration(
                                  labelText: "Machine Name",
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                ),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter machine name' : null,
                                onChanged: (val) {
                                  setState(() => machineName = val);
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                initialValue: modelName,
                                decoration: InputDecoration(
                                  labelText: "Model name",
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                ),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter Model name' : null,
                                onChanged: (val) {
                                  setState(() => modelName = val);
                                },
                              ),

                              SizedBox(height: 10),

                              Row(
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      initialValue: tankCapacity,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "litre",
                                        labelText: "Tank Capacity ",
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (val) => val.isEmpty
                                          ? 'Enter tank capacity'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => tankCapacity = val);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: TextFormField(
                                      initialValue: bucketCapacity,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Bucket Capacity ",
                                        hintText: "litre",
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (val) => val.isEmpty
                                          ? 'Enter bucket capacity'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => bucketCapacity = val);
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10),

                              Row(
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      initialValue: enginePower,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "rpm",
                                        labelText: "Engine Power ",
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (val) => val.isEmpty
                                          ? 'Engine Power capacity'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => enginePower = val);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: TextFormField(
                                      initialValue: operatingWeight,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        hintText: "kg",
                                        labelText: "Operating Weight ",
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (val) => val.isEmpty
                                          ? 'Enter Operating Weight'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => operatingWeight = val);
                                      },
                                    ),
                                  )
                                ],
                              ),

                              Row(
                                children: [
                                  Flexible(
                                    child: TextFormField(
                                      initialValue: fuelConsumption,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Fuel Consumption",
                                        hintText: "litre/hr",
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (val) => val.isEmpty
                                          ? 'Enter fuel used'
                                          : null,
                                      onChanged: (val) {
                                        setState(() => fuelConsumption = val);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Flexible(
                                    child: TextFormField(
                                      initialValue: machineRent,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Rent/Hour",
                                        hintText: "rupees",
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (val) =>
                                          val.isEmpty ? 'Enter rent' : null,
                                      onChanged: (val) {
                                        setState(() => machineRent = val);
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 10),

                              TextFormField(
                                initialValue: amountOfExavation,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        labelText: "Amount of Excavation",
                                        hintText: "m3/hr",
                                        fillColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.blue, width: 2.0),
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              bottomLeft: Radius.circular(10)),
                                        ),
                                      ),
                                      validator: (val) =>
                                          val.isEmpty ? 'Enter Excavation' : null,
                                      onChanged: (val) {
                                        setState(() => amountOfExavation = val);
                                      },
                                    ),
//                      Text(
//                        'Fuel Consumption (litre/hr)',
//                        style: TextStyle(color: Colors.black, fontSize: 16),
//                      ),
//                      SizedBox(height: 5),
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                        children: [
//                          Flexible(
//                            child: TextFormField(
//                              decoration: InputDecoration(
//                                labelText: "Fuel Consumption (litre/hr)",
//                                fillColor: Colors.white,
//                                focusedBorder: OutlineInputBorder(
//                                  borderSide: const BorderSide(
//                                      color: Colors.blue, width: 2.0),
//                                  borderRadius: BorderRadius.only(
//                                      topRight: Radius.circular(10),
//                                      topLeft: Radius.circular(10),
//                                      bottomRight: Radius.circular(10),
//                                      bottomLeft: Radius.circular(10)),
//                                ),
//                              ),
//                              validator: (val) => val.isEmpty ? '??' : null,
//                              onChanged: (val) {
//                                setState(() => fluelConsumption = val);
//                              },
//                            ),
//                          ),
////                          SizedBox(width: 10),
////                          Flexible(
////                              child: TextFormField(
////                            decoration: InputDecoration(
////                              labelText: "medium",
////                              fillColor: Colors.white,
////                              focusedBorder: OutlineInputBorder(
////                                borderSide: const BorderSide(
////                                    color: Colors.blue, width: 2.0),
////                                borderRadius: BorderRadius.only(
////                                    topRight: Radius.circular(10),
////                                    topLeft: Radius.circular(10),
////                                    bottomRight: Radius.circular(10),
////                                    bottomLeft: Radius.circular(10)),
////                              ),
////                            ),
////                            validator: (val) => val.isEmpty ? '??' : null,
////                            onChanged: (val) {
////                              setState(() => modFluelConsumption = val);
////                            },
////                          )),
////                          SizedBox(width: 10),
////                          Flexible(
////                              child: TextFormField(
////                            decoration: InputDecoration(
////                              labelText: "high",
////                              fillColor: Colors.white,
////                              focusedBorder: OutlineInputBorder(
////                                borderSide: const BorderSide(
////                                    color: Colors.blue, width: 2.0),
////                                borderRadius: BorderRadius.only(
////                                    topRight: Radius.circular(10),
////                                    topLeft: Radius.circular(10),
////                                    bottomRight: Radius.circular(10),
////                                    bottomLeft: Radius.circular(10)),
////                              ),
////                            ),
////                            validator: (val) => val.isEmpty ? '??' : null,
////                            onChanged: (val) {
////                              setState(() => highFluelConsumption = val);
////                            },
////                          )),
//                        ],
//                      ),
                              SizedBox(height: 20),
                              // Container(
                              //   padding: EdgeInsets.symmetric(
                              //       vertical: 10, horizontal: 10),
                              //   decoration: BoxDecoration(
                              //     border: Border.all(
                              //       width: 1,
                              //       color: Colors.grey,
                              //     ),
                              //     borderRadius: BorderRadius.all(
                              //         Radius.circular(
                              //             5.0) //         <--- border radius here
                              //         ),
                              //   ),
                              //   child: Column(
                              //     mainAxisSize: MainAxisSize.min,
                              //     children: [
                              //       Row(
                              //         mainAxisAlignment:
                              //             MainAxisAlignment.spaceBetween,
                              //         children: [
                              //           Text('Amount of Excavation (m3/hr)',
                              //               style: TextStyle(
                              //                 fontSize: 16,
                              //               )),
                              //           IconButton(
                              //             icon: Icon(Icons.add,
                              //                 color: Colors.indigo),
                              //             onPressed: addDynamic,
                              //           ),
                              //         ],
                              //       ),
                              //       Flexible(
                              //         fit: FlexFit.loose,
                              //         child: new ListView.builder(
                              //           shrinkWrap: true,
                              //           physics: NeverScrollableScrollPhysics(),
                              //           scrollDirection: Axis.vertical,
                              //           itemCount: amountOfExavationCount,
                              //           itemBuilder: (context, index) {
                              //             return AmountOfExavation(
                              //                 index: index);
                              //           },
                              //         ),
                              //       )
                              //     ],
                              //   ),
                              // ),

                              // SizedBox(height: 20),
                              Text(
                                'Vendor Details',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                    color: Colors.black, fontSize: 16),
                              ),
                              SizedBox(height: 5),
                              TextFormField(
                                initialValue: vendorName,
                                decoration: InputDecoration(
                                  labelText: "Name",
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                ),
                                validator: (val) =>
                                    val.isEmpty ? 'Enter Name' : null,
                                onChanged: (val) {
                                  setState(() => vendorName = val);
                                },
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                validator: (val) {
                                if (val.isEmpty) return 'Enter Phone Number';
                                if (val.length < 10 || val.length > 10)
                                  return 'Enter a valid Phone Number';
                                else
                                  return null;
                              },
                                initialValue: vendorContact,
                                decoration: InputDecoration(
                                  labelText: "Contact No",
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.blue, width: 2.0),
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10)),
                                  ),
                                ),
                             
                                onChanged: (val) {
                                  setState(() => vendorContact = val);
                                },
                              ),

                              SizedBox(height: 20),

                              Row(
                               // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
//                                  RaisedButton(
//                                      child: Text(
//                                        'Save Changes',
//                                        style: TextStyle(color: Colors.white),
//                                      ),
//                                      onPressed: () {
//                                        if (_formKey.currentState.validate()) {
//                                          debugPrint("true");
//                                          addMachine();
//                                        }
//                                      },
//                                      color: Colors.blue,
//                                    ),
                                  FlatButton(
                                    child: buttonContainers(
                                         MediaQuery.of(context).size.width/2.5-25, 'Save', 17),
                                    onPressed: () {
                                      if (_formKey.currentState.validate()) {
                                        debugPrint("true");
                                        addMachine();
                                      }
                                    },
                                  ),


                            
                                  FlatButton(
                                    child: buttonContainers(
                                         MediaQuery.of(context).size.width/2.5-25, 'Delete', 17),
                                    onPressed: () {
                                      deleteMachine();
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ))
                    ]))));
  }
}

class AmountOfExavation extends StatefulWidget {
  final int index;
  AmountOfExavation({Key key, this.index}) : super(key: key);
  @override
  _AmountOfExavationState createState() => _AmountOfExavationState();
}

class _AmountOfExavationState extends State<AmountOfExavation> {
  String dropdownValue = 'One';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'For Soil Type',
                style: TextStyle(color: Colors.black, fontSize: 15),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: DropdownButton<String>(
                  value: soilTypeSelected[widget.index],
                  //icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  //style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.grey,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      soilTypeSelected[widget.index] = newValue;
                      debugPrint(widget.index.toString());
                    });
                  },
                  items: <String>['None', 'Type A', 'Type B', 'Type C']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: TextFormField(
                  //initialValue: excavationAmount[widget.index].text,
                  keyboardType: TextInputType.number,
                  controller: excavationAmount[widget.index],
                  validator: (val) => val.isEmpty ? 'Enter amount' : null,
                  decoration: InputDecoration(
                    labelText: "Excavation",
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
