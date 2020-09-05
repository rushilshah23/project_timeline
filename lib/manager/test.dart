import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

import '../CommonWidgets.dart';
import '../CommonWidgets.dart';

String machineType = 'One';
List<String> machineTypeSelected = List.generate(74, (i) => 'One');
List<TextEditingController> _machineQuantity =
    List.generate(74, (i) => TextEditingController());

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

  List<DropdownMenuItem> machines = [];
  List<int> selectedMachine = [];
  List<String> machineUsed = [];

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
  List<MachineDetails> machineDetailsList = [];
  //petrolPump
  var petrolPump;
  List<String> _petrolPump = <String>[
    'Soft',
    'Rough',
    'Rocky',
  ];

  final databaseReference = FirebaseDatabase.instance.reference();

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
                    style: TextStyle(color: Colors.grey),
                  ),

                ],
              )),
              value: values["machineName"],
            ),
          );

          machineDetailsList.add(MachineDetails(
              values['machineName'], values['machineID'], values['modelName']));
        });
        print(machines);
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
    double calc = 0.5 * len * dep * (uwi + lwi);
    return new AlertDialog(
        title: const Text('Project Timeline'),
        content: RichText(
          text: new TextSpan(
            text:
                'Duration:\n\nMachinery:\n\nCost of Fuel:\n\nVolume to be excavated: $calc\n\n\n\n',
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
                  child: DropdownButton(
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
                child: SearchableDropdown.multiple(
                  items: machines,
                  selectedItems: selectedMachine,
                  hint: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Select any"),
                  ),
                  searchHint: "Select any",
                  onChanged: (value) {
                    setState(() {
                      selectedMachine = value;
                    });
                    print(value);
                    print(selectedMachine);
                  },
                  closeButton: (selectedMachine) {
                    return (selectedMachine.isNotEmpty
                        ? "Save ${selectedMachine.length == 1 ? '"' + machines[selectedMachine.first].value.toString() + '"' : '(' + selectedMachine.length.toString() + ')'}"
                        : "Save without selection");
                  },
                  isExpanded: true,
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
                  width: 400,
                  decoration: BoxDecoration(
                    gradient: gradients()
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15,left: 120),
                    child: Text(
                      'Estimate Project',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKeyValue.currentState.validate()) {
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
  MachineDetails(this.machineName, this.machineID, this.modelName);
  var machineName;
  var machineID;
  var modelName;
}
