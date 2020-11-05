import 'package:flutter/material.dart';
import 'package:project_timeline/UserSide/AboutUs/Pages/AboutIAHV.dart';
import 'package:project_timeline/UserSide/Feedback/TextPages/IAHVText.dart';
import 'package:project_timeline/UserSide/UI/ColorTheme/Theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainIAHVPage extends StatefulWidget {
  final String title;
  // aboutIAHV({Key key, this.title}) : super(key: key);
  MainIAHVPage({this.title});

  @override
  _MainIAHVPageState createState() => _MainIAHVPageState();
}

class _MainIAHVPageState extends State<MainIAHVPage> {
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
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage('assets/waterimg.jpg'),
        colorFilter:
            ColorFilter.mode(Colors.grey.withOpacity(0.7), BlendMode.dstATop),
      )),
      child: Column(
        children: [
          Text(
            IAHVText[1],
            style: TextStyle(
              color: Colors.white70,
              fontSize: 25.0,
              fontFamily: 'DancingScript',
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
            maxLines: 2,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                children: [
                  Text(
                    IAHVText[2],
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic),
                  ),
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutIAHV()));
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
