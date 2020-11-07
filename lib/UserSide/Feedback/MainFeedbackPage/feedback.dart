import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:project_timeline/UserSide/Dashboard/Widgets/BottomNav.dart';
import 'package:project_timeline/UserSide/Feedback/TextPages/feedbackText.dart';
import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/multilingual/app_localizations.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Feedback extends StatefulWidget {
  @override
  _FeedbackState createState() => _FeedbackState();
}

class _FeedbackState extends State<Feedback> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: Theme.of(context),
        title: "Local Feedback",
        home: Builder(builder: (BuildContext context) => LocalFeedback()));
  }
}

class LocalFeedback extends StatefulWidget {
  @override
  _LocalFeedbackState createState() => _LocalFeedbackState();
}

class _LocalFeedbackState extends State<LocalFeedback> {
  TextEditingController _name = new TextEditingController();
  TextEditingController _contactNumber = new TextEditingController();
  TextEditingController _email = new TextEditingController();
  TextEditingController _feedback = new TextEditingController();
  TextEditingController _suggestions = new TextEditingController();
  TextEditingController _ratings = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _groundWater1 = new TextEditingController();
  TextEditingController _groundWater2 = new TextEditingController();
  TextEditingController _crop1 = new TextEditingController();
  TextEditingController _crop2 = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final databaseReference = FirebaseDatabase.instance.reference();
  List<DropdownMenuItem> projectsDropdwnItems = [];
  String selectedProject;

  bool feedback;
  SharedPreferences sharedPreferences;
  String language;

  @override
  void initState() {
    getProjectsData();
    super.initState();
  }

  void submitLocalFeedback() {
    FirebaseDatabase firebaseDatabase = FirebaseDatabase.instance;
    DatabaseReference databaseReference = firebaseDatabase.reference();

    databaseReference
        .child('projects')
        .child(selectedProject)
        .child("localFeedback")
        .push()
        .set({
      'name': _name.text,
      'contactNumber': _contactNumber.text,
      'email': _email.text,
      'address': _address.text,
      // 'waterexcbef': waterexcbef.text,
      // 'waterexcaft': waterexcaft.text,
      // 'cropprodbef': cropprodbef.text,
      // 'cropprodaft': cropprodaft.text,
      'feedback': _feedback.text,
      'suggestions': _suggestions.text,
      'groundwater level before': _groundWater1.text,
      'groundwater level after': _groundWater2.text,
      'crop production before': _crop1.text,
      'crop production after': _crop2.text,
      'timestamp': new DateFormat.yMd().add_jm().format(new DateTime.now()),
    });
  }

  void clearControllers() {
    _name.clear();
    _contactNumber.clear();
    _email.clear();
    _feedback.clear();
    _suggestions.clear();
    _ratings.clear();
    // waterexcaft.clear();
    // waterexcbef.clear();
    // cropprodaft.clear();
    // cropprodbef.clear();
  }

