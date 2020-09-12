import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../CommonWidgets.dart';
import '../CommonWidgets.dart';


List<String> machineTypeSelected = List.generate(74, (i) => 'None');
List<TextEditingController> usagePerDay =
List.generate(74, (i) => TextEditingController());
int machinesCount=1;

List<MachineDetails> machineDetailsList = [MachineDetails(machineID: 'None',machineName: 'None',modelName: 'None',amountOfExcavation: 'None')];
List<DropdownMenuItem> machines = [];




class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}



class _TestState extends State<Test> {
  var selectedType;
  final GlobalKey<FormState> _formKeyValue = new GlobalKey<FormState>();
  final CollectionReference supervisors =
      Firestore.instance.collection("supervisor");

  //Project Name
  String projectName = '';
  var projectNameControl = new TextEditingController();

  //Site Address
  String siteAddress = '';
  var siteAddressControl = new TextEditingController();

  //Soil Type
  var soilType;
  List<String> _soilType = <String>[
    'Type A',
    'Type B',
    'Type C',
  ];

  List<int> selectedSupervisors = [];
  List<DropdownMenuItem> supervisorDropdwnItems = [];




  //Length
  String length = '';
  var lenControl = new TextEditingController();

  //Depth
  String depth = '';
  var depControl = new TextEditingController();

  //Upper Width
  String upwidth = '';
  var upwidthControl = new TextEditingController();

  //Upper Width
  String lowidth = '';
  var lowidthControl = new TextEditingController();

  //supervisor
  var supervisor;

  List<SupervisorList> supervisorList = [];

  //petrolPump
  var petrolPump;
  List<String> _petrolPump = <String>[
    'Soft',
    'Rough',
    'Rocky',
  ];

  final databaseReference = FirebaseDatabase.instance.reference();


  removeDynamic() {
    setState(() {
      if (machinesCount > 0) machinesCount = machinesCount - 1;
    });
  }

  addDynamic() {
    machinesCount = machinesCount + 1;
    setState(() {});
  }



