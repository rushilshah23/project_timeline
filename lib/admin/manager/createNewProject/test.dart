import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoder/services/base.dart';
import '../../CommonWidgets.dart';
import 'projects.dart';

List<String> machineTypeSelected = [];
List<TextEditingController> usagePerDay = [];
List<GlobalKey<FormState>> machinesFormKeys = [];
int machinesCount = 1;
List<MachineDetails> machineDetailsList = [];

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  final GlobalKey<FormState> _formKeyValue = GlobalKey<FormState>();
  final GlobalKey<FormState> workDoneAlready = GlobalKey<FormState>();
  final CollectionReference supervisors =
      FirebaseFirestore.instance.collection("supervisor");

  //Project Name
  String projectName = '';
  var projectNameControl = TextEditingController();

  //Site Address
  String siteAddress = '';
  var siteAddressControl = TextEditingController();

  List coordinates = [];
  //Soil Type
  var soilType;
  List<String> _soilType = <String>[
    'Type A',
    'Type B',
    'Type C',
  ];

  List<int> selectedSupervisors = [];
  List<DropdownMenuItem> supervisorDropdwnItems = [];
  bool _termsChecked = false;

  ProgressDialog pr;

  double totalfuel = 0;
  double totalRent = 0;
  int days = 0;
  double volume;
  String status;
  double excavationDone = 0;
  double ourExcavtn = 0;
  double progressPercent = 0;

  //Length
  String length = '';
  var lenControl = TextEditingController();

  //Depth
  String depth = '';
  var depControl = TextEditingController();

  //Upper Width
  String upwidth = '';
  var upwidthControl = TextEditingController();

  //Upper Width
  String lowidth = '';
  var lowidthControl = TextEditingController();

  //Length
  String completedlength = '0';
  var completedlenControl = TextEditingController();

  //Depth
  String completeddepth = '0';
  var completeddepControl = TextEditingController();

  //Upper Width
  String completedupwidth = '0';
  var completedupwidthControl = TextEditingController();

  //Upper Width
  String completedlowidth = '0';
  var completedlowidthControl = TextEditingController();

  //supervisor
  var supervisor;

  List<SupervisorList> supervisorList = [];

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
    machineDetailsList.clear();
    // machineDetailsList.add(MachineDetails(machineID: 'None',machineName: 'None',modelName: 'None',amountOfExcavation: 'None',rentPerHour: 'None'));
    await databaseReference
        .child("masters")
        .child("machineMaster")
        .once()
        .then((snapshot) {
      snapshot.value.forEach((key, values) {
        setState(() {
//          ourMachines.add(values["machineName"]);
          machineDetailsList.add(MachineDetails(
              machineName: values['machineName'],
              machineID: values['machineID'],
              modelName: values['modelName'],
              amountOfExcavation: values['amountOfExcavation'],
              fuelConsumption: values["fuelConsumption"],
              rentPerHour: values["machineRent"]));
        });
//        debugPrint("in func"+ourMachines.toString());
      });
    });
  }

  sendToDb() async {

    int errorType=0;

    final CollectionReference supervisor =
        FirebaseFirestore.instance.collection("supervisor");

    var uuid = Uuid();
    String uniqueID = uuid.v1();

    try {
      var geocoding = AppState.of(context).mode;
      var results = await geocoding.findAddressesFromQuery(siteAddress);
      print("``````````````````````");

      errorType=1;
      debugPrint(results[0].coordinates.toString());
      this.setState(() {
        coordinates.add(results[0].coordinates);
      });

      errorType=2;
      FirebaseFirestore.instance.collection("markers").add({
        'location':
            new GeoPoint(coordinates[0].latitude, coordinates[0].longitude),
        'place': siteAddress,
        'projectID': uniqueID,
      });
      databaseReference.child("projects").child(uniqueID).set({
        'projectName': projectName,
        'siteAddress': siteAddress,
        'soilType': soilType,
        'projectID': uniqueID,
        'volumeToBeExcavated': volume.ceil().toString(),
        'volumeExcavated': excavationDone.ceil().toString(),
        'totalMachineRent': totalRent.ceil().toString(),
        'totalFuelConsumption': totalfuel.ceil().toString(),
        'projectDuration': days.toString(),
        'projectStatus': status,
        'progressPercent': progressPercent.floor().toString(),
        'dimensions': {
          'length': length.toString(),
          'depth': depth.toString(),
          'upperWidth': upwidth.toString(),
          'lowerWidth': lowidth.toString(),
        },
        'machinesSelected': {
          for (int i = 0; i < machinesCount; i++)
            '$i': {
              'machineID': machineTypeSelected[i].toString(),
              'usagePerDay': usagePerDay[i].text.toString(),
            },
        },
      });
      errorType=3;
      selectedSupervisors.forEach((i) async {
        debugPrint(supervisorList[i].uid);
        await supervisor
            .doc(supervisorList[i].uid)
            .update({"assignedProject": uniqueID});
        await databaseReference
            .child("projects")
            .child(uniqueID)
            .child("supervisors")
            .child(supervisorList[i].uid)
            .set({
          "name": supervisorList[i].name,
          "mobile": supervisorList[i].mobile,
        });
      });
      showToast("Project added Successfully");


                  Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  CreatedProjects(),),
                      );



    } catch (e) {
      print(e);
     

      if(errorType==0)
          showToast("Enter Valid Address");
       if(errorType==1)
           showToast("Failed. check your internet!");
    }
  }

  Future<void> getData() async {
    await supervisors.get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
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

          supervisorList.add(SupervisorList(
              name: result['name'],
              mobile: result['mobile'],
              uid: result['uid']));
        });
      });
    });
  }

  @override
  void initState() {
    machinesCount = 1;
    machineTypeSelected = List.generate(24, (i) => null);
    usagePerDay = List.generate(24, (i) => TextEditingController(text: '10'));
    machinesFormKeys = List.generate(24, (i) => GlobalKey<FormState>());
    getData();
    loadMachines();
    super.initState();
  }

  Widget workedStarted() {
    return Form(
        key: workDoneAlready,
        child: Container(
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
                Text('Completed Work',
                    style:
                        TextStyle(fontSize: 15, fontStyle: FontStyle.italic)),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
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
                        controller: completedlenControl,
                        validator: (val) => val.isEmpty ? 'Enter length' : null,
                        onChanged: (val) {
                          setState(() => completedlength = val);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Flexible(
                      child: TextFormField(
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
                        controller: completeddepControl,
                        validator: (val) => val.isEmpty ? 'Invalid' : null,
                        onChanged: (val) {
                          setState(() => completeddepth = val);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: TextFormField(
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
                        controller: completedupwidthControl,
                        validator: (val) => val.isEmpty ? 'Invalid' : null,
                        onChanged: (val) {
                          setState(() => completedupwidth = val);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20.0,
                    ),
                    Flexible(
                      child: TextFormField(
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
                        controller: completedlowidthControl,
                        validator: (val) => val.isEmpty ? 'Invalid' : null,
                        onChanged: (val) {
                          setState(() => completedlowidth = val);
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5),
              ],
            )));
  }

  Future<bool> estimate2() async {
    volume = 0.5 *
        double.parse(length) *
        double.parse(depth) *
        (double.parse(upwidth) + double.parse(lowidth)) *
        0.8;

    if (_termsChecked == true) {
      double cvolume = 0.5 *
          double.parse(completedlength) *
          double.parse(completeddepth) *
          (double.parse(completedupwidth) + double.parse(completedlowidth)) *
          0.8;
      ourExcavtn = cvolume;
    } else
      ourExcavtn = 0;

    setState(() {
      excavationDone = ourExcavtn;

      progressPercent = (excavationDone / volume) * 100;
    });


    if(progressPercent<=100)
    {
    if (ourExcavtn == 0.0) {
      setState(() {
        status = 'Not Started';
      });
    } else if (ourExcavtn > 0.0) {
      setState(() {
        status = 'Ongoing';
      });
    } else if (ourExcavtn > volume) {
      setState(() {
        status = 'Completed';
      });
    }

    debugPrint("our excavation" + ourExcavtn.toString());
    debugPrint(volume.toString());

    List perhramountofExca = [];
    List perhrFuelConsump = [];
    List renthrday = [];

    double sumfuel = 0;
    double sumRent = 0;
    double sumExcavtn = 0;
    double sumUsagePrDay = 0;

    double beyondMeansumExcavtn = 0;
    double beyondMeanExcasumRent = 0;
    double beyondMeansumfuel = 0;

    List actualperdayamountofExca = [];
    List actualperdayFuelConsump = [];
    List actualrentPerday = [];

    for (int i = 0; i < machinesCount; i++) {
      debugPrint(machineTypeSelected[i].toString());
      debugPrint(usagePerDay[i].text);

      for (int j = 0; j < machineDetailsList.length; j++) {
        if (machineTypeSelected[i] == machineDetailsList[j].machineID) {
          sumExcavtn = sumExcavtn +
              double.parse(machineDetailsList[j].amountOfExcavation.toString());
          sumUsagePrDay = sumUsagePrDay + double.parse(usagePerDay[i].text);
          sumfuel = sumfuel +
              double.parse(machineDetailsList[j].fuelConsumption.toString());
          sumRent = sumRent +
              double.parse(machineDetailsList[j].rentPerHour.toString());

          perhramountofExca.add(double.parse(
              machineDetailsList[j].amountOfExcavation.toString()));
          perhrFuelConsump.add(
              double.parse(machineDetailsList[j].fuelConsumption.toString()));
          renthrday
              .add(double.parse(machineDetailsList[j].rentPerHour.toString()));
        }
      }
    }

    //excavation of machines whose usage time is greater than mean hours

    for (int i = 0; i < machinesCount; i++) {
      debugPrint(machineTypeSelected[i].toString());
      debugPrint(usagePerDay[i].text);
      if ((sumUsagePrDay / machinesCount) < perhramountofExca[i]) {
        beyondMeansumExcavtn = beyondMeansumExcavtn + perhramountofExca[i];
        beyondMeanExcasumRent = beyondMeanExcasumRent + renthrday[i];
        beyondMeansumfuel = beyondMeansumfuel + perhrFuelConsump[i];
      }
    }

    debugPrint("sum " + sumExcavtn.toString());
    debugPrint((sumUsagePrDay / machinesCount).toString());
    debugPrint(beyondMeansumExcavtn.toString());

    for (int i = 1; ourExcavtn < volume; i++) {
      if (ourExcavtn + sumExcavtn > volume && ourExcavtn < volume) {
        double temp = volume - ourExcavtn;
        double percent = ((temp / sumExcavtn));

        ourExcavtn = ourExcavtn + temp;
        debugPrint("came here--------------");
        totalfuel = sumfuel * percent + totalfuel;
        totalRent = sumRent + totalRent;

        actualperdayamountofExca.add(temp);
        actualperdayFuelConsump.add(sumfuel * percent);
        actualrentPerday.add(sumRent);

        debugPrint("here the exca--" + (sumExcavtn * percent).toString());
        break;
      } else if (ourExcavtn + sumExcavtn < volume && ourExcavtn < volume) {
        ourExcavtn = ourExcavtn + sumExcavtn;
        if (beyondMeansumExcavtn + ourExcavtn > volume && ourExcavtn < volume) {
          debugPrint("ourExcavtn" + ourExcavtn.toString());
          double temp = volume - ourExcavtn;
          double percent = ((temp / sumExcavtn));
          ourExcavtn = ourExcavtn + temp;

          totalfuel = sumfuel + beyondMeansumfuel * percent + totalfuel;
          totalRent = sumRent + beyondMeanExcasumRent + totalRent;

          debugPrint("temp" + temp.toString());

          actualperdayamountofExca.add(temp + sumExcavtn);
          actualperdayFuelConsump.add(sumfuel + beyondMeansumfuel * percent);
          actualrentPerday.add(sumRent + beyondMeanExcasumRent);
          break;
        } else {
          ourExcavtn = ourExcavtn + beyondMeansumExcavtn;

          totalfuel = sumfuel + beyondMeansumfuel + totalfuel;
          totalRent = sumRent + beyondMeanExcasumRent + totalRent;

          actualperdayamountofExca.add(beyondMeansumExcavtn + sumExcavtn);
          actualperdayFuelConsump.add(sumfuel + beyondMeansumfuel);
          actualrentPerday.add(sumRent + beyondMeanExcasumRent);
        }
      }

      days = i;
    }

    debugPrint(
        "--------------------------------------" + ourExcavtn.toString());
    debugPrint(days.toString());
    debugPrint(actualperdayamountofExca.toString());
    debugPrint(actualperdayFuelConsump.toString());
    debugPrint(actualrentPerday.toString());
    debugPrint(totalRent.toString());
    debugPrint(totalfuel.toString());

    return true;
    }

    else return false;

  }

  showAlertDialog(BuildContext context) async {
    var state= await estimate2();
    // set up the buttons

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Dear User"),
      content: Builder(builder: (context) {
        // Get available height and width of the build area of this widget. Make a choice depending on the size.
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;
        return Container(
            height: height / 1.8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text("Total Volume: " + ourExcavtn.ceil().toString() + "m3"),
                SizedBox(
                  height: 10,
                ),
                Text("No of Days: " + days.toString()),
                SizedBox(
                  height: 10,
                ),
                Text("Total Rent of Machines Used: " +
                    totalRent.ceil().toString() +
                    " Rs"),
                SizedBox(
                  height: 10,
                ),
                Text("Total Fuel requires: " +
                    totalfuel.ceil().toString() +
                    " litre"),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Text("Do you want to create this project?"),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: () {
                        debugPrint('Create Project');
                      
                        sendToDb();
                      },
                      child: Text("Create Project"),
                    ),
                  ],
                )
              ],
            ));
      }),
    );


     AlertDialog alert2 = AlertDialog(
      title: Text("Dear User"),
      content: Builder(builder: (context) {
        // Get available height and width of the build area of this widget. Make a choice depending on the size.
        var height = MediaQuery.of(context).size.height;
      
        return Container(
            height: height /3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Text("The work is already completed and the completed work is greater than the project goals."),
                SizedBox(
                  height: 10,
                ),
                Text("Hence the progress is > 100% which is not true."),
                 SizedBox(
                  height: 10,
                ),
                Text("Thus put proper goals."),
               
              ],
            ));
      }),
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return state?alert:alert2;

      },
    );
  }

  Widget build(BuildContext context) {
    pr = pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);

    return Scaffold(
        appBar: ThemeAppbar("Create Project",context),
        body: SingleChildScrollView(
          child: Form(
            key: _formKeyValue,
            //autovalidate: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                children: <Widget>[
                  Center(
                    child: titleStyles('Create  Project', 24),
                  ),
                  SizedBox(height: 20),

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
                    validator: (val) =>
                        val.isEmpty ? 'Enter project name' : null,
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
                    validator: (val) =>
                        val.isEmpty ? 'Enter site address' : null,
                    onChanged: (val) {
                      setState(() => siteAddress = val);
                    },
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
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
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //         <--- border radius here
                          ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Select Machines',
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                            IconButton(
                              icon:
                                  Icon(Icons.remove, color: Colors.indigo[900]),
                              onPressed: removeDynamic,
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.indigo[900]),
                              onPressed: addDynamic,
                            ),
                          ],
                        ),
                        Flexible(
                          fit: FlexFit.loose,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: machinesCount,
                            itemBuilder: (context, index) {
                              return SelectMachines(index: index);
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
                      borderRadius: BorderRadius.all(Radius.circular(
                              5.0) //         <--- border radius here
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
                            Flexible(
                              child: TextFormField(
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
                            Flexible(
                              child: TextFormField(
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
                            Flexible(
                              child: TextFormField(
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
                            Flexible(
                              child: TextFormField(
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
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                        //borderRadius: BorderRadius.circular(30.0),
                        borderRadius: BorderRadius.all(Radius.circular(
                                5.0) //         <--- border radius here
                            ),
                        border: Border.all(
                          width: 1.0,
                          color: Colors.grey,
                        ),
                      ),
                      child: CheckboxListTile(
                        value: _termsChecked,
                        onChanged: (value) {
                          setState(() {
                            _termsChecked = value;
                          });
                        },
                        subtitle: _termsChecked ? workedStarted() : null,
                        title: Text(
                          'Worked Started?',
                        ),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ),


                  SizedBox(
                    height: 20,
                  ),
                  SearchableDropdown.multiple(
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
                        debugPrint("vvvvvvvvvvvvvvvvvvv  " + value.toString());
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
                  SizedBox(height: 40.0),
                  RaisedButton(
                    color: Color(0xff018abd),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                      child: Center(
                          child: Text(
                        'Estimate Project',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      )),
                    ),
                    onPressed: () {
                      bool isFormValid = false;
                      if (_formKeyValue.currentState.validate()) {
                        if (_termsChecked == true) {
                          workDoneAlready.currentState.validate();
                        }
                        for (int i = 0; i < machinesCount; i++) {
                          if (machinesFormKeys[i].currentState.validate())
                            isFormValid = true;
                          else {
                            isFormValid = false;
                            break;
                          }
                        }
                        if (isFormValid)
                          showAlertDialog(context);
                        else
                          showToast("Incomplete form");
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}

class SupervisorList {
  SupervisorList({Key key, this.name, this.mobile, this.uid});
  var name;
  var mobile;
  var uid;
}

class MachineDetails {
  MachineDetails(
      {Key key,
      this.machineName,
      this.machineID,
      this.modelName,
      this.amountOfExcavation,
      this.fuelConsumption,
      this.rentPerHour});
  var machineName;
  var machineID;
  var modelName;
  var amountOfExcavation;
  var fuelConsumption;
  var rentPerHour;
}

class EstimationDetails {
  EstimationDetails(
      {Key key,
      this.noOfDays,
      this.totalRent,
      this.totalFuel,
      this.totalExcavation});
  var noOfDays;
  var totalRent;
  var totalFuel;
  var totalExcavation;
}

class SelectMachines extends StatefulWidget {
  final int index;
  SelectMachines({Key key, this.index}) : super(key: key);
  @override
  _SelectMachinesState createState() => _SelectMachinesState();
}

class _SelectMachinesState extends State<SelectMachines> {
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Form(
      key: machinesFormKeys[widget.index],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: machineTypeSelected[widget.index],
                  //icon: Icon(Icons.arrow_downward),
                  hint: Text(
                    'Select Machine',
                    style: TextStyle(color: Colors.black54, fontSize: 17),
                  ),
                  //style: TextStyle(color: Colors.deepPurple),
                  validator: (val) => val == null ? 'Select machine' : null,
                  onChanged: (Value) {
                    setState(() {
                      machineTypeSelected[widget.index] = Value;
                      debugPrint(Value.toString());
                    });
                  },
                  items: machineDetailsList
                      .map<DropdownMenuItem<String>>((var value) {
                    return DropdownMenuItem<String>(
                      value: value.machineID,
                      child: Text(value.machineName),
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

class AppState extends InheritedWidget {
  const AppState({
    Key key,
    this.mode,
    Widget child,
  })  : assert(mode != null),
        assert(child != null),
        super(key: key, child: child);

  final Geocoding mode;

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType();
  }

  @override
  bool updateShouldNotify(AppState old) => mode != old.mode;
}
