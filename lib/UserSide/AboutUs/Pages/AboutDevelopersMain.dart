import 'package:flutter/material.dart';
import 'package:link/link.dart';
import 'package:project_timeline/UserSide/AboutUs/Pages/AboutDevelopers.dart';

import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';
import 'package:project_timeline/languages/setLanguageText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDevelopersPage extends StatefulWidget {
  final String title;
  // aboutIAHV({Key key, this.title}) : super(key: key);
  MainDevelopersPage({this.title});

  @override
  _MainDevelopersPageState createState() => _MainDevelopersPageState();
}

class _MainDevelopersPageState extends State<MainDevelopersPage> {
  SharedPreferences sharedPreferences;
  String language;

  void initState() {
    print("in homepage");
    // _languageHome = context.read<Language>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/waterimg.jpg'),
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.7), BlendMode.darken),
        fit: BoxFit.fitHeight,
      )),
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
                width: 250.0,
                height: 200.0,
                decoration: new BoxDecoration(
                    shape: BoxShape.circle,
                    image: new DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage('assets/sakeclogo.jpg')))),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Text(
                    developersTranslationText[1],
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 25),
                  Link(
                    child: Text(
                      developersTranslationText[2],
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                          fontSize: 18,
                          color: commonBGColor,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic),
                    ),
                    url: 'https://www.shahandanchor.com/home/',
                  ),
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DevelopersPage()));
                        },
                        child: Text('Read More...',
                            style: TextStyle(
                                color: readMoreColor,
                                fontSize: 20,
                                fontWeight: FontWeight.bold))),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
