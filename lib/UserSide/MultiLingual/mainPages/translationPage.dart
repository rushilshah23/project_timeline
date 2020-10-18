import 'package:flutter/material.dart';
import 'package:project_timeline/UserSide/Feedback/MainFeedbackPage/feedback.dart';
import 'package:project_timeline/UserSide/MultiLingual/mainPages/language.dart';
import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TranslationSelection extends StatefulWidget {
  @override
  _TranslationSelectionState createState() => _TranslationSelectionState();
}

class _TranslationSelectionState extends State<TranslationSelection> {
  int selected;

  @override
  void initState() {
    selected = 0;
    super.initState();
  }

  setSelectedRadio(int val) {
    setState(() {
      selected = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    var setLang = Provider.of<Language>(context);
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(100, 200, 100, 0),
        child: Center(
          child: Card(
            color: commonBGColor,
            elevation: 15,
            child: Column(
              children: [
                Text(
                  "Choose Your Language",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 25),
                Container(
                    height: 200,
                    child: Column(children: [
                      RadioListTile(
                          title: Text("English"),
                          value: 1,
                          groupValue: selected,
                          onChanged: (val) {
                            setSelectedRadio(val);
                          }),
                      RadioListTile(
                          title: Text("Hindi"),
                          value: 2,
                          groupValue: selected,
                          onChanged: (val) {
                            setSelectedRadio(val);
                          }),
                      RadioListTile(
                          title: Text("Marathi"),
                          value: 3,
                          groupValue: selected,
                          onChanged: (val) {
                            setSelectedRadio(val);
                          }),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 30, top: 10),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text('Default Language is English')),
                        ),
                      ),
                    ])),
                SizedBox(height: 25),
                Container(
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: FlatButton(
                            color: commonBGColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(color: feedbackbuttonColor),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: FlatButton(
                            color: commonBGColor,
                            onPressed: () async {
                              SharedPreferences sharedPreferences =
                                  await SharedPreferences.getInstance();
                              if (selected == 1) {
                                setState(() {
                                  setLang.setLang('en');
                                  print(setLang.languageSelected);
                                  sharedPreferences.setString('language', 'en');
                                });
                              } else if (selected == 2) {
                                setState(() {
                                  setLang.setLang('hi');
                                  print(setLang.languageSelected);
                                  sharedPreferences.setString('language', 'hi');
                                });
                              } else if (selected == 3) {
                                setState(() {
                                  setLang.setLang('mr');
                                  print(setLang.languageSelected);
                                  print(setLang.getLang());
                                  sharedPreferences.setString('language', 'mr');
                                });
                              }
                              setState(() {
                                sharedPreferences.setBool('setLanguage', true);
                              });
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LocalFeedback()));
                            },
                            child: Text(
                              'Continue',
                              style: TextStyle(color: feedbackbuttonColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
