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
import 'package:project_timeline/admin/CommonWidgets.dart';

int timeIntervals;
List<DateTime> startTime = List.generate(74, (i) => DateTime.now());
List<DateTime> endTime = List.generate(74, (i) => DateTime.now());

class SpecialWorkerFormPage extends StatefulWidget {
  String name, email, mobile, password, uid, userType, assignedProject;
  SpecialWorkerFormPage(
      {Key key,
      this.name,
      this.email,
      this.mobile,
      this.assignedProject,
      this.userType,
      this.uid})
      : super(key: key);
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
  String projectID;
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
      projectID = widget.assignedProject;
      loadData();
      timeIntervals = 1;
      todaysDate = formatter.format(now);
    });
    super.initState();
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
    String error = superText4[19];

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
        .child(widget.assignedProject)
        .child("soilType")
        .once()
        .then((snapshot) {
      soilType = snapshot.value;
    });
    await databaseReference
        .child("projects")
        .child(widget.assignedProject)
        .once()
        .then((snapshot) {
      print(snapshot.value);
      Map data = snapshot.value;
      //debugPrint(data.toString());
      if (data.containsKey("workers")) {
        Map data = snapshot.value["workers"];
        data.forEach((key, values) {
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
      }
    });
    await databaseReference
        .child("masters")
        .child("machineMaster")
        .once()
        .then((snapshot) {
      snapshot.value.forEach((key, values) {
        print(values);
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
          machineDetails.add(
            MachineDetails(values["machineID"], values["amountOfExcavation"]),
          );
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
            print("MAchine Selected Here");
            print(machine.excavation);
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
        print(hoursWorked);
        print(exacavatedPerHour);
        print(estimateVolume);
        print(volume);
        print(workDifference);
        print(workerName);
        print(workerID);
      });
      if (images.length > 0) {
        await uploadFile();
        addtoDB();
      } else if (images.length == 0) {
        addtoDB();
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
        showToast(superText4[20]);
        //Navigator.of(context).pop();
      });
    } catch (e) {
      pr.hide().then((isHidden) {
        showToast(superText4[21]);
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
                    child: titleStyles(superText4[22], 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: titleStyles(superText4[23] + todaysDate, 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SearchableDropdown.single(
                    items: workers,
                    value: selectedWorker,
                    hint: superText4[24],
                    searchHint: superText4[24],
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
                    value: selectedMachine,
                    hint: superText4[24],
                    searchHint: superText4[24],
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
                              superText4[25],
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
                          superText4[26],
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
                                    return "Please enter the length";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: superText4[27],
                                  border: OutlineInputBorder(),
                                  hintText: superText4[28],
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
                                    return superText4[29];
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: superText4[30],
                                  border: OutlineInputBorder(),
                                  hintText: superText5[0],
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
                                    return superText5[1];
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: superText5[2],
                                  border: OutlineInputBorder(),
                                  hintText: superText5[3],
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
                                    return superText5[4];
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: superText5[5],
                                  border: OutlineInputBorder(),
                                  hintText: superText5[6],
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
                        value = superText5[7];
                        return null;
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: superText5[8],
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(superText5[9]),
                      RaisedButton(
                        child: Text(superText5[10]),
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
                      onPressed: () async {
                        await databaseReference
                            .child("projects")
                            .child(projectID)
                            .once()
                            .then((DataSnapshot dataSnapshot) {
                          Map data = dataSnapshot.value;

                          if (data.containsKey("progress")) {
                            debugPrint("======1");
                            debugPrint("======1" +
                                selectedWorker.split(",")[0].toString() +
                                "       " +
                                todaysDate.toString());
                            if (Map.from(data["progress"])
                                .containsKey(todaysDate)) {
                              debugPrint("======2");
                              if (Map.from(data["progress"][todaysDate])
                                  .containsKey(selectedWorker.split(",")[0])) {
                                debugPrint(
                                    "----------------------------------true");
                                showToast(superText5[11]);
                              } else
                                submitForm();
                            } else
                              submitForm();
                          } else
                            submitForm();
                        });
                      },
                      child:
                          buttonContainers(double.infinity, superText5[12], 18),
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
              ? Container(child: Center(child: Text(superText5[13])))
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    superText5[14],
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
                    superText5[15],
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