  void loadMachines() async {
    await databaseReference
        .child("masters")
        .child("machineMaster")
        .once()
        .then((snapshot) {
      snapshot.value.forEach((key, values) {
        setState(() {
          machines.add(
            DropdownMenuItem(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                    Text(values["machineName"]),
                    Text(
                    values['modelName'],
                    style: TextStyle(color: Colors.grey,fontSize: 14),
                  ),

                ],
              )),
              value: values["machineName"],
            ),
          );

//          ourMachines.add(values["machineName"]);
          machineDetailsList.add(MachineDetails(
              machineName:values['machineName'],machineID: values['machineID'],modelName: values['modelName'],
              amountOfExcavation: values['amountOfExcavation'],fuelConsumption: values["fuelConsumption"]));
        });
//        debugPrint("in func"+ourMachines.toString());

      });
    });
  }

  Future<void> getData() async {
    await supervisors.getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        setState(() {
          supervisorDropdwnItems.add(
            DropdownMenuItem(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(result['name']),
                  Text(
                    result['mobile'],
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              )),
              value: result['name'],
            ),
          );

          supervisorList.add(
              SupervisorList(result['name'], result['mobile'], result['uid']));
        });
      });
    });
  }

  @override
  void initState() {
    getData();
    loadMachines();
    super.initState();
  }

  @override
  Widget _buildAboutDialog(
      BuildContext context, String l, String d, String uw, String lw) {
    double len = double.parse(l);
    double dep = double.parse(d);
    double uwi = double.parse(uw);
    double lwi = double.parse(lw);

    double volume = 0.5 * len * dep * (uwi + lwi)*0.8;
    double ourExcavtn=0;
    int days=0;



    while(ourExcavtn!=volume)
    {
      for(int i=0 ;i<machinesCount;i++)
      {

        debugPrint("machines used id"+ machineTypeSelected[i]);
        debugPrint("usage per day"+usagePerDay[i].text);

        for(int j=0 ;j<machineDetailsList.length;j++)
        {
          if(machineTypeSelected[i]==machineDetailsList[j].machineID)
          {
            debugPrint("its amountOfExcavation"+machineDetailsList[j].amountOfExcavation.toString());
            debugPrint("its fuelConsumption"+machineDetailsList[j].fuelConsumption.toString());
            ourExcavtn=ourExcavtn + machineDetailsList[j].amountOfExcavation*double.parse(usagePerDay[i].text);
            debugPrint("our excvation"+ourExcavtn.toString());
            break;
          }
        }

      }

      days=days+1;
      debugPrint("day="+days.toString());
    }





    return new AlertDialog(
        title: const Text('Project Timeline'),
        content: RichText(
          text: new TextSpan(
            text:
                'Duration:\n\nMachinery:\n\nCost of Fuel:\n\nVolume to be excavated: $volume\n\n\n\n',
            style: const TextStyle(color: Colors.black87),
            children: <TextSpan>[
              const TextSpan(text: 'Do you want to create project?'),
            ],
          ),
        ),
        actions: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            textColor: Theme.of(context).primaryColor,
            child: const Text('Create Project'),
          ),
        ]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          iconTheme: IconThemeData(
            color: Colors.orange[800],
          ),
          title:  Text("Add New Project", style: TextStyle(
            color: Colors.orange[800],
          )),
          backgroundColor: Colors.white,
        ),
        body: Form(
          key: _formKeyValue,
          //autovalidate: true,
          child: new ListView(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            children: <Widget>[
              Center(
                child: Text(
                  'Create New Project',
                  style: titlestyles(24, Colors.orange[700]),
                ),
              ),
              SizedBox(height: 20,),
              TextFormField(
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Project Name",
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
                controller: projectNameControl,
                validator: (val) => val.isEmpty ? 'Enter project name' : null,
                onChanged: (val) {
                  setState(() => projectName = val);
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  labelText: "Site Address",
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
                controller: siteAddressControl,
                validator: (val) => val.isEmpty ? 'Enter site address' : null,
                onChanged: (val) {
                  setState(() => siteAddress = val);
                },
              ),
              SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: new DropdownButtonFormField(
                    validator: (value) =>
                    value == null ? 'Enter soil type' : null,
                    items: _soilType
                        .map((value) => DropdownMenuItem(
                              child: Text(
                                value,
                                style: TextStyle(color: Colors.deepPurple[900]),
                              ),
                              value: value,
                            ))
                        .toList(),
                    onChanged: (selectedAccountType) {
                      print('$selectedAccountType');
                      setState(() {
                        soilType = selectedAccountType;
                      });
                    },
                    value: soilType,
                    isExpanded: true,
                    hint: Text(
                      'Select Soil Type',
                      style: TextStyle(color: Colors.black54, fontSize: 17),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),




              Container(
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.grey,
                  ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(
                          5.0) //         <--- border radius here
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Machines',
                            style: TextStyle(
                              fontSize: 16,
                            )),

                        IconButton(
                          icon:
                          Icon(Icons.remove, color: Colors.deepOrange),
                          onPressed: removeDynamic,
                        ),
                        IconButton(
                          icon: Icon(Icons.add,
                              color: Colors.deepOrange),
                          onPressed: addDynamic,
                        ),
                      ],
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: new ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: machinesCount,
                        itemBuilder: (context, index) {
                          return SelectMachines(
                              index: index);
                        },
                      ),
                    )
                  ],
                ),
              ),





              SizedBox(height: 20),


              Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.grey,
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(5.0) //         <--- border radius here
                        ),
                  ),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PROJECT GOALS',
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic)),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: "Length",
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
                              controller: lenControl,
                              validator: (val) =>
                                  val.isEmpty ? 'Enter length' : null,
                              onChanged: (val) {
                                setState(() => length = val);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          new Flexible(
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: "Depth",
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
                              controller: depControl,
                              validator: (val) =>
                                  val.isEmpty ? 'Enter project name' : null,
                              onChanged: (val) {
                                setState(() => depth = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Flexible(
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: "Upper Width",
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
                              controller: upwidthControl,
                              validator: (val) =>
                                  val.isEmpty ? 'Enter project name' : null,
                              onChanged: (val) {
                                setState(() => upwidth = val);
                              },
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          new Flexible(
                            child: new TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                labelText: "Lower Width",
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
                              controller: lowidthControl,
                              validator: (val) =>
                                  val.isEmpty ? 'Enter project name' : null,
                              onChanged: (val) {
                                setState(() => lowidth = val);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                    ],
                  )),
              SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Center(
                    child: SearchableDropdown.multiple(
                      items: supervisorDropdwnItems,
                      selectedItems: selectedSupervisors,
                      hint: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("Select Supervisors"),
                      ),
                      searchHint: "Select any",
                      onChanged: (value) {
                        setState(() {
                          selectedSupervisors = value;
                        });
                        print(selectedSupervisors.toString());
                      },
                      closeButton: (selectedItems) {
                        return (selectedItems.isNotEmpty
                            ? "Save ${selectedItems.length == 1 ? '"' + supervisorDropdwnItems[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                            : "Save without selection");
                      },
                      isExpanded: true,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
//              Container(
//                decoration: BoxDecoration(
//                  border: Border.all(color: Colors.grey),
//                  borderRadius: BorderRadius.circular(5),
//                ),
//                child: Padding(
//                  padding: const EdgeInsets.all(4.0),
//                  child: DropdownButton(
//                    items: _petrolPump
//                        .map((value) => DropdownMenuItem(
//                              child: Text(
//                                value,
//                                style: TextStyle(color: Colors.deepPurple[900]),
//                              ),
//                              value: value,
//                            ))
//                        .toList(),
//                    onChanged: (selectedAccountType) {
//                      print('$selectedAccountType');
//                      setState(() {
//                        petrolPump = selectedAccountType;
//                      });
//                    },
//                    value: petrolPump,
//                    isExpanded: true,
//                    hint: Text(
//                      'NearBy Petrol Pump',
//                      style: TextStyle(color: Colors.black54, fontSize: 17),
//                    ),
//                  ),
//                ),
//              ),
              SizedBox(height: 40.0),
              FlatButton(
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width-40,
                  decoration: BoxDecoration(
                    gradient: gradients()
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Center(child:Text(
                      'Estimate Project',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    )),
                  ),
                ),
                onPressed: () {
                  if (_formKeyValue.currentState.validate() ) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => _buildAboutDialog(
                          context, length, depth, upwidth, lowidth),
                    );
                  }
                },

              ),
            ],
          ),
        ));
  }
}

