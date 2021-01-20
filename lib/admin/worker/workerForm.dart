import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:project_timeline/languages/setLanguageText.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../CommonWidgets.dart';

int timeIntervals;
List<DateTime> startTime = List.generate(74, (i) => DateTime.now());
List<DateTime> endTime = List.generate(74, (i) => DateTime.now());

class WorkerForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Update work"),
//      ),
      body: WorkerFormPage(),
    );
  }
}

class WorkerFormPage extends StatefulWidget {
  String name, email, mobile, password, uid, userType, assignedProject;
  WorkerFormPage(
      {Key key,
      this.name,
      this.email,
      this.mobile,
      this.assignedProject,
      this.userType,
      this.uid})
      : super(key: key);
  @override
  _WorkerFormPageState createState() => _WorkerFormPageState();
}

class _WorkerFormPageState extends State<WorkerFormPage> {
  List<DropdownMenuItem> machines = [];
  List<MachineDetails> machineDetails = [];
  String selectedMachine, machineUsed;
  var hoursWorked,
      depth,
      length,
      upperWidth,
      lowerWidth,
      todaysDate,
      volume,
      comment,
      estimateVolume,
      estimation,
      exacavatedPerHour,
      workDifference;
  final databaseReference = FirebaseDatabase.instance.reference();
  final _formKey = GlobalKey<FormState>();
  TextEditingController depthController = TextEditingController();
  TextEditingController lengthController = TextEditingController();
  TextEditingController upperWidthController = TextEditingController();
  TextEditingController lowerWidthController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  var projectID = "b570da70-fa93-11ea-9561-89a3a74b28bb";
  var workerID = '8YiMHLBnBaNjmr3yPvk8NWvNPmm2';
  var workerName = 'rajesh kumar';
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  List _uploadedFileURL = [];
  ProgressDialog pr;
  List<File> filesToBeUploaded = [];

  @override
  void initState() {
    setState(() {
      loadData();

      projectID = widget.assignedProject;
      workerName = widget.name;
      workerID = widget.uid;
    });
    timeIntervals = 1;
    super.initState();
    todaysDate = formatter.format(now);
  }

