import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguage extends StatefulWidget {
  SelectLanguage({Key key}) : super(key: key);

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  List languages = [
    "en",
    "hi",
    "mr",
  ];
  String selectedLanguage = "en";

  Future<void> changeLanguage(String lang) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('toLanguage', lang);

    showToast("Language Changed Successfully");
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: plainAppBar(context: context, title: "Change Language"),
        body: Container(
            child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("English"),
              leading: Radio(
                value: languages[0],
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Hindi"),
              leading: Radio(
                value: languages[1],
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Marathi'),
              leading: Radio(
                value: languages[2],
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value;
                  });
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            FlatButton(
              child: buttonContainers(double.infinity, "Change Language", 18),
              onPressed: () async {
                debugPrint(selectedLanguage.toString());
                await changeLanguage(selectedLanguage.toString());
                // Navigator.popUntil(context, (route) => false);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                    (Route<dynamic> route) => false);
              },
            ),
          ],
        )));
  }
}