class SupervisorList {
  SupervisorList(this.name, this.mobile, this.uid);
  var name;
  var mobile;
  var uid;
}

class MachineDetails {
  MachineDetails({Key key, this.machineName, this.machineID, this.modelName,this.amountOfExcavation,this.fuelConsumption});
  var machineName;
  var machineID;
  var modelName;
  var amountOfExcavation;
  var fuelConsumption;
}


class SelectMachines extends StatefulWidget {
  final int index;
  SelectMachines({Key key, this.index}) : super(key: key);
  @override
  _SelectMachinesState createState() => _SelectMachinesState();
}

class _SelectMachinesState extends State<SelectMachines> {
  String dropdownValue = 'One';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



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
//                  Text(
//                    'For Soil Type',
//                    style: TextStyle(color: Colors.black, fontSize: 15),
//                  ),
//                  SizedBox(
//                    width: 10,
//                  ),
                  Flexible(
                    flex: 3,
                    child: DropdownButton<String>(
                      value: machineTypeSelected[widget.index],
                      //icon: Icon(Icons.arrow_downward),

                      //style: TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.grey,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          machineTypeSelected[widget.index] = newValue;
                          debugPrint(newValue.toString());
                        });
                      },
                      items: machineDetailsList.map<DropdownMenuItem<String>>((var value) {
                        return DropdownMenuItem<String>(
                          value: value.machineID,
                          child:Text(value.machineName),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 1,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: usagePerDay[widget.index],
                      validator: (val) => val.isEmpty ? 'Enter Hours' : null,
                      decoration: InputDecoration(
                        labelText: "Usage/Day",
                        hintText: "Hours",
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