  Future<void> _showMyDialog() async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: commonBGColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              feedbackText[28],
              style: TextStyle(
                letterSpacing: 2.0,
                fontWeight: FontWeight.normal,
                fontSize: 25,
                color: darkestColor,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              mainAxis: Axis.vertical,
              children: <Widget>[
                Center(
                  child: Text(
                    feedbackText[29],
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              // hoverColor: Colors.red[400],
              color: commonBGColor,
              child: Text(
                feedbackText[30],
                style: TextStyle(color: feedbackbuttonColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          // backgroundColor: Colors.white[400],
          elevation: 58.0,
          // shape: CircleBorder(),
        );
      },
    );
  }

  String nameValidator(value) {
    if (value.isEmpty) {
      return feedbackText[16];
    } else
      return null;
  }

  String contactValidator(value) {
    if (value.isEmpty) {
      return feedbackText[17];
    }
    final n = num.tryParse(value);
    if (n == null) {
      return feedbackText[18];
    } else if (n > 9999999999 || n < 1000000000) {
      return feedbackText[18];
    } else
      return null;
  }

  String emailValidator(value) {
    if (value.isEmpty) {
      // return feedbackText[19];
      return null;
    } else if (value.toString().contains('@') &&
        value.toString().contains('.')) {
      return null;
    } else
      return feedbackText[20];
  }

  String addressValidator(value) {
    if (value.isEmpty) {
      return feedbackText[21];
    } else
      return null;
  }

  String feedbackValidator(value) {
    if (value.isEmpty) {
      return feedbackText[22];
    } else
      return null;
  }

  TextFormField fields(
      {String decorationText,
      String labelText,
      TextEditingController controllername,
      Function validateFunction,
      List<TextInputFormatter> numFormatter,
      int maxlines,
      int maxlen,
      TextInputType keyboard,
      String compulsory}) {
    return TextFormField(
      maxLines: maxlines,
      maxLength: maxlen,
      controller: controllername,
      decoration: InputDecoration(
          labelText: labelText + compulsory,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: feedbacktextformfieldColor),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: feedbacktextformfieldColor),
          ),
          hintText: '$decorationText'),
      cursorWidth: 2,
      inputFormatters: numFormatter,
      keyboardType: keyboard,
      validator: validateFunction,
    );
  }

  Future<void> getProjectsData() async {
    databaseReference
        .child("projects")
        .once()
        .then((DataSnapshot dataSnapshot) {
      Map projMap = dataSnapshot.value;

      // debugPrint(projects.toString());
      projMap.values.toList().forEach((result) {
        setState(() {
          // Map resultMap = result;
          // if(resultMap.containsKey("progress")){
          projectsDropdwnItems.add(
            DropdownMenuItem(
              child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(result['projectName']),
                      Text(
                        result['siteAddress'],
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  )),
              value: result['projectID'],
            ),
          );
          // }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: plainAppBar(
            context: context,
            title: AppLocalizations.of(context).translate('fb1')),
        // appBar: ThemeAppbar('Feedback', context),
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   backgroundColor: appbarColor,
        //   title: Text(feedbackText[8]),
        //   centerTitle: true,
        //   leading: GestureDetector(
        //     child: Icon(Icons.arrow_back),
        //     onTap: () {
        //       Navigator.push(context,
        //           MaterialPageRoute(builder: (context) => BottomNav()));
        //     },
        //   ),
        // ),
        body: Container(
          margin: EdgeInsets.fromLTRB(18, 8, 18, 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Center(
                              child: new DropdownButtonFormField(
                                validator: (value) =>
                                    value == null ? 'Select Project' : null,
                                items: projectsDropdwnItems,
                                onChanged: (selectedAccountType) {
                                  setState(() {
                                    selectedProject = selectedAccountType;
                                    debugPrint(selectedProject);
                                  });
                                },
                                value: selectedProject,
                                isDense: false,
                                isExpanded: true,
                                hint: Text(
                                  AppLocalizations.of(context).translate('fb3'),
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        fields(
                            // labelText: feedbackText[0],
                            labelText:
                                AppLocalizations.of(context).translate('fb2'),
                            decorationText: feedbackText[10],
                            controllername: _name,
                            validateFunction: nameValidator,
                            compulsory: "*"),
                        SizedBox(
                          height: 20,
                        ),
                        fields(
                          labelText:
                              AppLocalizations.of(context).translate('fb4'),

                          // labelText: feedbackText[1],
                          keyboard: TextInputType.number,
                          decorationText: feedbackText[11],
                          controllername: _contactNumber,
                          // validateFunction: contactValidator,
                          numFormatter: [
                            FilteringTextInputFormatter.digitsOnly
                            // WhitelistingTextInputFormatter.digitsOnly
                          ],
                          compulsory: "",
                          maxlen: 10,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        fields(
                            labelText: feedbackText[2],
                            decorationText: feedbackText[12],
                            controllername: _email,
                            validateFunction: emailValidator,
                            compulsory: ""),
                        SizedBox(
                          height: 20,
                        ),
                        // fields(
                        //   labelText: feedbackText[3],
                        //   decorationText: feedbackText[13],
                        //   controllername: _address,
                        //   validateFunction: addressValidator,
                        //   compulsory: "*",
                        // ),
                        SizedBox(
                          height: 20,
                        ),
                        fields(
                            labelText: feedbackText[4],
                            decorationText: feedbackText[4],
                            controllername: _groundWater1,
                            maxlen: 150,
                            maxlines: 3,
                            compulsory: ""),
                        SizedBox(
                          height: 20,
                        ),
                        fields(
                            labelText: feedbackText[5],
                            decorationText: feedbackText[5],
                            controllername: _groundWater2,
                            maxlen: 150,
                            maxlines: 3,
                            compulsory: ""),
                        SizedBox(
                          height: 20,
                        ),
                        fields(
                            labelText: feedbackText[6],
                            decorationText: feedbackText[6],
                            controllername: _crop1,
                            maxlen: 150,
                            maxlines: 2,
                            compulsory: ""),
                        SizedBox(
                          height: 20,
                        ),
                        fields(
                            labelText: feedbackText[7],
                            decorationText: feedbackText[7],
                            controllername: _crop2,
                            maxlen: 150,
                            maxlines: 2,
                            compulsory: ""),
                        SizedBox(
                          height: 20,
                        ),
                        fields(
                            labelText: feedbackText[8],
                            decorationText: feedbackText[14],
                            controllername: _feedback,
                            validateFunction: feedbackValidator,
                            maxlen: 300,
                            maxlines: 5,
                            compulsory: "*"),
                        SizedBox(
                          height: 20,
                        ),
                        fields(
                            labelText: feedbackText[9],
                            controllername: _suggestions,
                            decorationText: feedbackText[15],
                            maxlen: 300,
                            maxlines: 5,
                            compulsory: ""),
                        SizedBox(
                          height: 20,
                        ),
                        Builder(
                          builder: (BuildContext context) => Container(
                              child: Center(
                            child: FlatButton(
                              child: buttonContainers(
                                  MediaQuery.of(context).size.width - 10,
                                  'Submit',
                                  18),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  try {
                                    submitLocalFeedback();
                                    _name.clear();
                                    _contactNumber.clear();
                                    _email.clear();
                                    _feedback.clear();
                                    _suggestions.clear();
                                    _ratings.clear();
                                    _address.clear();
                                    _showMyDialog();
                                    _groundWater1.clear();
                                    _groundWater2.clear();
                                    _crop1.clear();
                                    _crop2.clear();

                                    // Scaffold.of(context).showSnackBar(SnackBar(
                                    //     content: Text("Feedback recorded")));
                                  } catch (error) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content: Text("Something went wrong")));
                                    return feedbackText[24];
                                  }

                                  // return null;
                                } else {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(feedbackText[25]),
                                    duration: Duration(seconds: 1),
                                  ));
                                  return feedbackText[26];
                                }
                              },
                            ),
                          )),
                        ),
                      ],
                    ))
              ],
            ),
          ),
        ));
  }
}
