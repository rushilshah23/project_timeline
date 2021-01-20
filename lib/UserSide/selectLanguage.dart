import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_timeline/admin/CommonWidgets.dart';
import 'package:project_timeline/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_timeline/languages/setLanguageText.dart';

String selectedLanguage = 'en';

class SelectLanguage extends StatefulWidget {
  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  List languages = [
    "en",
    "hi",
    "mr",
  ];

  getLanguageText() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    selectedLanguage = _sharedPreferences.getString('language') ?? "en";
    setState(() {});
  }

  @override
  void initState() {
    getLanguageText();
    super.initState();
  }

  Future<void> changeLanguage(String lang) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('language', lang);

    showToast(homePageTranslationText[9]);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar:
            plainAppBar(context: context, title: homePageTranslationText[5]),
        body: Container(
            child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(homePageTranslationText[6]),
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
              title: Text(homePageTranslationText[7]),
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
              title: Text(homePageTranslationText[8]),
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
              child: buttonContainers(
                  double.infinity, homePageTranslationText[5], 18),
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