  Widget buildGridView() {
    return Container(
        height: MediaQuery.of(context).size.height / 4,
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(images.length, (index) {
            Asset asset = images[index];
            return AssetThumb(
              asset: asset,
              width: 300,
              height: 300,
            );
          }),
        ));
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = workerText[23];

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: workerText[24],
          allViewTitle: workerText[25],
          useDetailsView: false,
          selectCircleStrokeColor: "#000000",
        ),
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      _error = error;
    });
  }

  void loadData() async {
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
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              value: values["machineID"].toString() +
                  "," +
                  values["machineName"].toString() +
                  "," +
                  values['modelName'].toString(),
            ),
          );
          machineDetails.add(MachineDetails(
              values["machineID"], values["amountOfExcavation"]));
        });
      });
    });
    print("````````````````````````````");
    machineDetails.forEach((element) {
      print(element.excavation);
    });
  }

  Future uploadFile() async {
    _uploadedFileURL.clear();
    filesToBeUploaded.clear();
    for (int i = 0; i < images.length; i++) {
      var path =
          await FlutterAbsolutePath.getAbsolutePath(images[i].identifier);
      filesToBeUploaded.add(File(path));
      debugPrint(images[i].identifier.toString());
    }
//    debugPrint(filesToBeUploaded.toString());
    for (int i = 0; i < filesToBeUploaded.length; i++) {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child("projects/$projectID/$todaysDate/$workerID/" + images[i].name);
      StorageUploadTask uploadTask =
          storageReference.putFile(filesToBeUploaded[i]);
      await uploadTask.onComplete;
//      print('File Uploaded');
      await storageReference.getDownloadURL().then((fileURL) {
        setState(() {
          _uploadedFileURL.add(fileURL);
        });
      });
    }

    debugPrint(_uploadedFileURL.toString());
    debugPrint("done-------------------------------------------");
    Navigator.of(context).pop();
  }

  void submitForm() async {
    if (_formKey.currentState.validate()) {
      await pr.show();
      machineUsed = selectedMachine.split(",")[0];
      hoursWorked = 0;
      for (int i = 0; i < timeIntervals; i++) {
        hoursWorked += endTime[i].difference(startTime[i]).inHours;
      }
      print(hoursWorked);
      if (hoursWorked > 0 && selectedMachine != null) {
        setState(() {
          machineDetails.forEach((machine) {
            if (machine.machineID == machineUsed) {
              exacavatedPerHour = double.parse(machine.excavation.toString());
            }
          });
          depth = double.parse(depthController.text);
          length = double.parse(lengthController.text);
          upperWidth = double.parse(upperWidthController.text);
          lowerWidth = double.parse(lowerWidthController.text);
          comment = commentController.text;
          volume = length * depth * (upperWidth + lowerWidth) / 2;
          estimateVolume = hoursWorked * exacavatedPerHour;
          workDifference = (volume - estimateVolume) / estimateVolume * 100;
          estimation = estimateVolume < volume ? "Pass" : "Fail";
          print(estimation);
        });
        if (images.length > 0) {
          await uploadFile();
          addtoDB();
        } else if (images.length == 0) {
          addtoDB();
        }
      } else {
        pr.hide();
        if (selectedMachine != null) showToast(workerText[26]);
        if (hoursWorked > 0) showToast(workerText[27]);
      }
    }
  }

  addtoDB() async {
    try {
      await databaseReference
          .child("projects")
          .child(projectID)
          .child("progress")
          .child(todaysDate)
          .child(workerID)
          .set({
        "MachineUsed": machineUsed,
        "hoursWorked": hoursWorked,
        "workerID": workerID,
        'intervals': {
          for (int i = 0; i < timeIntervals; i++)
            '$i': {
              'startTime': startTime[i].toString(),
              'endTime': endTime[i].toString(),
            }
        },
        'images': {
          for (int i = 0; i < _uploadedFileURL.length; i++)
            '$i': _uploadedFileURL[i].toString(),
        },
        "workerName": workerName,
        "depth": depth,
        "length": length,
        "upperWidth": upperWidth,
        "lowerWidth": lowerWidth,
        "volumeExcavated": volume,
        "estimatedVolume": estimateVolume,
        "workDifference": workDifference,
        "result": estimation,
        "status": "Pending",
        "comment": comment,
      });

      pr.hide().then((isHidden) {
        showToast(workerText[28]);
      });
    } catch (e) {
      pr.hide().then((isHidden) {
        showToast(workerText[29]);
      });
    }
  }

  addDynamic() {
    setState(() {
      timeIntervals = timeIntervals + 1;
    });
  }

  removeDynamic() {
    setState(() {
      if (timeIntervals > 0) timeIntervals = timeIntervals - 1;
    });
  }

  Widget build(BuildContext context) {
    pr = pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    if (machines.length > 0)
      return Scaffold(
        body: Container(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Center(
                    child: titleStyles(workerText[30] + todaysDate, 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SearchableDropdown.single(
                    items: machines,
                    value: selectedMachine,
                    hint: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(workerText[31]),
                    ),
                    searchHint: workerText[31],
                    onChanged: (value) {
                      setState(() {
                        selectedMachine = value;
                      });
                    },
                    doneButton: workerText2[0],
                    displayItem: (item, selected) {
                      return (Row(children: [
                        selected
                            ? Icon(
                                Icons.radio_button_checked,
                                color: Colors.grey,
                              )
                            : Icon(
                                Icons.radio_button_unchecked,
                                color: Colors.grey,
                              ),
                        SizedBox(width: 7),
                        Expanded(
                          child: item,
                        ),
                      ]));
                    },
                    isExpanded: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                            Text(
                              workerText2[1],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            IconButton(
                              icon:
                                  Icon(Icons.remove, color: Colors.deepOrange),
                              onPressed: removeDynamic,
                            ),
                            IconButton(
                              icon: Icon(Icons.add, color: Colors.deepOrange),
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
                            itemCount: timeIntervals,
                            itemBuilder: (context, index) {
                              return WorkIntervals(index: index);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                      children: [
                        Text(
                          workerText2[2],
                          style: TextStyle(
                              fontSize: 15, fontStyle: FontStyle.italic),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Flexible(
                              child: TextFormField(
                                controller: lengthController,
                                keyboardType: TextInputType.number,
                                validator: (String value) {
                                  if (value.length == 0) {
                                    return workerText2[3];
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: workerText2[4],
                                  border: OutlineInputBorder(),
                                  hintText: workerText2[5],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10.0,
                            ),
                            new Flexible(
                              child: TextFormField(
                                controller: depthController,
                                keyboardType: TextInputType.number,
                                validator: (String value) {
                                  if (value.length == 0) {
                                    return workerText2[6];
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: workerText2[7],
                                  border: OutlineInputBorder(),
                                  hintText: workerText2[8],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Flexible(
                              child: TextFormField(
                                controller: upperWidthController,
                                keyboardType: TextInputType.number,
                                validator: (String value) {
                                  if (value.length == 0) {
                                    return workerText2[9];
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: workerText2[10],
                                  border: OutlineInputBorder(),
                                  hintText: workerText2[11],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            new Flexible(
                              child: TextFormField(
                                controller: lowerWidthController,
                                keyboardType: TextInputType.number,
                                validator: (String value) {
                                  if (value.length == 0) {
                                    return workerText2[12];
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: workerText2[13],
                                  border: OutlineInputBorder(),
                                  hintText: workerText2[14],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: commentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    validator: (String value) {
                      if (value.length == 0) {
                        value = workerText2[15];
                        return null;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: workerText2[16],
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(workerText2[17]),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)
                        ),
                        child: Text(workerText2[18]),
                        onPressed: loadAssets,
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  buildGridView(),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: FlatButton(
                      onPressed:() async{


                         await databaseReference
                          .child("projects").child(projectID)
                          .once()
                          .then((DataSnapshot dataSnapshot) {
                        Map data = dataSnapshot.value;  

                          if(data.containsKey("progress"))
                          {
                            if(Map.from( data["progress"]).containsKey(todaysDate))
                            {
                              debugPrint("======="+workerID.toString());
                              if(Map.from(data["progress"][todaysDate]).containsKey(workerID))
                              {
                                  debugPrint("----------------------------------true");
                                  showToast(workerText2[19]);
                              }
                              else submitForm();
                            }  
                              else submitForm();
                          
                          }
                           else submitForm();

                        });
                        
                        
                      } ,
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          // gradient: gradients(),
                          color: Color(0xff018abd),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            workerText2[20],
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    //child: buttons(context, submitForm, 'Submit', 18),
                  )
                ],
              ),
            )),
      );
    else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class MachineDetails {
  MachineDetails(this.machineID, this.excavation);
  var machineID;
  var excavation;
}

class WorkIntervals extends StatefulWidget {
  final int index;
  WorkIntervals({Key key, this.index}) : super(key: key);

  @override
  _WorkIntervalsState createState() => _WorkIntervalsState();
}

class _WorkIntervalsState extends State<WorkIntervals> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.index != 0
              ? Container(child: Center(child: Text(workerText2[21])))
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    workerText2[22],
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TimePickerSpinner(
                    normalTextStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    highlightedTextStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.deepOrange,
                    ),
                    itemHeight: 30,
                    spacing: 0,
                    minutesInterval: 15,
                    is24HourMode: false,
                    isForce2Digits: true,
                    onTimeChange: (time) {
                      setState(() {
                        startTime[widget.index] = time;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              ),
              Column(
                children: [
                  Text(
                    workerText2[23],
                    style: TextStyle(fontSize: 12),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  TimePickerSpinner(
                    normalTextStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    highlightedTextStyle: TextStyle(
                      fontSize: 15,
                      color: Colors.deepOrange,
                    ),
                    itemHeight: 30,
                    spacing: 0,
                    minutesInterval: 15,
                    is24HourMode: false,
                    isForce2Digits: true,
                    onTimeChange: (time) {
                      setState(() {
                        endTime[widget.index] = time;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ],
      ),
    );
  }
}
