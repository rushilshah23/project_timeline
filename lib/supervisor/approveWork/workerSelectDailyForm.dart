import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_absolute_path/flutter_absolute_path.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:project_timeline/CommonWidgets.dart';
import 'package:project_timeline/manager/master/machineMaster/addNewMachine.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import '../../CommonWidgets.dart';

int timeIntervals;
List<DateTime> startTime = List.generate(74, (i) => DateTime.now());
List<DateTime> endTime = List.generate(74, (i) => DateTime.now());


class SpecialWorkerFormPage extends StatefulWidget {
  @override
  _SpecialWorkerFormPageState createState() => _SpecialWorkerFormPageState();
}

class _SpecialWorkerFormPageState extends State<SpecialWorkerFormPage> {
  List<DropdownMenuItem> machines = [];
  List<DropdownMenuItem> workers = [];
  List<WorkerList> workersList = [];
  List<MachineDetails> machineDetails = [];
  var selectedMachine, selectedWorker, machineUsed;
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
      soilType,
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
  var projectID = 'b570da70-fa93-11ea-9561-89a3a74b28bb';
  var workerID;
  var workerName;
  List<Asset> images = List<Asset>();
  String _error = 'No Error Dectected';

  List _uploadedFileURL = [];
  ProgressDialog pr;
  List<File> filesToBeUploaded = [];

  @override
  void initState() {
    setState(() {
      loadData();
    });
    timeIntervals = 1;
    super.initState();
    todaysDate = formatter.format(now);
  }

  Widget buildGridView() {
    return Scaffold(body: Container(
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
        )));
  }

  Future<void> loadAssets() async {
    List<Asset> resultList = List<Asset>();
    String error = 'No Error Dectected';

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
        enableCamera: true,
        selectedAssets: images,
        cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
        materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          actionBarTitle: "Example App",
          allViewTitle: "All Photos",
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
        .child("projects")
        .child(projectID)
        .child("soilType")
        .once()
        .then((snapshot) {
      soilType = snapshot.value;
    });
    await databaseReference
        .child("projects")
        .child(projectID)
        .child("workers")
        .once()
        .then((snapshot) {
      print(snapshot.value);
      snapshot.value.forEach((key, values) {
        setState(() {
          workers.add(
            DropdownMenuItem(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(values["name"].toString()),
                    Text(
                      values["mobile"].toString(),
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              value: key.toString() +
                  "," +
                  values["name"].toString() +
                  "," +
                  values["mobile"].toString(),
            ),
          );
          workersList.add(
              WorkerList(values['name'], values['mobile'], key.toString()));
        });
      });
    });
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
          machineDetails
              .add(MachineDetails(values["machineID"], values["excavation"]));
        });
      });
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
  }

  void submitForm() async {
    if (_formKey.currentState.validate()) {
      print(selectedWorker);
      await pr.show();
      setState(() {
        workerID = selectedWorker.split(",")[0];
        workersList.forEach((worker) {
          if (worker.uid == workerID) workerName = worker.name;
        });
        machineUsed = selectedMachine.split(",")[0];
        hoursWorked = 0;
        for (int i = 0; i < timeIntervals; i++) {
          hoursWorked += endTime[i].difference(startTime[i]).inHours;
        }
        print(hoursWorked);
        machineDetails.forEach((machine) {
          if (machine.machineID == machineUsed) {
            machine.excavation.forEach((exacavation) {
              if (exacavation["soilType"] == soilType) {
                exacavatedPerHour =
                    double.parse(exacavation["amountOfExcavation"]);
              }
            });
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
        print(hoursWorked);
        print(exacavatedPerHour);
        print(estimateVolume);
        print(volume);
        print(workDifference);
        print(workerName);
        print(workerID);
      });

      if (images.length > 0) {
        // await uploadFile();
        addtoDB();
      } else if (images.length == 0) {
        addtoDB();
      }
    }
  }

  addtoDB() async {
    try {
      // await databaseReference
      //     .child("projects")
      //     .child(projectID)
      //     .child("progress")
      //     .child("12-09-2020")
      //     .child(workerID)
      //     .set({
      //   "MachineUsed": machineUsed,
      //   "hoursWorked": hoursWorked,
      //   'intervals': {
      //     for (int i = 0; i < timeIntervals; i++)
      //       '$i': {
      //         'startTime': startTime[i].toString(),
      //         'endTime': endTime[i].toString(),
      //       }
      //   },
      //   'images': {
      //     for (int i = 0; i < _uploadedFileURL.length; i++)
      //       '$i': _uploadedFileURL[i].toString(),
      //   },
      //   "workerName": workerName,
      //   "depth": depth,
      //   "length": length,
      //   "upperWidth": upperWidth,
      //   "lowerWidth": lowerWidth,
      //   "volumeExcavated": volume,
      //   "estimatedVolume": estimateVolume,
      //   "workDifference": workDifference,
      //   "result": estimation,
      //   "status": "Pending",
      //   "comment": comment,
      // });

      pr.hide().then((isHidden) {
        showToast("Added successfully");
      });
    } catch (e) {
      showToast("Failed. Check your Internet");
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

            height: MediaQuery.of(context).size.height-100,
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Center(
                  child: titleStyles('For :' + todaysDate, 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SearchableDropdown.single(
                    items: workers,
                    value: null,
                    hint: "Select one",
                    searchHint: "Select one",
                    onChanged: (value) {
                      setState(() {
                        selectedWorker = value;
                        print(selectedWorker);
                      });
                    },
                    isExpanded: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SearchableDropdown.single(
                    items: machines,
                    value: null,
                    hint: "Select one",
                    searchHint: "Select one",
                    onChanged: (value) {
                      setState(() {
                        selectedMachine = value;
                        print(selectedMachine);
                      });
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
                              'Hours Worked',
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
                          'Digging Dimensions',
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
                                    return "Please enter Length";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "Length ",
                                  border: OutlineInputBorder(),
                                  hintText: "Enter LengthController",
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
                                    return "Please Enter Depth";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "Depth",
                                  border: OutlineInputBorder(),
                                  hintText: "Enter Depth",
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
                                    return "Please Enter Upper Width";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "Upper Width",
                                  border: OutlineInputBorder(),
                                  hintText: "Enter Upper Width",
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
                                    return "Please Enter Lower Width";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: "Lower Width",
                                  border: OutlineInputBorder(),
                                  hintText: "Enter Lower Width",
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
                        value = "No comment";
                        return null;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "(Optional) Comment",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Upload Photos"),
                      RaisedButton(
                        child: Text("Pick images"),
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
                      onPressed: () => submitForm(),
                      child: buttonContainers(double.infinity, 20, 'Submit', 18),
                    ),
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

class WorkerList {
  WorkerList(this.name, this.mobile, this.uid);
  var name;
  var mobile;
  var uid;
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
              ? Container(child: Center(child: Text("BREAK")))
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    "START",
                    style: TextStyle(fontSize: 12),
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
                    itemHeight: 20,
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
                    "END",
                    style: TextStyle(fontSize: 12),
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
                    itemHeight: 20,
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